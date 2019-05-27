#!/bin/bash

# Make sure that we actually need to change the static IP
/app/check.sh
if [ "$?" -eq "1" ]; then
    # Find the single VM instance running our Kubernetes cluster
    INSTANCE=$(gcloud compute instances list | grep $INSTANCE_PREFIX | cut -d ' ' -f 1)
    if [ -z "$INSTANCE" ]; then
        echo "No instance found"
        exit 1
    fi

    # Configuration names are either "External NAT" or "external-nat"
    # (see https://cloud.google.com/compute/docs/ip-addresses/reserve-static-external-ip-address#IP_assign)
    CONFIG_NAME="external-nat"
    OLD_NAME_MATCH=$(gcloud compute instances describe $INSTANCE --zone $INSTANCE_ZONE | grep "name: External NAT")
    if [ ! -z "$OLD_NAME_MATCH" ]; then
        CONFIG_NAME="External NAT"
    fi

    # Remove old configuration and create a new one
    gcloud compute instances delete-access-config $INSTANCE --access-config-name "$CONFIG_NAME" --zone $INSTANCE_ZONE
    gcloud compute instances add-access-config $INSTANCE --access-config-name "$CONFIG_NAME" --address $STATIC_IP --zone $INSTANCE_ZONE
fi

# Wait indefinetely
echo "Waiting..."
sleep infinity
echo "Wait aborted"
