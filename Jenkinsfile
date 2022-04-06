podTemplate(yaml: '''
    apiVersion: v1
    kind: Pod
    spec:
      containers:
      - name: tools
        image: docker.kuralaws.net/tools:latest
        command:
        - sleep
        args:
        - 99d
      imagePullSecrets:
      - name: regcred
''') {
  properties([buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '5')), parameters([choice(choices: ['dev', 'qa', 'stage', 'prod'], description: 'Please provided EnvironmentToBuild', name: 'EnvironmentToBuild')])])  
  
  node(POD_LABEL) {
    stage('Clone') {
      ws() {
          container('tools') {
          checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'github_token', url: 'https://github.com/kural82/app_deployer.git']]])
            }
        }
    }

    stage('Authentication') {
      ws() {
          container('tools') {
                sh("gcloud auth activate-service-account --key-file=service-account.json")
                sh("gcloud container clusters get-credentials project-cluster --region us-central1")
            }
        }
    }
    stage('Init') {
      ws() {
          container('tools') {
          sh 'bash setenv.sh envs/${EnvironmentToBuild}.tfvars'
          sh 'terraform init'
            }
        }
    }
    stage('deploy') {
      ws() {
          container('tools') {
            // sh 'sleep 120'
            sh 'terraform apply -var-file envs/${EnvironmentToBuild}.tfvars -auto-approve'
            }
        }
    }
  }
}