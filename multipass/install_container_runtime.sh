#!/bin/bash

# Define variables for platform binaries and versions
CONTAINERD_VERSION="1.7.14"
RUNC_VERSION="1.1.12"
CNI_PLUGINS_VERSION="1.4.1"
CPU="amd64"
PLATFORM="linux-"$CPU


# Download and install containerd
curl -LO https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}/containerd-${CONTAINERD_VERSION}-${PLATFORM}.tar.gz
sudo tar Cxzvf /usr/local containerd-${CONTAINERD_VERSION}-${PLATFORM}.tar.gz

# Download and install containerd service
curl -LO https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
sudo mkdir -p /usr/local/lib/systemd/system/
sudo mv containerd.service /usr/local/lib/systemd/system/

# Configure containerd
sudo mkdir -p /etc/containerd/
sudo containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

# Enable and start containerd service
sudo systemctl daemon-reload
sudo systemctl enable --now containerd

# Check that containerd service is up and running
if systemctl is-active --quiet containerd; then
    echo "containerd service is up and running."
else
    echo "containerd service failed to start."
    exit 1
fi

# Download and install runc
curl -LO https://github.com/opencontainers/runc/releases/download/v${RUNC_VERSION}/runc.${CPU}
sudo install -m 755 runc.${CPU} /usr/local/sbin/runc

# Download and install CNI plugins
curl -LO https://github.com/containernetworking/plugins/releases/download/v${CNI_PLUGINS_VERSION}/cni-plugins-${PLATFORM}-v${CNI_PLUGINS_VERSION}.tgz
sudo mkdir -p /opt/cni/bin
sudo tar Cxzvf /opt/cni/bin cni-plugins-${PLATFORM}-v${CNI_PLUGINS_VERSION}.tgz

# Install Kubernetes components
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Check that kubeadm, kubelet, and kubectl are working
if command -v kubeadm >/dev/null 2>&1 && command -v kubelet >/dev/null 2>&1 && command -v kubectl >/dev/null 2>&1; then
    echo "kubeadm, kubelet, and kubectl are installed and working."
else
    echo "Failed to install kubeadm, kubelet, or kubectl."
    exit 1
fi

# Configure crictl to work with containerd
sudo crictl config runtime-endpoint unix:///var/run/containerd/containerd.sock
