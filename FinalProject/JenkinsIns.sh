#https://www.jenkins.io/doc/book/installing/kubernetes/
#!/bin/bash

kubectl create namespace jenkins
helm repo add jenkinsci https://charts.jenkins.io
helm repo update
helm search repo jenkinsci

#######################################################
#COMMENT ALL WGET'S IF YOU HAVE ALLREADY DOWNLOAD IT!!#
#######################################################

wget https://raw.githubusercontent.com/jenkins-infra/jenkins.io/master/content/doc/tutorials/kubernetes/installing-jenkins-on-kubernetes/jenkins-volume.yaml
kubectl apply -f jenkins-volume.yaml

wget https://raw.githubusercontent.com/jenkins-infra/jenkins.io/master/content/doc/tutorials/kubernetes/installing-jenkins-on-kubernetes/jenkins-sa.yaml
kubectl apply -f jenkins-sa.yaml

https://raw.githubusercontent.com/W1ckedS1ck/python-app/main/FinalProject/jenkins-values.yaml
helm install jenkins -n jenkins -f jenkins-values.yaml jenkinsci/jenkins

sleep 10
kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/chart-admin-password && echo

#kubectl apply -f jenkins-ingress.yam
