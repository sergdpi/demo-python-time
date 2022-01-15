pipeline {
    environment {
        imageName = "sergdpi/demo-python-time"
        registryCredential = 'sergdpi-dockerhub'
        dockerImage = ''
    }
    agent any
    stages {
        stage('Cloning git repo') {
            steps {
                git([url: 'https://github.com/sergdpi/demo-python-time.git', branch: 'jenkins'])

            }
        }
        stage('Building container image') {
            steps{
                script {
                    dockerImage = docker.build imageName
                }
            }
        }
        stage('Deploy Image') {
            steps{
                script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push("$BUILD_NUMBER")
                        dockerImage.push('latest')

                    }
                }
            }
        }
        stage('Remove Unused docker image') {
            steps{
                sh "docker rmi $imageName:$BUILD_NUMBER"
                sh "docker rmi $imageName:latest"

            }
        }
    }
}