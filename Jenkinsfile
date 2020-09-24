pipeline {
    agent any
    stages {
        stage('Git Checkout'){
            steps{
                echo 'git checkout'
                git credentialsId: 'GithubSSH', url: 'https://github.com/just-talk-team/app.git/'
            }
        }
        stage('Test Stage') {
            steps{
                echo 'Runing Test stage test'
                sh 'bundle install'
            }
        }
    
        stage('Deployment Stage') {
            steps {
                echo 'Runing deployment stage'
            }
        }
    }
}
