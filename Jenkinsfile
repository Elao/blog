#!groovy

def app = [
  env: (env.BRANCH_NAME == 'master') ? 'production' : 'staging'
]

pipeline {
  agent { label 'docker' }
  options {
    ansiColor('xterm')
    timestamps()
  }
  stages {
    stage('Install') {
      agent { docker {
        image 'manala/hugo'
        reuseNode true
      } }
      steps {
        sh "make install@$app.env"
      }
    }
    stage('Build') {
      agent { docker {
        image 'manala/hugo'
        reuseNode true
      } }
      steps {
        sh "make build@$app.env"
      }
    }
  }
}
