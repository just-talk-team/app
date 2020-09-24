pipeline {
    agent any
    stages {
        stage('Git Checkout'){
            steps{
               
                sh 'sudo bundle install'
              
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
