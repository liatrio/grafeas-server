library 'LEAD'
 
pipeline {
  agent any 
  stages {
    stage('Build & publish grafeas image') {
      agent {
        label "lead-toolchain-skaffold"
      }   
      steps {
        notifyPipelineStart()
        notifyStageStart()
        container('skaffold') {
          sh "make build"
          script {
            notifyStageEnd([status: "Published new grafeas image: ${version()}"])
          }
        }   
      }   
      post {
        failure {
          notifyStageEnd([result: "fail"])
        }   
      }   
    }   
    stage('Chart') {
      agent {
        label "lead-toolchain-skaffold"
      }   
      steps {
        notifyStageStart()
        container('skaffold') {
          sh "make charts"
          script {
            notifyStageEnd([status: "Published new grafeas-server chart: ${version()}"])
          }
        }
      }
      post {
        failure {
          notifyStageEnd([result: "fail"])
        }
      }
    }
    stage('GitOps: Update sandbox') {
      when {
        branch 'master'
      }   
      agent {
        label "lead-toolchain-gitops"
      }   
      environment {
        GITOPS_GIT_URL = 'https://github.com/liatrio/lead-environments.git'
        GITOPS_REPO_FILE = 'aws/liatrio-sandbox/terragrunt.hcl'
        GITOPS_VALUES = "inputs.grafeas_version=${version()}"
      }   
      steps {
        container('gitops') {
          sh "/go/bin/gitops"
        }   
      }   
    }   
  }
}
def version() {
    sh(script: "git fetch --all --tags")
    return sh(script: "make version", returnStdout: true).trim()
}

