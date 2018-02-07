@Library('manala') _

pipeline {
    agent {
        docker {
            image 'manala/hugo'
            args  '--volume ${JENKINS_CACHE_DIR}:/srv/cache --entrypoint='
            alwaysPull true
        }
    }
    environment {
        YARN_CACHE_FOLDER         = '/srv/cache/all/yarn'
        MANALA_CACHE_DIR          = "/srv/cache/${manalaPathize(env.GIT_URL)}/manala"
        APP_URL                   = credentials('APP_URL')
        APP_URL_SUBDOMAIN         = manalaDomainize(env.BRANCH_NAME)
        DEPLOY_DESTINATION        = credentials('DEPLOY_DESTINATION')
        DEPLOY_DESTINATION_SUFFIX = manalaDomainize(env.BRANCH_NAME)
        DEPLOY_RSYNC_RSH          = credentials('DEPLOY_RSYNC_RSH')
    }
    stages {
        stage('Install - Staging') {
            when { not { branch 'master' } }
            steps {
                sh 'make install@staging'
            }
        }
        stage('Install - Production') {
            when { branch 'master' }
            steps {
                sh 'make install@production'
            }
        }
        stage('Build - Staging') {
            when { not { branch 'master' } }
            steps {
                sh 'make build@staging'
            }
        }
        stage('Build - Production') {
            when { branch 'master' }
            steps {
                sh 'make build@production'
            }
        }
        stage('Optimize - Staging') {
            when { not { branch 'master' } }
            steps {
                sh 'make optimize@staging'
            }
        }
        stage('Optimize - Production') {
            when { branch 'master' }
            steps {
                sh 'make optimize@production'
            }
        }
        stage('Deploy - Staging') {
            steps {
                sshagent (credentials: ['deploy']) {
                  sh 'make deploy.staging'
                }
            }
        }
    }
}
