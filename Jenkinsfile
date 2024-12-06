pipeline{
    agent any
    environment {
        KUBECONFIG = "/home/udhayakumar/.kube/config"
    }
    stages{
        stage('git repo clonning'){
            steps{
                script{
                    sh '''
                        if [ -d springApp_repo ];
                        then
                            rm -rf springApp_repo
                        fi
                        
                        git clone https://github.com/udhaya-20/springApp_repo.git
                    '''
                }
            }
        }
        stage('docker executions'){
            steps{
                script{
                    withDockerRegistry(credentialsId: 'docker-credential', url: 'https://index.docker.io/v1/') 
                    {
                    sh '''
                        echo "Removing existing docker container and image"
                        if [ $(docker ps -q -f name=SpringApp-Container) ];
                        then
                            docker rm $(docker stop SpringApp-Container)
                            
                            echo "Removed running container successfully"
                        elif [ $(docker ps -aq -f name=SpringApp-Container) ];
                        then
                            docker rm SpringApp-Container
                            
                            echo "Removed stoped container"
                        fi
                        
                        if [ $(docker images -q udhayakumar124/springboot_project) ];
                        then
                            docker rmi udhayakumar124/springboot_project
                            
                            echo "Removed existing image"
                        fi
                        
                        echo "Building new docker image"
                        
                        docker build -t udhayakumar124/springboot_project ./springApp_repo/
                        
                        echo "pushing docker images into dockerhub"
                        
                        docker push udhayakumar124/springboot_project
                    '''
                    }
                }
            }
        }
        stage('k8s deployments'){
            steps{
                script{
                    sh '''
                        echo "Creating Kubernetes Deployment"
                    
                        kubectl apply -f ./springApp_repo/deployments.yaml
                        
                        echo "Creating Kubernetes Service"
                        
                        kubectl apply -f ./springApp_repo/service.yaml
                        
                        echo "Creating Kubernetes Ingress"
                        
                        kubectl apply -f ./springApp_repo/ingress-wildcards.yaml
                    
                        echo "Access your applicayion by clicking the link ---> http://192.168.49.2:31000/"
                    '''
                }
            }
        }
    }
}
