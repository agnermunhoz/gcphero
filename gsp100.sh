#!/bin/bash
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-a
gcloud container clusters create --machine-type=e2-medium --zone= lab-cluster 
read -p 'Check "Create a GKE cluster"' CONTINUE
gcloud container clusters get-credentials lab-cluster 
kubectl create deployment hello-server --image=gcr.io/google-samples/hello-app:1.0
read -p 'Check "Create a new Deployment: hello-server"' CONTINUE
kubectl expose deployment hello-server --type=LoadBalancer --port 8080
read -p 'Check "Create a Kubernetes Service"' CONTINUE
echo "Type Y to confirme cluster deletion"
gcloud container clusters delete lab-cluster 
read -p 'Check "Delete the cluster"' CONTINUE
echo "Lab ended!"