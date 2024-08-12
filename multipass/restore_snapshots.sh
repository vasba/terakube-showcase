#!/bin/bash

# Define an array of worker names
workers=("kubeworker01" "kubeworker02")
instances=("kubemaster" "${workers[@]}")

# Restore snapshots
for instance in "${instances[@]}"; do
  echo "Restoring snapshot of $instance..."
  multipass stop "$instance"
  echo "If the restore fails be shure you specified the correct snapshot version: e.g $instance.snapshot1 for version 1"
  multipass restore --destructive "$instance".snapshot
  multipass start "$instance"
done