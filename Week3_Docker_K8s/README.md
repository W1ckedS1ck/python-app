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
We could try to build our image on different versions, but I went here (https://hub.docker.com/_/python) and took the latest stable
build of PYTHON based on the ALPINE.
Now you can see what I got here - https://hub.docker.com/repository/docker/w1ckeds1ck/wa3
Compressed size of my image on dockerhub is only 23M. Pretty good, huh?
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

```
!!! BUT anyway i'm going to use PWK service (https://labs.play-with-k8s.com) to go further
I did this just to get my legal point for this step (lol)! Here is the scr as proof - https://clck.ru/YQMPG

---

## **4. Deploy the application into the K8S cluster - 3 **

###	•	Сreate Deployment .yaml file with containerized application 
Go to your docker hub (https://hub.docker.com/repositories) and find out the name of your application. The name of mine is w1ckeds1ck / wa3.
```bash
kubectl create deployment wa3 --image=w1ckeds1ck/wa3 --dry-run=client -oyaml
```
That's it! This is our manifest-file. Just save it as Deployment,yaml. It can be deployed in furure by putting next command down
```bash
kubectl apply -f Deployment.yaml
```
###	•	*The deployment requires 3 replicas, “RollingUpdate” strategy. Emulate the “RollingUpdate” strategy by updating docker image. Provide screenshots. Define the liveness and readiness probes to /health endpoint and 8080 port, resources(requests/limits) 

###	•	*Create a “Service” object which exposes Pods with application outside the K8S cluster in order to access each of the replicas through the single IP address/DNS name. 

###	•	*Specify PodDistruptionBudget which defines that only 1 replica can be down. 

