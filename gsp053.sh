#!/bin/bash
gcloud auth list
read -p 'Enter compute zone: ' ZONE
gcloud config set compute/zone $ZONE
gsutil -m cp -r gs://spls/gsp053/orchestrate-with-kubernetes . &
gcloud container clusters create bootcamp \
  --machine-type e2-small \
  --num-nodes 3 \
  --scopes "https://www.googleapis.com/auth/projecthosting,storage-rw"
cd orchestrate-with-kubernetes/kubernetes
sed -i s,auth:2.0.0,auth:1.0.0,g deployments/auth.yaml
kubectl create -f deployments/auth.yaml
kubectl create -f services/auth.yaml
kubectl create -f deployments/hello.yaml
kubectl create -f services/hello.yaml
kubectl create secret generic tls-certs --from-file tls/
kubectl create configmap nginx-frontend-conf --from-file=nginx/frontend.conf
kubectl create -f deployments/frontend.yaml
kubectl create -f services/frontend.yaml
read -p 'Check "Create a Kubernetes cluster and deployments (Auth, Hello, and Frontend)"' CONTINUE
kubectl scale deployment hello --replicas=3
kubectl create -f deployments/hello-canary.yaml
read -p 'Check "Canary Deployment"' CONTINUE
echo "Lab ended!"
