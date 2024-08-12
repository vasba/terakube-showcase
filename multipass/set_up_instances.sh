#!/bin/bash

multipass launch --disk 10G --memory 3G --cpus 2 --name kubemaster --network name=multipass,mode=manual,mac="52:54:00:4b:ab:cd" jammy
multipass launch --disk 10G --memory 3G --cpus 2 --name kubeworker01 --network name=multipass,mode=manual,mac="52:54:00:4b:ba:dc" jammy
multipass launch --disk 10G --memory 3G --cpus 2 --name kubeworker02 --network name=multipass,mode=manual,mac="52:54:00:4b:cd:ab" jammy

multipass exec -n kubemaster -- sudo bash -c 'cat << EOF > /etc/netplan/10-custom.yaml
network:
  version: 2
  ethernets:
    extra0:
      dhcp4: no
      match:
        macaddress: "52:54:00:4b:ab:cd"
      addresses: ['"$ip_subnet"'.101/24]
EOF'

multipass exec -n kubemaster -- sudo netplan apply

# Check that static ip is set now
if ! multipass info kubemaster | grep -q "'$ip_subnet'.101"; then
  echo "Static IP not set for kubemaster"
  exit 1
fi

# Comment out the update_etc_hosts line in /etc/cloud/cloud.cfg
multipass exec -n kubemaster -- sudo bash -c "sed -i 's/\(.*update_etc_hosts.*\)/#\1/' /etc/cloud/cloud.cfg"

# Add entry to /etc/hosts
multipass exec -n kubemaster -- sudo bash -c 'echo "'$ip_subnet'.101 kubemaster" >> /etc/hosts'
multipass exec -n kubemaster -- sudo bash -c 'echo "'$ip_subnet'.102 kubeworker01" >> /etc/hosts'
multipass exec -n kubemaster -- sudo bash -c 'echo "'$ip_subnet'.103 kubeworker02" >> /etc/hosts'


multipass exec -n kubeworker01 -- sudo bash -c 'cat << EOF > /etc/netplan/10-custom.yaml
network:
  version: 2
  ethernets:
    extra0:
      dhcp4: no
      match:
        macaddress: "52:54:00:4b:ba:dc"
      addresses: ['"$ip_subnet"'.102/24]
EOF'

multipass exec -n kubeworker01 -- sudo netplan apply

# Check that static ip is set now
if ! multipass info kubeworker01 | grep -q "'$ip_subnet'.102"; then
  echo "Static IP not set for kubeworker01"
  exit 1
fi

# Comment out the update_etc_hosts line in /etc/cloud/cloud.cfg
multipass exec -n kubeworker01 -- sudo bash -c "sed -i 's/\(.*update_etc_hosts.*\)/#\1/' /etc/cloud/cloud.cfg"


# Add entry to /etc/hosts
multipass exec -n kubeworker01 -- sudo bash -c 'echo "'$ip_subnet'.101 kubemaster" >> /etc/hosts'
multipass exec -n kubeworker01 -- sudo bash -c 'echo "'$ip_subnet'.102 kubeworker01" >> /etc/hosts'
multipass exec -n kubeworker01 -- sudo bash -c 'echo "'$ip_subnet'.103 kubeworker02" >> /etc/hosts'

multipass exec -n kubeworker02 -- sudo bash -c 'cat << EOF > /etc/netplan/10-custom.yaml
network:
  version: 2
  ethernets:
    extra0:
      dhcp4: no
      match:
        macaddress: "52:54:00:4b:cd:ab"
      addresses: ['"$ip_subnet"'.103/24]
EOF'

multipass exec -n kubeworker02 -- sudo netplan apply

# Check that static ip is set now
if ! multipass info kubeworker02 | grep -q "'$ip_subnet'.103"; then
  echo "Static IP not set for kubeworker02"
  exit 1
fi

# Comment out the update_etc_hosts line in /etc/cloud/cloud.cfg
multipass exec -n kubeworker02 -- sudo bash -c "sed -i 's/\(.*update_etc_hosts.*\)/#\1/' /etc/cloud/cloud.cfg"


# Add entry to /etc/hosts
multipass exec -n kubeworker02 -- sudo bash -c 'echo "'$ip_subnet'.101 kubemaster" >> /etc/hosts'
multipass exec -n kubeworker02 -- sudo bash -c 'echo "'$ip_subnet'.102 kubeworker01" >> /etc/hosts'
multipass exec -n kubeworker02 -- sudo bash -c 'echo "'$ip_subnet'.103 kubeworker02" >> /etc/hosts'