pipeline {
    agent any
    stages {
        stage('Git Checkout'){
            steps{
                echo 'git checkout'
                git credentialsId: 'GithubSSH', url: 'https://github.com/just-talk-team/app.git/'
                sh 'cd /android'
                sh 'bundle exec fastlane android'
            }
        }
        stage('Test Stage') {
            steps{
                echo 'Runing Test stage'
                
            }
        }
    
        stage('Deployment Stage') {
            steps {
                echo 'Runing deployment stage'
            }
        }
    }
}
