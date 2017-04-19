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
    stage('Deploy - Staging') {
      agent { docker {
        image 'manala/deploy'
        reuseNode true
      } }
      environment {
          DEPLOY_DESTINATION = credentials('DEPLOY_DESTINATION')
          DEPLOY_RSH = credentials('DEPLOY_RSH')
      }
      steps {
        sshagent (credentials: ['deploy']) {
          sh "make deploy-staging DEPLOY_DESTINATION=${env.DEPLOY_DESTINATION + '/' + env.BRANCH_NAME}"
        }
      }
    }
  }
}
