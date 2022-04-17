pipeline {
  agent any
  parameters {
    password (name: 'AKIA27HSQY2ZD7TUH4U7')
    password (name: 'QQYClvI9WWMFxAlI7Co1LYNSp03wiYffxPeCFROM')
  }
  environment {
    TF_WORKSPACE = 'dev' //Sets the Terraform Workspace
    TF_IN_AUTOMATION = 'true'
    AWS_ACCESS_KEY_ID = "${params.AWS_ACCESS_KEY_ID}"
    AWS_SECRET_ACCESS_KEY = "${params.AWS_SECRET_ACCESS_KEY}"
  }
  stages {
    stage('Terraform Init') {
      steps {
        sh label: '', script: 'terraform init'
      }
    }
    stage('Terraform Plan') {
      steps {
        sh label: '', script: 'terraform plan'
      }
    }
    stage('Terraform Apply') {
      steps {
        sh label: '', script: 'terraform apply --auto-approve'
      }
    }
  }
}