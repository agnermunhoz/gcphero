#!/bin/bash
gcloud auth list
#read -p 'Enter compute region: ' REGION
read -p 'Enter compute zone: ' ZONE
REGION=${ZONE::-2}
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE
gcloud container clusters create --machine-type=e2-medium --zone=$ZONE lab-cluster 
echo 'Check "Create a GKE cluster"'
gcloud container clusters get-credentials lab-cluster 
kubectl create deployment hello-server --image=gcr.io/google-samples/hello-app:1.0
echo 'Check "Create a new Deployment: hello-server"'
kubectl expose deployment hello-server --type=LoadBalancer --port 8080
while echo "$(kubectl get services)" | grep -q "pending"; do
   sleep 1
   echo "Waiting for Service to be ready......................."
done
read -p 'Check "Create a Kubernetes Service"' CONTINUE
echo "Type Y to confirme cluster deletion"
gcloud container clusters delete lab-cluster 
echo 'Check "Delete the cluster"'
echo "Lab ended!"
