pipeline {
    environment {
        imagename = getImageName(env.GIT_BRANCH)
        registryProvider = 'http://crappjavatest.azurecr.io'
        registryCredential = 'azure-container-registry'
        dockerImage = ''
        environment = getEnvironment(env.GIT_BRANCH)
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
                    sh 'cd ./terraform/${environment} && terraform init'
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
                    sh 'cd ./terraform/${environment} && terraform plan -var-file="${environment}.tfvars" '
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
                    sh 'cd ./terraform/${environment} && terraform apply -var-file="${environment}.tfvars" --auto-approve'
                }
            }
        }

//         stage('Deploy to production') {
//             steps{
//             step {
//                 withCredentials([azureServicePrincipal(
//                     credentialsId: 'azure-service-principle',
//                     subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
//                     clientIdVariable: 'ARM_CLIENT_ID',
//                     clientSecretVariable: 'ARM_CLIENT_SECRET',
//                     tenantIdVariable: 'ARM_TENANT_ID'
//                     )])
//                 {
//                     sh 'cd ./terraform/prod && terraform init'
//                 }
//             }
//             step {
//                 withCredentials([azureServicePrincipal(
//                     credentialsId: 'azure-service-principle',
//                     subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
//                     clientIdVariable: 'ARM_CLIENT_ID',
//                     clientSecretVariable: 'ARM_CLIENT_SECRET',
//                     tenantIdVariable: 'ARM_TENANT_ID'
//                     )])
//                 {
//                     sh 'cd ./terraform/prod && terraform plan -var-file="prod.tfvars" '
//                 }
//             }
//             step {
//                 withCredentials([azureServicePrincipal(
//                     credentialsId: 'azure-service-principle',
//                     subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
//                     clientIdVariable: 'ARM_CLIENT_ID',
//                     clientSecretVariable: 'ARM_CLIENT_SECRET',
//                     tenantIdVariable: 'ARM_TENANT_ID'
//                     )])
//                 {
//                     sh 'cd ./terraform/prod && terraform apply -var-file="prod.tfvars" --auto-approve'
//                 }
//             }
//             }
//
//         }

    }
}

def getImageName(branch = 'dev') {
    def imagename = "crappjavatest/dev-app-java"
    if (branch == 'release') {
        imagename = "crappjavatest/rc-app-java"
    }

    return imagename
}

def getEnvironment(branch = 'dev') {
    def env = "dev"
    if (branch == 'release') {
        env = "staging"
    }

    return env
}
