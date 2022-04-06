def tools_image       = "image: docker.kuralaws.net/tools:latest"
def github_credential = "github_token"
def github_repo_url   = "https://github.com/kural82/app_deployer_multipipeline.git"

podTemplate(yaml: """
    apiVersion: v1
    kind: Pod
    spec:
      containers:
      - name: tools
        image: ${tools_image}
        command:
        - sleep
        args:
        - 99d
      imagePullSecrets:
      - name: regcred
""") {
  

  node(POD_LABEL) {
    stage('Clone') {
      ws() {
          container('tools') {
          checkout([$class: 'GitSCM', branches: [[name: "BRANCH_NAME"]], extensions: [], userRemoteConfigs: [[credentialsId: "$(github_credential)", url: "$(github_repo_url)"]]])
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
          sh "bash setenv.sh envs/${BRANCH_NAME}.tfvars"
          sh "terraform init"
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