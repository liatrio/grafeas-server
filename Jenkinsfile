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
        container('skaffold') {
          sh "make build"
          stageMessage "Published new grafeas image: ${VERSION}"
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
        container('skaffold') {
          sh "make charts"
          stageMessage "Published new grafeas-server chart: ${VERSION}"
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
        GITOPS_REPO_FILE = 'aws/manifest.yml'
        GITOPS_VALUES = "liatrio_sandbox.grafeas_version=${VERSION}"
      }   
      steps {
        container('gitops') {
          sh "/go/bin/gitops"
          stageMessage "Updated the grafeas version in sandbox to: ${VERSION}"
        }   
      }   
    }   
  }
}
def version() {
    sh(script: "git fetch --all --tags")
    return sh(script: "git describe --tags --dirty", returnStdout: true).trim()
}
