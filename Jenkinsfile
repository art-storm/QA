pipeline {
    environment {
        imagename = getImageName(env.GIT_BRANCH)
        registryProvider = 'http://crappjavatest.azurecr.io'
        registryCredential = 'azure-container-registry'
        dockerImage = ''
    }

    agent any
    tools {
        terraform 'terraform-1.0.6'
    }

    stages {
        stage('Build') {
            steps {
                echo env.GIT_BRANCH
                sh 'mvn -B -DskipTests clean package'
            }
        }

        stage('Test') {
            steps {
               sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('Building image') {
            steps {
                script {
                    dockerImage = docker.build imagename
                }
            }
        }

        stage('Push image') {
            steps {
                script {
                    docker.withRegistry( registryProvider, registryCredential ) {
                        dockerImage.push("${env.GIT_COMMIT}")
                        dockerImage.push("latest")
                    }
                }
            }
        }

        stage('Cleaning up') {
            steps {
                sh '''
                    docker images | grep "${imagename}" | awk '{print $3}' | xargs docker rmi -f
                '''
            }
        }

        stage('Terraform init') {
            steps {
                withCredentials([azureServicePrincipal(
                    credentialsId: 'azure-service-principle',
                    subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
                    clientIdVariable: 'ARM_CLIENT_ID',
                    clientSecretVariable: 'ARM_CLIENT_SECRET',
                    tenantIdVariable: 'ARM_TENANT_ID'
                    )])
                {
                    sh 'cd ./terraform/dev && terraform init'
                }
            }
        }

        stage('Terraform plan') {
            steps {
                withCredentials([azureServicePrincipal(
                    credentialsId: 'azure-service-principle',
                    subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
                    clientIdVariable: 'ARM_CLIENT_ID',
                    clientSecretVariable: 'ARM_CLIENT_SECRET',
                    tenantIdVariable: 'ARM_TENANT_ID'
                    )])
                {
                    sh 'cd ./terraform/dev && terraform plan'
                }
            }
        }

        stage('Terraform apply') {
            steps {
                withCredentials([azureServicePrincipal(
                    credentialsId: 'azure-service-principle',
                    subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
                    clientIdVariable: 'ARM_CLIENT_ID',
                    clientSecretVariable: 'ARM_CLIENT_SECRET',
                    tenantIdVariable: 'ARM_TENANT_ID'
                    )])
                {
                    sh 'cd ./terraform/dev && terraform apply --auto-approve'
                }
            }
        }

    }
}

def getImageName(branch = 'dev') {
    def imagename = "crappjavatest/dev-app-java"
    if (branch == 'release') {
        imagename = "crappjavatest/rc-app-java"
    }

    return imagename
}
