# Add the ArgoCD helm repository and install ArgoCD in kurren kube context
helm repo add argo-cd https://argoproj.github.io/argo-helm
helm repo update
kubectl create namespace argocd
helm install argocd argo-cd/argo-cd -n argocd

# Change the ArgoCD Server service type to LoadBalancer
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
# use "minikube tunnel" to access the service from another shell with adress "https://localhost"
# or "kubectl port-forward svc/argocd-server -n argocd 8080:443 --address 0.0.0.0" with adress "https://localhost:8080"

# Get the external IP of the ArgoCD Server (in another shell when minikube tunnel running or when using kubectl port-forward)
kubectl get svc argocd-server -n argocd