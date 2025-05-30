pipeline {
    
    agent any 
    
    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
        
    }
    
    stages {
        
        stage('Checkout'){
           steps {
                git url: 'https://github.com/ammukaleem/cicd-end-to-end.git', branch: 'main'
                          
                
           }
        }

        stage('Build Docker'){
            steps{
                script{
                    sh '''
                    echo 'Buid Docker Image'
                    docker build -t dockaleem/todo-app:${IMAGE_TAG} .
                    '''
                }
            }
        }

        stage('Push the artifacts'){
           steps{
                script{
                    
                    withCredentials([usernamePassword(credentialsId: 'doc-cred', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                    echo "Push to Repo"
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    docker push dockaleem/todo-app:${IMAGE_TAG}
                    '''
                       }
                   }
               }
          } 
                 
                    
        stage('Update K8S manifest & push to Repo'){
            steps {
                   withCredentials([usernamePassword(credentialsId: 'github', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')]) {
                   sh """
                   cd deploy
                   BUILD_NUMBER=${BUILD_NUMBER}
                   sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" deploy.yaml
                   git config user.name "ammukaleem"
                   git config user.email "mdkaleem777@gmail.com"
                   git add deploy.yaml
                   git diff --quiet || git commit -m "Update deploy.yaml with image tag ${replaceImageTag}"
                   git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/ammukaleem/cicd-end-to-end.git HEAD:main
                   """
                  }

            }
        }
    }
}
