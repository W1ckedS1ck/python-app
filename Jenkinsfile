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
          dockerImage = docker.build dockerimagename
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
            dockerImage.push("latest")
          }
        }
      }
    }

    stage('Deploying / rollout App to Kubernetes') {
      steps {
                        sh 'echo "Starting Deployment / Rollout"'
                    sh '''
                        sudo su
                        if kubectl get deployments | grep wa3
                        then
                            kubectl set image deploy/wa3 wa3=w1ckeds1ck/wa3:latest
                            kubectl rollout restart deployment ams
                        else
                            script {
                                kubernetesDeploy(configs: "DeployAndService.yaml", kubeconfigId: "kubernetes")
                            }
                        fi
                    '''
      }
    }
  }
}
