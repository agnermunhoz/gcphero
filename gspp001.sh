#!/bin/bash
PROJECTID=$(gcloud config get project)
read -p 'Enter compute zone: ' ZONE
REGION=${ZONE::-2}
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE
gcloud compute instances create gcelab2 \
   --machine-type=e2-medium \
   --zone=$ZONE &
wait
echo "CHECK!!! CHECK!!! CHECK!!! CHECK!!! CHECK!!!"
echo "Lab ended!"
