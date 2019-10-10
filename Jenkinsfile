library 'LEAD'
 
pipeline {
  agent any 
  environment {
    VERSION = version()
  }
  stages {
    stage('Build & publish image') {
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
				when {
						branch 'master'
				}
				steps {
						notifyStageStart()
						container('skaffold') {
								sh "make charts"
								script {
										def version = sh ( script: "make version", returnStdout: true).trim()
										notifyStageEnd([status: "Published new grafeas server chart: ${version}"])
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
    return sh(script: "git describe --tags --dirty", returnStdout: true).trim()
}

