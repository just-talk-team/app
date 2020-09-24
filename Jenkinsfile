pipeline {
    agent any
    stages {
        stage('Git Checkout'){
            steps{
                echo 'git checkout'
                git credentialsId: 'GithubSSH', url: 'https://github.com/just-talk-team/app.git/'
                sh 'bundle install'
                sh 'bundle exec fastlane tests'
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
