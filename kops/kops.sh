#!/bin/bash

curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x ./kops
mv ./kops /usr/local/bin/

curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl

# kops create cluster --name=myfirstcluster.k8s.local --state=s3://kops-state-1-515462467908 --zones ap-southeast-1a,ap-southeast-1b --node-count=1

# kops update cluster --name myfirstcluster.k8s.local --state=s3://kops-state-1-515462467908 --yes --admin

# kops validate cluster --state=s3://kops-state-1-515462467908 --wait 10m

# kops delete cluster --name=myfirstcluster.k8s.local --state=s3://kops-state-1-515462467908 --yes


# kubectl apply -f deploy_mongo.yml
# kubectl apply -f svc_mongo.yml 
# kubectl apply -f deploy_node.yml
# kubectl apply -f svc_node.yml

# kubectl delete -f deploy_mongo.yml
# kubectl delete -f svc_mongo.yml 
# kubectl delete -f deploy_node.yml
# kubectl delete -f svc_node.yml

