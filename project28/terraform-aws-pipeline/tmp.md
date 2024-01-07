pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Checkout code from the repository
                    checkout scm
                }
            }
        }

        stage('Terraform Plan') {
            when {
                // Run on feature branches
                expression { env.BRANCH_NAME != 'main' }
            }
            steps {
                script {
                    // Run Terraform plan on feature branches
                    sh 'terraform init -backend-config="backend.tfvars"'
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            when {
                // Run only on the main branch
                expression { env.BRANCH_NAME == 'main' }
                // Manual triggering
                expression { currentBuild.rawBuild.getCause(hudson.model.Cause$UserIdCause) != null }
            }
            steps {
                script {
                    // Run Terraform apply on main branch with manual confirmation
                    input 'Do you want to apply changes?'
                    sh 'terraform apply tfplan'
                }
            }
        }
    }
}
