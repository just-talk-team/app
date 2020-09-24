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
           steps {
                echo 'Runing deployment stage'
                sh 'pwd'
                sh 'flutter pub get'
                sh 'cd android'
                sh 'bundle exec fastline test'
            }
        }
    
        stage('Deployment Stage') {
            steps {
                echo 'Runing deployment stage'
            }
        }
    }
}
