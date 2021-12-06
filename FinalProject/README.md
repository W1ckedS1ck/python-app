<center>**FINAL PROJECT PERFORMED BY VITALI KUTS**</center>

---

## **Part 1. Prepare infrastructure**
### 1. Deploy automatically K8S cluster
####  *Setup HA cluster with Calico CNI(v3.16.5)

First of all lets create GCP environment:
```bash
gcloud compute instances create instance-* --project=our-metric-333013 --zone=us-central1-a --machine-type=e2-medium --network-interface=network-tier=PREMIUM,subnet=default --maintenance-policy=MIGRATE --service-account=961711077575-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server,https-server --create-disk=auto-delete=yes,boot=yes,image=projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20211118,mode=rw,size=10,type=projects/our-metric-333013/zones/us-central1-a/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any
```
To get the calico version as mentioned above, we don't have to use the latest version of the kubespray repository, so:
```bash
wget https://github.com/kubernetes-sigs/kubespray/archive/refs/tags/v2.15.0.tar.gz
tar -xvzf v2.15.0.tar.gz
cp -rfp inventory/sample inventory/mycluster
```
Lets change kubespray configuration for ours goals.
```code
ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml
# Addons which can be enabled
helm_enabled: yes

kubespray/inventory/mycluster/group_vars/k8s-cluster/addons.yml
# Nginx ingress controller deployment
ingress_nginx_enabled: true
ingress_nginx_host_network: true
ingress_publish_status_address: ""
```
Run
```bash
ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml
```
and it will deploy the cluster.

---
### 2. Deploy CI/CD tool into K8S by using YAML-manifests or Helm charts.
#### *For Jenkins setup Master + Slave nodes
> Note: https://www.jenkins.io/doc/book/installing/kubernetes/  

Install Jenkins as helm chart will rise Master + Slave nodes automatically. 
Connect to ansible node2 (worker)
```bash
sudo mkdir -p /data/jenkins-volume && sudo chown -R 1000:1000 /data/jenkins-volume
sudo mkdir -p /data/kafka && sudo chown -R 1000:1000 /data/kafka
```
```bash
wget https://raw.githubusercontent.com/W1ckedS1ck/python-app/main/FinalProject/JenkinsIns.sh
chmod +x jenkinsIns.sh && ./JenkinsIns.sh
```
Jenkins is accesible at http://35.224.16.57:8080 for now after run this command  
kubectl --namespace jenkins port-forward svc/jenkins 8080:8080 -address=0.0.0.0 &  
but no need to do thus BC this is the task for LoadBalancer
####  *All configuration define as a JCasC
> Note: https://www.youtube.com/watch?v=ANU7jkxbZSM

####  *Setup Nginx as a Reverse Proxy for Jenkins Master node
KubeSpray can handle this so i believe i would have my optional star. lol.

### 3. Spin up repository manager for storing artifacts(Docker images, Helm charts, etc) you can use Artifactory, Nexus, etc.
Docker hub will fit. And everyone has it. I have it as well.

---
## **Part 2. Deploy application**
### 1. Write pipeline which deploy application into K8S cluster
• Application code https://github.com/ingvar-goryainov/python-
app  
> Note: https://www.youtube.com/watch?v=XE_mAhxZpwU  
```bash
git clone https://github.com/ingvar-goryainov/python-app
docker run -d -p 80:8080 1c0cc3f1a85f python3 -m demo
```
But i will performed automatically.
• Build in Docker image  
Dockerfile will figure it out. It is located at the root of the folder.  
• Store image in Repository Manager  
Sure. At the Docker.hub.
• Use YAML-manifests or custom Helm chart for deploying application
Jenkins Pipeline, your turn! Devops don't need it to do! 

### 2. Organize “Rolling Update” strategy.
Deployment is ready to go by DeployAndService.yaml.
but if we will be able to get an artifact -   
k set image deploy/wa3 wa3=w1ckeds1ck/wa3:<TAG>
#### *Use “Blue-Green” or “Canary” strategy for deployment

#### *Spin up HA Kafka cluster in K8S
> Note: https://betterprogramming.pub/how-to-run-highly-available-kafka-on-kubernetes-a1824db8a3e2  

helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
curl https://raw.githubusercontent.com/helm/charts/master/incubator/kafka/values.yaml > values.yaml
helm install kafka incubator/kafka -f values.yaml

#### *Write pipeline for deploying application https://github.com/etycomputer/website-metric-producer
#### *Organize strategy for redeploy application

---
## **Part 3. Configure monitoring**
### 3. Install and configure next components on your K8S cluster
• Prometheus  
• Prometheus NodeExporter  
• Grafana  
• Alertmanager  
```bash
wget https://raw.githubusercontent.com/W1ckedS1ck/python-app/main/FinalProject/prom.sh
chmod +x prom.sh && ./prom.sh
```
### 4. Configure Prometheus to scrape metrics from all the nodes.
I hope ./prom.sh will.
### 5. Configure Grafana dashboard with general panels.
The main dignity of Devops is his laziness. Just import dashboard from file or Grafana.com ( go to + - Import - 1860 & 9964 ). 
### 6. Add alerts for the panel
It can be done when grafana dashboard conffiguration performed.
#### *Install and configure ELK stack in K8S cluster to scrape metrics from Kafka



Automation will be added soon.
