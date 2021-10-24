# THIRD WEEKLY ASSASEMENT PERFORMED BY VITALI KUTS


## **1. Fork repo https://github.com/ingvar-goryainov/python-app**

https://github.com/W1ckedS1ck/python-app

---

## **2. Build docker image with Python  application - 3**


###	•	using “Best practices” for writing Dockerfiles https://docs.docker.com/develop/develop-images/dockerfile_best-practices/  
OK (:

###	•	define non-root user in order to run process inside a container by this user 
We should define a new user with respective permissions
```bash
addgroup -S appgroup
adduser -S appuser -G appgroup
USER appuser
```

###	•	install all dependencies through pip 
All of them are declared in the python-app/application/setup.py, so
```bash
pip3 install aiohttp multidict==4.5.2 yarl==1.3.0
```

###	•	build docker image as smaller as possible 
We could try to build our image on different versions, but I went to the [DockerHub/python repository](https://hub.docker.com/_/python) and took the latest stable
build of PYTHON based on the ALPINE.
Compressed size of my image on dockerhub is only 23M. Pretty good, huh? You can see this below.
I am sure that using different versions of distributions in the FROM field (lol) you can achieve even better results.

---

## **3. Setup K8S cluster using Minikube(1 master + 1 worker node is enough): - 1**

Ok, it can be done by entering theese commands (by the way You can put checkboxes near "docker" and "k8s" section during installation
of Ububutu server long term supp),
```bash
# This is the manual https://minikube.sigs.k8s.io/docs/start/

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
#Then feel free to run it
minikube start
minikube node add worker
kubectl label node minikube-m02 node-role.kubernetes.io/worker=worker
```

It showed me this:  
| NAME           | STATUS   | ROLES                  | AGE     | VERSION 
| ------ | ------ | ------ | ------ | ------ |
| minikube       | Ready    | control-plane,master   | 4m59s   | v1.22.3-rc.0  
| minikube-m02   | Ready    | worker                 | 3m28s   | v1.22.3-rc.0  

> Note: !!! BUT anyway i'm going to use [PWK service](https://labs.play-with-k8s.com) to go further
I did this just to get my honestly earned point for this step (lol)! Here is the scr as proof - https://clck.ru/YQMPG

---

## **4. Deploy the application into the K8S cluster - 3 **

###	•	Сreate Deployment .yaml file with containerized application 

Go to your [docker hub](https://hub.docker.com/repositories) and find out the name of your application. The name of mine is w1ckeds1ck / wa3. Remember it. Later you will know why.
Now, follow me. Open PWR (i gave you the link little above) and create 2 nodes.
On the first node type down :
```bash
 kubeadm init --apiserver-advertise-address $(hostname -i) --pod-network-cidr 10.5.0.0/16
 kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter.yaml
 alias k=kubectl
 k label node minikube-m02 node-role.kubernetes.io/worker=worker # let's mark the role of our second node as worker.
```
Second node
```bash
 kubeadm join 192.168.0.33:6443 --token k69pyo.n8qu58onpqgmi6yu     --discovery-token-ca-cert- hashsha256:260431b4435e6460418caee937681b5152d3de0a081db6ebd7e5a0f1dc851b3d # It showed us the first node to be tied with next ones
```
Lets check connection. Type "k get nodes". Is you can see this - you are awesome!  
| NAME   | STATUS |  ROLES          |        AGE  | VERSION  
| ------ | ------ | ------ | ------ | ------ |  
| node1  | Ready  |  control-plane,master | 14m  | v1.20.1  
| node2  | Ready  |  worker         |       13m  | v1.20.1  

Now do as i did.
```bash
 k create deployment wa3 --image=w1ckeds1ck/wa3 # No doubt, you allready forgot about that
 k expose deployment wa3 --port=8080 --type=NodePort
 k get service
```
Here is the result of curl 10.102.6.75:8080  
Hostname: wa3-84dd756dbc-j6zmb. Version: 0.2  

So (finaly) let's get out our deployment.yaml! It can be deployed in furure by "command apply -f"
```bash
 k get deploy wa3 -oyaml > Deploy.yaml
 k get svc wa3 -oyaml > Service.yaml
```
AWESOME! It's time to do some nasty thigs! Ha-Ha-HAAA!!!
```bash
 k delete deployment wa3
 k delete svc wa3
 ```
Are you scered? Shure you are. But hold on!
```bash
 k apply -f Deploy.yaml 
 k apply -f Service.yaml 
 k get svc
 curl 10.102.6.75:8080
```
 If "Hostname: wa3-84dd756dbc-dfgdn. Version: 0.2" is appeared (it should), probably you are lucky.
Yaml's can be checked [HERE](https://github.com/W1ckedS1ck/python-app/blob/main/DeployFromPWK.yaml) and [HERE](https://github.com/W1ckedS1ck/python-app/blob/main/Service.yaml). First link is for Deploy, second for Service yaml

###	•	*The deployment requires 3 replicas, “RollingUpdate” strategy. Emulate the “RollingUpdate” strategy by updating docker image. Provide screenshots. Define the liveness and readiness probes to /health endpoint and 8080 port, resources(requests/limits) 

Need 3 replicas? No time to chill, scaling our deploy! NOW!
```bash
 k scale --replicas=3 deploy/wa3
```
Now do release of your outstanding (no) application in container, push it and check it out later on your DockerHub
```bash
 docker build .
 docker images
 docker tag 19f274347082 w1ckeds1ck/wa3:v2.0
 docker login -u w1ckeds1ck (here shoud be your token)
 docker push w1ckeds1ck/wa3:v2.0 
```
k set image deploy/wa3 wa3=w1ckeds1ck/wa3:v2.0
[Here's what you will see](https://github.com/W1ckedS1ck/python-app/blob/main/Week3_Docker_K8s/RolingUpdateScreen.txt)

###	•	*Create a “Service” object which exposes Pods with application outside the K8S cluster in order to access each of the replicas through the single IP address/DNS name. 

###	•	*Specify PodDistruptionBudget which defines that only 1 replica can be down. 
```bash
#https://kubernetes.io/docs/tasks/run-application/configure-pdb/
k get poddisruptionbudgets # there is no pdb configured. Obviously.
k apply -f pdb.yaml
```
pdb.yaml placed [here](https://github.com/W1ckedS1ck/python-app/blob/main/pdb.yaml)
Here is the result
| NAME   |   MIN AVAILABLE |  MAX UNAVAILABLE |  ALLOWED DISRUPTIONS |  AGE
| ------ | ------ | ------ |------ | ------ |
| wa3-pdb|   N/A         |    1             |    1                   |  13s
---
> Note: PS. Here you can find : docker image size, running docker container, container logs. I ran it on my AWS just for fun.
![alt text](https://i.ibb.co/8MbTb4D/image.png)
