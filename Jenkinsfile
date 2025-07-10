pipeline {
  agent any

  environment {
    AWS_ACCESS_KEY_ID     = credentials('aws-creds')
    AWS_SECRET_ACCESS_KEY = credentials('aws-creds')
  }

  stages {
    stage('Init') {
      steps {
        dir('terraform') {
          sh 'terraform init'
        }
      }
    }
    stage('Plan') {
      steps {
        dir('terraform') {
          sh 'terraform plan'
        }
      }
    }
    stage('Apply') {
      steps {
        dir('terraform') {
          sh 'terraform apply -auto-approve'
        }
      }
    }
  }
}

