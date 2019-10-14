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
  }
}
def version() {
    sh(script: "git fetch --all --tags")
    return sh(script: "make version", returnStdout: true).trim()
}

