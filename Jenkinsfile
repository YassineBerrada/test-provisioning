pipeline {
  agent any

  environment {
    AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
    AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
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
    stage('Extract IP & Generate Ansible Inventory') {
  steps {
    script {
      def ip = sh(script: 'cd terraform && terraform output -raw instance_ip', returnStdout: true).trim()
      writeFile file: 'ansible/inventory.ini', text: """
[webserver]
${ip} ansible_user=ubuntu ansible_ssh_private_key_file=/var/lib/jenkins/.ssh/terraform-key ansible_python_interpreter=/usr/bin/python3
"""
    }
  }
stage('Extract IP & Generate Ansible Inventory') {
  steps {
    script {
      def ip = sh(script: 'cd terraform && terraform output -raw instance_ip', returnStdout: true).trim()
      writeFile file: 'ansible/inventory.ini', text: """
[webserver]
${ip} ansible_user=ubuntu ansible_ssh_private_key_file=/var/lib/jenkins/.ssh/terraform-key ansible_ssh_common_args='-o StrictHostKeyChecking=no' ansible_python_interpreter=/usr/bin/python3
"""
    }
  }
}
}

/*stage('Provision with Ansible') {
  steps {
    sh 'ansible-playbook -i ansible/inventory.ini ansible/setup.yml'

  }
}*/



  }
}
