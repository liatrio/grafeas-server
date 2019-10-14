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
      steps {
        notifyPipelineStart()
        notifyStageStart()
        container('skaffold') {
          sh "make build"
        }   
        notifyStageEnd([status: "Published new grafeas image: ${VERSION}"])
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
  }
}
def version() {
    return sh(script: "make version", returnStdout: true).trim()
}

