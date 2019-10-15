library 'LEAD'
 
pipeline {
  agent any 
  environment {
    VERSION = version()
  }
  stages {
    stage('Build & publish grafeas image') {
      agent {
        label "lead-toolchain-skaffold"
      }   
      when {
        branch 'master'
      }
      steps {
        notifyPipelineStart()
        notifyStageStart()
        container('skaffold') {
          sh "make build"
          script {
            notifyStageEnd([status: "Published new grafeas image: ${VERSION}"])
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
      when {
        branch 'master'
      }
      steps {
        notifyStageStart()
        container('skaffold') {
          sh "make charts"
          script {
            notifyStageEnd([status: "Published new grafeas-server chart: ${VERSION}"])
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
      agent {
        label "lead-toolchain-gitops"
      }   
      when {
        branch 'master'
      }
      environment {
        GITOPS_GIT_URL = 'https://github.com/liatrio/lead-environments.git'
        GITOPS_REPO_FILE = 'aws/liatrio-sandbox/terragrunt.hcl'
        GITOPS_VALUES = "inputs.grafeas_version=${VERSION}"
      }   
      steps {
        notifyStageStart()
        container('gitops') {
          sh "/go/bin/gitops"
          script {
            notifyStageEnd([status: "Updated the grafeas version in sandbox to: ${VERSION}"])
          }
        }   
      }   
      post {
        failure {
          notifyStageEnd([result: "fail"])
        }
      }
    }   
  }
}
def version() {
    sh(script: "git fetch --all --tags")
    return sh(script: "git describe --tags --dirty", returnStdout: true).trim()
}
