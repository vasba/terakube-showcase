#!/bin/bash

# set apiserver-advertise-address to the IP address of the kubemaster VM
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=169.254.10.101

# Configure kubectl to work with non-root user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Verify that the cluster is up and running
kubectl -n kube-system get pods

#Install a Pod network add-on
kubectl apply -f https://reweave.azurewebsites.net/k8s/v1.28/net.yaml

