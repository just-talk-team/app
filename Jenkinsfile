pipeline {
    agent any
    stages {
        stage('Git Checkout'){
            steps{
                echo 'git checkout'
                git credentialsId: 'GithubSSH', url: 'https://github.com/just-talk-team/app.git/'
                sh 'sudo bundle install'
            }
        }
        stage('Test Stage') {
            steps{
                echo 'Runing Test stage'
                sh 'fastlane tests'
            }
        }
    
        stage('Deployment Stage') {
            steps {
                echo 'Runing deployment stage'
            }
        }
    }
}
