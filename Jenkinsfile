pipeline {
    agent any
    tools {
        terraform 'Terraform'
    }

    stages {
        stage('checkout') {
            steps {
                // Checkout the code from github repo
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Rubinay2/elearning.git']])
            }
        }

        stage('Deploy Production') {
            steps {
                script {
                    dir('Prod') {
                        // Deploy to the Prod environment using terraform 
                        sh 'terraform init'
                        echo "Terraform action is --> ${action}"
                        sh ("terraform ${action} --auto-approve -var-file=Prod.tfvars")
                    }
                }
            }
        }
    }
}