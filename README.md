# terakube-showcase
Showcase of using Terraform for setting up Kubernetes clusters for hosting data pipelines and CI/CD tools like ArgoCD and Tekton.

## Dependencies

### Helm
For instructions on how to install Helm, please refer to the [official Helm installation guide](https://helm.sh/docs/intro/install/).

### ArgoCD Installation

Follow these steps to install ArgoCD:

1. **Add the ArgoCD Helm repository:**
    ```bash
    helm repo add argo https://argoproj.github.io/argo-helm
    ```

2. **Update your Helm repositories:**
    ```bash
    helm repo update
    ```

3. **Create a namespace for ArgoCD:**
    ```bash
    kubectl create namespace argocd
    ```

4. **Install ArgoCD in the `argocd` namespace:**
    ```bash
    helm install argocd argo/argo-cd --namespace argocd
    ```





