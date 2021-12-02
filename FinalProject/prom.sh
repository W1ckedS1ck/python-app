#!/bin/bash

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 
helm repo update 
kubectl create namespace monitoring 
helm install prometheus -n monitoring prometheus-community/kube-prometheus-stack

kubectl create secret generic etcd-certs -nmonitoring \
  --from-file=/etc/ssl/etcd/ssl/ca.pem \
  --from-file=/etc/ssl/etcd/ssl/node-node1-key.pem \
  --from-file=/etc/ssl/etcd/ssl/node-node1.pem
  
helm install -f values.yaml prometheus -n monitoring prometheus-community/kube-prometheus-stack \
  --set prometheusOperator.createCustomResource=false \
  --set kubeEtcd.serviceMonitor.scheme=https \
  --set kubeEtcd.serviceMonitor.caFile=/etc/prometheus/secrets/etcd-certs/ca.pem \
  --set kubeEtcd.serviceMonitor.certFile=/etc/prometheus/secrets/etcd-certs/node-node1.pem \
  --set kubeEtcd.serviceMonitor.keyFile=/etc/prometheus/secrets/etcd-certs/node-node1-key.pem \
  --set prometheus.prometheusSpec.secrets={etcd-certs}
  
  # go to grafana - create - import - Import via grafana.com - 1860 - load 
