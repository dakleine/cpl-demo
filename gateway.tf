resource "kubernetes_namespace" "gateway-ns" {
  metadata {
    name = "gateway-ns"
  }
}

resource "kubernetes_secret" "cert" {
  metadata {
    name = "gateway-secret"
    namespace = "gateway-ns"
  }

  data = {
    "tls.crt" = base64decode(var.gateway-crt)
    "tls.key" = base64decode(var.gateway-key)
  }

  type = "kubernetes.io/tls"
}

resource "kubectl_manifest" "gateway" {
  yaml_body     = <<YAML
apiVersion: gateway.networking.k8s.io/v1beta1
kind: Gateway
metadata:
  name: external-gateway
  namespace: gateway-ns
spec:
  gatewayClassName: gke-l7-global-external-managed
  listeners:
  - name: https
    protocol: HTTPS
    port: 443
    allowedRoutes:
      namespaces:
        from: Selector
        selector:
          matchLabels:
            kubernetes.io/metadata.name: "hello"
    tls:
      certificateRefs:
      - name: gateway-secret
YAML
}