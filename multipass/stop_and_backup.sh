#!/bin/bash

#  Backup, a corrupt Kubernetes cluster can be restored to a previous working state.

# Define an array of worker names
workers=("kubeworker01" "kubeworker02")
instances=("kubemaster" "${workers[@]}")

# Stop instances
for instance in "${instances[@]}"; do
  echo "Stopping $instance..."
  multipass stop "$instance"
done

# wait until all instances are stopped
for instance in "${instances[@]}"; do
  while [ "$(multipass info "$instance" | grep State | awk '{print $2}')" != "Stopped" ]; do
    echo "Waiting for $instance to stop..."
    sleep 5
  done
done

# take snapshots
for instance in "${instances[@]}"; do
  echo "Taking snapshot of $instance..."
  multipass snapshot "$instance"
done

multipass list --snapshots


