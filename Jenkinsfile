pipeline {
    agent any
    

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    options {
        skipDefaultCheckout(false)  // enable automatic SCM checkout
        timeout(time: 30, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }


    stages {
        

        // STAGE 4: Login to ECR, Build & Push Docker Image
        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Login to AWS ECR
                    sh  "aws ecr get-login-password --region us-west-2 | podman login --username AWS --password-stdin 214797541313.dkr.ecr.us-west-2.amazonaws.com"

                    // Build Docker image
                    sh "podman build -t node-app-jenkins ."

                    sh "podman tag node-app-jenkins:latest 214797541313.dkr.ecr.us-west-2.amazonaws.com/node-app-jenkins:latest"

                    // Push to ECR
                    sh "podman push 214797541313.dkr.ecr.us-west-2.amazonaws.com/node-app-jenkins:latest"
                }
        }
        }

    }

    post {
        always {
            // Clean up workspace (optional)
            cleanWs()

        }
        failure {
            // Notify on failure (Slack, Email, etc.)
            echo 'Pipeline failed!'
        }
        success {
            echo 'Pipeline succeeded!'
        }
    }
}
