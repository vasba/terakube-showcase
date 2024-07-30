#!/bin/bash

# Join the worker nodes to the cluster
sudo kubeadm join 169.254.10.101:6443 --token tn082a..... \
--discovery-token-ca-cert-hash sha256:c1b0143a.....

