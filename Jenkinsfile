// prerequisites: a nodejs app must be deployed inside a kubernetes cluster
// TODO: look for all instances of [] and replace all instances of 
//       the 'variables' with actual values 
// variables:
//      [GITREPO]
//      [IMAGE_NAME]
//      [PROJECTID]
//      [CLUSTER_NAME] 
//      [ZONE]
//      the following values can be found in the yaml:
//      [DEPLOYMENT_NAME]
//      [CONTAINER_NAME] (in the template/spec section of the deployment)

pipeline {
    agent any 
    options {
        // This is required if you want to clean before build
        skipDefaultCheckout(true)
    }
    stages {
        stage('Clean Up') {
            steps {
                // Clean before build
                cleanWs()
                echo "Building ${env.JOB_NAME}..."
            }
        }
        stage('Stage 1') {
            steps {
                echo 'Retrieving source from github' 
                git branch: 'master',
                    url: 'https://github.com/hudomju/events-app-internal'
                echo 'Did we get the source?' 
                sh 'ls -a'
            }
        }
        stage('Stage 2') {
            steps {
                echo 'workspace and versions' 
                sh 'echo $WORKSPACE'
                sh 'gcloud version'
                sh 'node -v'
                sh 'npm -v'
            }
        }        
         stage('Stage 3') {
            environment {
                PORT = 8081
            }
            steps {
                echo 'install dependencies' 
                sh 'npm install'
                echo 'Run tests'
                sh 'npm test'
        
            }
        }        
         stage('Stage 4') {
            steps {
                echo "build id = ${env.BUILD_ID}"
                echo 'Tests passed on to build Docker container'
                sh "gcloud builds submit -t gcr.io/qwiklabs-gcp-554f4fa19df6edd6/web-server-image:v2.${env.BUILD_ID} ."
            }
        }        
         stage('Stage 5') {
            steps {
                echo 'Get cluster credentials'
                sh 'gcloud container clusters get-credentials gke --zone us-central1-b --project qwiklabs-gcp-554f4fa19df6edd6'
                echo 'Update the image'
                echo "gcr.io/qwiklabs-gcp-554f4fa19df6edd6/web-server-image:2.${env.BUILD_ID}"
                sh "kubectl set image deployment/demo-ui demo-ui=gcr.io/qwiklabs-gcp-554f4fa19df6edd6/web-server-image:v2.${env.BUILD_ID} --record"
            }
        }
    }
}
