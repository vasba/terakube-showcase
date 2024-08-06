#!/bin/bash

# Join the worker nodes to the cluster after fetching the tokens  fron the
# result of the kubeadm init command on the master node
sudo kubeadm join kubemaster:6443 --token ltaoff.fzd7zyx4nqpc01hl \
        --discovery-token-ca-cert-hash sha256:5b6660c59280663ba8614a4494525e77ea8510cf52e3c1ca3eadd4e71c4890a7
