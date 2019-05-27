#!/bin/bash

# Find the single VM instance running our Kubernetes cluster
INSTANCE=$(gcloud compute instances list | grep $INSTANCE_PREFIX | cut -d ' ' -f 1)
if [ -z "$INSTANCE" ]; then
    echo "No instance found"
    exit 1
fi

# Check if the correct IP is assigned to the VM instance
MATCH=$(gcloud compute instances describe $INSTANCE --zone $INSTANCE_ZONE | grep "natIP: $STATIC_IP")
if [ ! -z "$MATCH" ]; then
    echo "Correct IP assigned"
    exit 1
else
    echo "Static IP is not assigned"
    exit 0
fi
