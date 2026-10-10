
pipeline {
    agent {
        label 'nodedockerhost'
    }

    tools {
        jdk 'jdk17'
        maven 'maven'
    }

    environment {
        APP_NAME       = 'webapp-institute'
        IMAGE_NAME     = 'instituteweb:v1.0'
        CONTAINER_NAME = 'institutecontainer'
    }

    stages {
        stage('Checkout Git') {
            steps {
                git branch:'main' , url: 'https://github.com/DurgaPrasadPatra/webapp-institute.git'
            }
        }

        stage('Verify Tools') {
            steps {
                sh 'java -version'
                sh 'mvn -version'
                sh 'docker --version'
            }
        }

        stage('Compile and Package') {
            steps {
                sh 'mvn clean package'
                sh 'ls -lh target/'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t "$IMAGE_NAME" .'
                echo 'Docker image built successfully'
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                    docker rm -f "$CONTAINER_NAME" || true

                    docker run -d \
                        --name "$CONTAINER_NAME" \
                        --restart unless-stopped \
                        -p 8081:8080 \
                        "$IMAGE_NAME"

                    docker ps --filter "name=$CONTAINER_NAME"
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully'
        }

        failure {
            echo 'Pipeline failed. Check the stage logs.'
        }
    }
}

