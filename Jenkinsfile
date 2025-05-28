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
                    docker build -t dockaleem/cicd-e2e:${BUILD_NUMBER} .
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
                    docker push dockaleem/cicd-e2e:6
                    '''
                       }
                   }
               }
          } 
                 
                    
        stage('Update K8S manifest & push to Repo'){
            steps {
                script{                    
                        sh '''
                        cd deploy
                        cat deploy.yaml
                        sed -i "s|dockaleem/todo-app:v[0-9]*|dockaleem/todo-app:v${BUILD_NUMBER}|g" deploy.yaml
                        cat deploy.yaml
                        git add deploy.yaml
                        git diff --quiet || git commit -m 'Updated the deploy yaml | Jenkins Pipeline'
                        git push https://github.com/ammukaleem/cicd-end-to-end HEAD:main
                        '''                        
                 }
            }
        }
    }
}
