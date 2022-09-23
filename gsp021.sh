#!/bin/bash
gcloud auth list
gcloud config set compute/zone us-central1-b
gcloud container clusters create io
gsutil cp -r gs://spls/gsp021/* .
cd orchestrate-with-kubernetes/kubernetes
kubectl create deployment nginx --image=nginx:1.10.0
kubectl expose deployment nginx --port 80 --type LoadBalancer
while echo "$(kubectl get services)" | grep -q "pending"; do
   sleep 1
   echo "Waiting for Service to be ready......................."
done
read -p 'Check "Create a Kubernetes cluster and launch Nginx container"' CONTINUE
kubectl create -f pods/monolith.yaml
cd ~/orchestrate-with-kubernetes/kubernetes
kubectl create secret generic tls-certs --from-file tls/
kubectl create configmap nginx-proxy-conf --from-file nginx/proxy.conf
kubectl create -f pods/secure-monolith.yaml
kubectl create -f services/monolith.yaml
read -p 'Check "Create Monolith pods and service"' CONTINUE
gcloud compute firewall-rules create allow-monolith-nodeport \
  --allow=tcp:31000
read -p 'Check "Allow traffic to the monolith service on the exposed nodeport"' CONTINUE
kubectl label pods secure-monolith 'secure=enabled'
read -p 'Check "Adding Labels to Pods"' CONTINUE
kubectl create -f deployments/auth.yaml
kubectl create -f services/auth.yaml
kubectl create -f deployments/hello.yaml
kubectl create -f services/hello.yaml
kubectl create configmap nginx-frontend-conf --from-file=nginx/frontend.conf
kubectl create -f deployments/frontend.yaml
kubectl create -f services/frontend.yaml
while echo "$(kubectl get services)" | grep -q "pending"; do
   sleep 1
   echo "Waiting for Service to be ready......................."
done
read -p 'Check "Creating Deployments (Auth, Hello and Frontend)"' CONTINUE

echo "Lab ended!"
