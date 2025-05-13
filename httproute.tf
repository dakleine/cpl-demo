resource "kubectl_manifest" "httproute" {
  depends_on = [kubernetes_namespace.hello]
  yaml_body  = <<YAML
kind: HTTPRoute
apiVersion: gateway.networking.k8s.io/v1beta1
metadata:
  name: app-route
  namespace: hello
spec:
  parentRefs:
  - name: external-gateway
    namespace: gateway-ns
  rules:
  - matches:
    - path:
        value: /
    backendRefs:
    - name: example-hello-loadbalancer
      port: 80
YAML
}