#!/bin/bash

# Define an array of instance names

# Define an array of worker names
workers=("kubeworker01" "kubeworker02")
instances=("kubemaster" "${workers[@]}")

# Loop through each instance and transfer and execute the script
for instance in "${instances[@]}"; do
  echo "Configuring $instance..."
  multipass transfer install_configure_vm.sh "$instance:/home/ubuntu/install_configure_vm.sh"
  multipass transfer forward_ipv4.sh "$instance:/home/ubuntu/forward_ipv4.sh"
  multipass transfer install_container_runtime.sh "$instance:/home/ubuntu/install_container_runtime.sh"
  multipass exec -n "$instance" -- sudo bash -c 'ls -la /home/ubuntu'
  multipass exec -n "$instance" -- sudo bash './install_configure_vm.sh'
done

multipass transfer setup_kubemaster.sh "kubemaster:/home/ubuntu/setup_kubemaster.sh"
multipass exec "kubemaster" -- sudo bash -c './setup_kubemaster.sh'

for worker in "${workers[@]}"; do
    echo "Configuring $worker..."
    multipass transfer setup_workers.sh "$worker:/home/ubuntu/setup_workers.sh"
    multipass exec "$worker" -- sudo bash -c './setup_workers.sh'
done



