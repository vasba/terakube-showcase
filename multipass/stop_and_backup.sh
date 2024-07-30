

#  Backup, a corrupt Kubernetes cluster can be restored to a previous working state.

# Define an array of worker names
workers=("kubeworker01" "kubeworker02")
instances=("kubemaster" "${workers[@]}")

