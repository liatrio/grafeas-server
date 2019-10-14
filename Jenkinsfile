library 'LEAD'
 
pipeline {
  agent any 
  environment {
    VERSION = version()
  }
  stages {
    agent {
      label "lead-toolchain-skaffold"
    }   
    stage('Build & publish grafeas image') {
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

