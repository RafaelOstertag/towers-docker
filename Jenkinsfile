pipeline {
    agent any

    triggers {
        pollSCM '@hourly'
    }

    options {
        ansiColor('xterm')
        buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '15')
        timestamps()
        disableConcurrentBuilds()
    }

    parameters {
        string defaultValue: 'none', description: 'Version of Artifact in Nexus', name: 'VERSION', trim: true
    }

    stages {
        stage('Build') {
            when {
                allOf {
                    expression { return params.VERSION != 'none' }
                    expression { return params.VERSION != '' }
                }
            }
            parallel {
                stage('AMD64') {
                    agent {
                        label "amd64&&docker"
                    }

                    steps {
                        withCredentials([usernamePassword(credentialsId: '750504ce-6f4f-4252-9b2b-5814bd561430', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                            sh 'docker login --username "$USERNAME" --password "$PASSWORD"'
                            sh "./build.sh ${params.VERSION}"
                        }
                    }
                }

                stage('ARM64') {
                    agent {
                        label "arm64&&docker"
                    }

                    steps {
                        withCredentials([usernamePassword(credentialsId: '750504ce-6f4f-4252-9b2b-5814bd561430', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                            sh 'docker login --username "$USERNAME" --password "$PASSWORD"'
                            sh "./build.sh ${params.VERSION}"
                        }
                    }
                }
            }
        }

        stage('Multi-Arch Image') {
            agent {
                label "docker"
            }

            when {
                allOf {
                    expression { return params.VERSION != 'none' }
                    expression { return params.VERSION != '' }
                }
            }

            steps {
                withCredentials([usernamePassword(credentialsId: '750504ce-6f4f-4252-9b2b-5814bd561430', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                    sh 'docker login --username "$USERNAME" --password "$PASSWORD"'
                    sh "./multi-arch.sh ${params.VERSION}"
                }
            }
        }
    }

    post {
        always {
            mail to: "rafi@guengel.ch",
                    subject: "${JOB_NAME} (${env.BUILD_DISPLAY_NAME}) -- ${currentBuild.currentResult}",
                    body: "Refer to ${currentBuild.absoluteUrl}"
        }
    }
}
