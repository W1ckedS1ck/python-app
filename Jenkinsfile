pipeline {

  environment {
    dockerimagename = "w1ckeds1ck/wa3"
    dockerImage = ""
  }

  agent any

  stages {
    stage('Checkout Source') {
      steps {
        sh 'git clone https://github.com/W1ckedS1ck/python-app.git'
      }
    }
    stage('Build image') {
      steps{
        script {
          sh 'sed -i -e "s/<TAG>/${BUILD_NUMBER:=1}/g" application/demo/views.py'
          dockerImage = docker.build dockerimagename + ":$BUILD_NUMBER" 
        }
      }
    }
    stage('Pushing Image') {
      environment {
               registryCredential = 'dockerhublogin'
           }
      steps{
        script {
          docker.withRegistry( 'https://registry.hub.docker.com', registryCredential ) {
            dockerImage.push("$BUILD_NUMBER") 
            dockerImage.push("latest") 
          }
        }
      }
    }
    stage('Deploying App to Kubernetes') {
      steps {
        script {
          sh 'sed -i "s/<TAG>/${BUILD_NUMBER}/" Deployment.yaml'
          kubernetesDeploy(configs: "Deployment.yaml", kubeconfigId: "kubernetes")
        }
      }
    }
  }
}
