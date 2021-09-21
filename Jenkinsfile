pipeline {
    environment {
        imagename = "crappjavatest/test-app-java"
        registryProvider = 'http://crappjavatest.azurecr.io'
        registryCredential = 'azure-container-registry'
        dockerImage = ''
    }

    agent any

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
                    if (env.PUSH_TO_REGISTRY == 'true') {
                        docker.withRegistry( registryProvider, registryCredential ) {
                            dockerImage.push("${env.GIT_COMMIT}")
                            dockerImage.push("latest")
                        }
                    } else {
                        echo "Docker image wasn't pushed"
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

    }
}
