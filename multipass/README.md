# Local Kubernetes kluster in Windows

Set up Kubernetes locally with multipass 

## Set up

### Install Multipass

Follow instructions here: https://multipass.run/docs/install-multipass

### Set up internal network

In Hiper-V Manager -> Virtual Switch Manager -> Create "INTERNAL" virtual switch with name multipass

### Create VMs

Note that we use the multipass network and different made up mac adresses.

```
multipass launch --disk 10G --memory 3G --cpus 2 --name kubemaster --network name=multipass,mode=manual,mac="52:54:00:4b:ab:cd" jammy
multipass launch --disk 10G --memory 3G --cpus 2 --name kubeworker01 --network name=multipass,mode=manual,mac="52:54:00:4b:ba:dc" jammy
multipass launch --disk 10G --memory 3G --cpus 2 --name kubeworker02 --network name=multipass,mode=manual,mac="52:54:00:4b:cd:ab" jammy
```

### Set up static ips

#### Get subnet for multipass internal network

Use a command like ipconfig, in my case I see  IPv4 Address 169.254.10.146 for the multipass network so we choose ips that belong to same subnet: 169.254.10.101, 169.254.10.102, 169.254.10.103 for our VMs.


#### Apply the static IPs

After setting the static ips search in scripts for the example ips and replace with your ips.

```
multipass exec -n kubemaster -- sudo bash -c 'cat << EOF > /etc/netplan/10-custom.yaml
network:
  version: 2
  ethernets:
    extra0:
      dhcp4: no
      match:
        macaddress: "52:54:00:4b:ab:cd"
      addresses: [169.254.10.101/24]
EOF'

multipass exec -n kubemaster -- sudo netplan apply

# Check that static ip is set now
multipass info kubemaster | grep IPv4 -A1

multipass exec -n kubeworker01 -- sudo bash -c 'cat << EOF > /etc/netplan/10-custom.yaml
network:
  version: 2
  ethernets:
    extra0:
      dhcp4: no
      match:
        macaddress: "52:54:00:4b:ba:dc"
      addresses: [169.254.10.102/24]
EOF'

multipass exec -n kubeworker01 -- sudo netplan apply
# Check that static ip is set now
multipass info kubeworker01 | grep IPv4 -A1

multipass exec -n kubeworker02 -- sudo bash -c 'cat << EOF > /etc/netplan/10-custom.yaml
network:
  version: 2
  ethernets:
    extra0:
      dhcp4: no
      match:
        macaddress: "52:54:00:4b:cd:ab"
      addresses: [169.254.10.103/24]
EOF'

multipass exec -n kubeworker02 -- sudo netplan apply
# Check that static ip is set now
multipass info kubeworker02 | grep IPv4 -A1
```

### Configure the local DNS

Add to /etc/hosts
```
169.254.10.101 kubemaster
169.254.10.102 kubeworker01
169.254.10.103 kubeworker02
```

Here is how to edit /etc/hosts in each VM

```
multipass shell kubemaster

sudo vi /etc/hosts
# Add the rows above


multipass shell kubeworker01
sudo vi /etc/hosts
# Add the rows above

multipass shell kubeworker02
sudo vi /etc/hosts
# Add the rows above

```