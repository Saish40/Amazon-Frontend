pipeline{
    agent any
    tools {
        jdk 'jdk17'
        nodejs 'node16'
    }
    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('GIT SCM') {
            steps {
                git 'https://github.com/Saish40/Amazon-Frontend.git'
            }
        }

        stage("Sonarqube Analysis "){
            steps{
                script {
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Amazon \
                    -Dsonar.projectKey=Amazon '''
                }
            }
        }
    }

    stage("quality gate"){
           steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-cred' 
                }
            } 
        }

        stage('Install Dependencies') {
            steps {
                sh "npm install"
            }
        }

        stage('TRIVY FS SCAN') {
            steps {
                sh "trivy fs . > trivyfs.txt"
            }
        }

        stage("Docker Build & Push"){
            steps{
                script{
                   withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker'){   
                       sh "docker build -t amazon ."
                       sh "docker tag amazon saish69/amazon:latest "
                       sh "docker push saish69/amazon:latest "
                    }
                }
            }
        }
        stage("TRIVY"){
            steps{
                sh "trivy image saish69/amazon:latest > trivyimage.txt" 
            }
        }

        stage('Deploy to container'){
            steps{
                sh 'docker run -d --name amazon -p 3000:3000 saish69/amazon:latest'
            }
        }
    }
}