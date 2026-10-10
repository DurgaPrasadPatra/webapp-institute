pipeline{
      agent {
      label  'nodedockerhost'
      }
     
     tool{
      JAVA_HOME 'jdk17'
      MAVEN_HOME 'maven'
     }
     
     environment{
   APP_NAME='webapp-institute"
    IMAGE_NAME = 'instituteweb:v1.0'
    CONTAINER_NAME= 'institutecontainer"

    }

   stages{
      stage ('checkout git') {
     steps{ git url: "https://github.com/DurgaPrasadPatra/webapp-institute.git"}
    }
    stage ('compile package') {
         steps{sh 'mvn clean package'}
     }

     stage ('deploy') {
     steps{sh 'mvn clean package'}
     }
    
      stage ('image build') {
       steps{
       sh 'docker build -t  ${IMAGE_NAME} . '
       echo "Image build succes ${IMAGE_NAME}
    }

    stage ('deploying container') {
   steps{
    sh 'docker rm -f  ${CONTAINER_NAME}' || true 
  
   sh 'docker run -itd --name ${CONTAINER_NAME}  -p 8080:8080  ${IMAGE_NAME}  '
   echo "container running successfully"
}
 post{
success{echo 'Pipeline is success full'}
failure{echo 'Pipeline is NOT success full'}
}
}
