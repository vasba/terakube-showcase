#!/bin/bash

# Define an array of instance names

# Define an array of worker names
workers=("kubeworker01" "kubeworker02")
instances=("kubemaster" "${workers[@]}")

# Loop through each instance and transfer and execute the script
for instance in "${instances[@]}"; do
  echo "Configuring $instance..."
  multipass transfer install_configure_vm.sh "$instance:/home/ubuntu/install_configure_vm.sh"
  multipass exec "$instance" -- bash /home/ubuntu/install_configure_vm.sh
done

multipass transfer install_configure_vm.sh "kubemaster:/home/ubuntu/setup_kubemaster.sh"
multipass exec "kubemaster" -- bash /home/ubuntu/setup_kubemaster.sh

for worker in "${workers[@]}"; do
    echo "Configuring $worker..."
    multipass transfer install_configure_vm.sh "$worker:/home/ubuntu/setup_workers.sh"
    multipass exec "$worker" -- bash /home/ubuntu/setup_workers.sh
done



