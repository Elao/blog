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
  environment {
    APP_URL            = credentials('APP_URL')
    DEPLOY_DESTINATION = credentials('DEPLOY_DESTINATION')
    DEPLOY_RSYNC_RSH   = credentials('DEPLOY_RSYNC_RSH')
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
        sh "make build@$app.env APP_URL_SUBDOMAIN=$BRANCH_NAME"
      }
    }
    stage('Optimize') {
      agent { docker {
        image 'manala/hugo'
        reuseNode true
      } }
      steps {
        sh "make optimize@$app.env -j"
      }
    }
    stage('Deploy - Staging') {
      agent { docker {
        image 'manala/deploy'
        reuseNode true
      } }
      steps {
        sshagent (credentials: ['deploy']) {
          sh "make deploy.staging DEPLOY_DESTINATION_SUFFIX=$BRANCH_NAME"
        }
      }
    }
  }
  post {
    always {
      cleanWs()
    }
  }
}
