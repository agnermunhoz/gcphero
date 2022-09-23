#!/bin/bash
gcloud auth list
read -p 'Enter compute zone: ' ZONE
REGION=${ZONE::-2}
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE
gcloud compute instances create gcelab \
  --zone=$ZONE \
  --machine-type=e2-medium \
  --tags=http-server \
  --metadata=startup-script='#!/bin/bash
     apt-get update
     apt-get install nginx -y' &
gcloud compute instances create gcelab2 \
   --machine-type=e2-medium \
   --zone=$ZONE &
wait
echo "CHECK!!! CHECK!!! CHECK!!! CHECK!!! CHECK!!!"
echo "Lab ended!"
