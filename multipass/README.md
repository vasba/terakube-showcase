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

# In case netplan apply takes too long time in the script below 
# run the commands individually by copy and paste in the console

export ip_subnet="169.254.27" # your multipass brige subnet here!!!!!!!

# Also add it to setup_workers.sh

multipass/set_up_instances.sh
cd multipass

#Modify to arm binaries in install_container_runtime.sh before running the script below
./install_configure_vms.sh

# copy the join from the last print out from the before command
# looks like --- kubeadm join kubemaster and paste it into setup_worker.sh

./setup_workers.sh


```


## Tips

### move ssh key to multipass instance


```
# move public key to instance (assuming you are in the home directory) and public key is named id_rsa

multipass transfer .ssh/id_rsa.pub "$instance:.ssh/id_rsa.pub"
multipass exec $instance -- bash -c 'cat ~/.ssh/id_rsa.pub | cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'

```