#!/bin/bash

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# Verify that the br_netfilter, overlay modules are loaded by running the following commands:
lsmod | grep br_netfilter
lsmod | grep overlay

#Verify that the net.bridge.bridge-nf-call-iptables, net.bridge.bridge-nf-call-ip6tables, and net.ipv4.ip_forward system variables are set to 1 in your sysctl config by running the following command:
sysctl_output=$(sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward)

# Print the sysctl response
echo "$sysctl_output"

# Check if the sysctl parameters are set correctly
if [ "$(sysctl -n net.bridge.bridge-nf-call-iptables)" -ne 1 ] || \
   [ "$(sysctl -n net.bridge.bridge-nf-call-ip6tables)" -ne 1 ] || \
   [ "$(sysctl -n net.ipv4.ip_forward)" -ne 1 ]; then
  echo "Error: One or more sysctl parameters are not set correctly."
  exit 1
fi