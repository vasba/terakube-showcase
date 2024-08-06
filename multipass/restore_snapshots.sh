#!/bin/bash

# Define an array of worker names
workers=("kubeworker01" "kubeworker02")
instances=("kubemaster" "${workers[@]}")

# Restore snapshots
for instance in "${instances[@]}"; do
  echo "Restoring snapshot of $instance..."
  multipass restore "$instance".snapshotx
done