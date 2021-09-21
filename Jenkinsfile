pipeline {
    environment {
        imagename = getImageName(env.GIT_BRANCH)
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

    }
}

def getImageName(branch = 'dev') {
    def imagename = "crappjavatest/dev-app-java"
    if (branch == 'release') {
        imagename = "crappjavatest/rc-app-java"
    }

    return imagename
}
