pipeline {
    environment {
        imageName = "sergdpi/demo-python-time"
        registryCredential = 'sergdpi-dockerhub'
        dockerImage = ''
        app = 'demo-python-time'
    }
    agent any
    stages {
        stage('Cloning git repo') {
            steps {
                git([url: 'https://github.com/sergdpi/demo-python-time.git', branch: 'main'])

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
        stage('Update ArgoCD app') {
            steps {
                script {
                    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                        withCredentials([usernamePassword(credentialsId: 'ci-github', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                            def encodedPassword = URLEncoder.encode("$GIT_PASSWORD", 'UTF-8')
                            sh "echo 'Set new ${env.BUILD_NUMBER} to ${app}.yaml k8s manifest'"
                            sh "rm -rf demo-infra && mkdir -p demo-infra"
                            dir("${env.WORKSPACE}/demo-infra") {
                                sh "git config user.email ci@example.com"
                                sh "git config user.name ci-jenkins-${NODE_NAME}"
                                sh "git clone --depth 5 https://github.com/sergdpi/demo-python-time.git ."
                                sh "git checkout main"
                                sh "sed -i s~tag:.*\$~tag:' '${env.BUILD_NUMBER}~g ./kubernetes/demo/${app}.yaml"
                                sh "git add ./kubernetes/demo/${app}.yaml"
                                sh "git commit -m '[skip ci] Bump docker image tag version. Triggered Build: ${env.BUILD_NUMBER}'"
                                sh "git push https://${GIT_USERNAME}:${encodedPassword}@github.com/${GIT_USERNAME}/demo-infra.git"
                            }
                        }
                    }
                }
            }
        }
    }
}
