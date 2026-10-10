
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
        IMAGE_NAME     = 'devopsdurga/instituteweb:v1.0'
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

        stage('Push Image to Docker Hub') {
         steps {

        // Step 1: Retrieve Docker Hub credentials securely from Jenkins.
        // The credential ID must match the ID configured in Jenkins Credentials.
        withCredentials([
            usernamePassword(
                credentialsId: 'dockerhub-creds',
                usernameVariable: 'DOCKERHUB_USER',
                passwordVariable: 'DOCKERHUB_TOKEN'
            )
        ]) {
            sh '''
                # Step 2: Disable shell command tracing to reduce
                # the risk of accidentally exposing sensitive values.
                set +x

                # Step 3: Pass the Docker Hub access token to Docker
                # through standard input instead of a command-line argument.
                # This authenticates the Docker client on the agent.
                printf '%s' "$DOCKERHUB_TOKEN" |
                    docker login \
                        --username "$DOCKERHUB_USER" \
                        --password-stdin

                # Step 4: Push the previously built image to Docker Hub.
                # IMAGE_NAME must include your Docker Hub username,
                # repository name, and tag.
                # Example: mydockeruser/instituteweb:v1.0
                docker push "$IMAGE_NAME"

                # Step 5: Log out after a successful push to remove
                # the local Docker login session.
                docker logout
            '''
        }

        // Step 6: Print a success message if the commands above complete.
        echo 'Docker image pushed to Docker Hub successfully'
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

