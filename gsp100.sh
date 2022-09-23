#!/bin/bash
read -p 'Enter compute region' REGION
gcloud config set compute/region $REGION
read -p 'Enter compute zone' ZONE
gcloud config set compute/zone $REGION-$ZONE
gcloud container clusters create --machine-type=e2-medium --zone=$REGION-$ZONE lab-cluster 
read -p 'Check "Create a GKE cluster"' CONTINUE
gcloud container clusters get-credentials lab-cluster 
kubectl create deployment hello-server --image=gcr.io/google-samples/hello-app:1.0
until echo "$(kubectl get pod)" | grep -q "1/1"; do
   sleep 1
   echo "Waiting for Deployment to be ready......................."
done
read -p 'Check "Create a new Deployment: hello-server"' CONTINUE
kubectl expose deployment hello-server --type=LoadBalancer --port 8080
while echo "$(kubectl get services)" | grep -q "pending"; do
   sleep 1
   echo "Waiting for Service to be ready......................."
done
read -p 'Check "Create a Kubernetes Service"' CONTINUE
echo "Type Y to confirme cluster deletion"
gcloud container clusters delete lab-cluster 
read -p 'Check "Delete the cluster"' CONTINUE
echo "Lab ended!"
