pipeline {

    agent { label params.SELECTED_NODE_LABEL }

    parameters {
        choice(name: 'SELECTED_NODE_LABEL', choices: ['auto_agent'], description: 'Node to run the pipeline')
        string(name: 'TARGET_BRANCH', defaultValue: 'staging', description: 'Branch to checkout')
        string(name: 'AZURE_TAG_NAME', defaultValue: 'latest', description: 'Azure Pipeline TagName')
        choice(name: 'ENVIRONMENT', choices: ['dev', 'staging', 'staging.aws','uat.aws','uat'], description: 'Environment to run tests against')
        choice(name: 'REQUIREMENTS_CHANGED', choices: ['false', 'true'], description: 'Flag to check if requirements.txt was modified')
        choice(name: 'TESTING_TYPE', choices: ['smoke.aws', 'warmup', 'regression', 'edi'], description: 'Type of testing to run')
        string(name: 'TEST_IDS', defaultValue: 'OD_100', description: 'Test IDs to run')
        choice(name: 'TEST_EXECUTION_TYPE', choices: ['serialize', 'parallel'], description: 'Type of testing to run')
        string(name: 'TESTING_ROLE', defaultValue: 'Prime', description: 'Test role to run')
        string(name: 'MAX_EXECUTION_TIME', defaultValue: '60', description: 'Maximum execution time for the pipeline (in minutes)')
        string(name: 'WAIT_TIME', defaultValue: '0', description: 'Wait time for the pipeline to start (in minutes)')
    }

    stages {
        stage('Checkout on Linux') {
            when {
                expression {
                    return params.SELECTED_NODE_LABEL == 'MASTER' || params.SELECTED_NODE_LABEL == 'auto_agent'
                }
            }
            steps {
                script {
                    def gitUrl = scm.userRemoteConfigs[0].url
                    withCredentials([usernamePassword(credentialsId: 'github-fine-grained-token', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')]) {
                        def gitUrlWithCredentials = gitUrl.replaceFirst(/https:\/\/[^@]+@/, "https://${GIT_USERNAME}:${GIT_PASSWORD}@")
                        checkout([
                            $class: 'GitSCM',
                            branches: [[name: "*/${params.TARGET_BRANCH}"]],
                            userRemoteConfigs: [[
                                url: gitUrlWithCredentials,
                                credentialsId: 'github-fine-grained-token'
                            ]]
                        ])
                    }
                }
            }
        }

        stage ('Verbose') {
            steps {
                echo "Test IDs: ${params.TEST_IDS}"
                echo "Environment: ${params.ENVIRONMENT}"
                echo "Requirements Changed: ${params.REQUIREMENTS_CHANGED}"
                echo "Testing Type: ${params.TESTING_TYPE}"
                echo "Test Execution Type: ${params.TEST_EXECUTION_TYPE}"
                echo "Testing Role: ${params.TESTING_ROLE}"
                echo "Container Name: ${params.CONTAINER_NAME}"
                echo "Max Execution Time: ${params.MAX_EXECUTION_TIME}"
            }
        }

        stage('Transform Config File') {
            steps {
                script {
                    try {
                        echo "Environment: ${params.ENVIRONMENT}"
                        def secretCredentialId = "${params.ENVIRONMENT}.json"

                        withCredentials([file(credentialsId: secretCredentialId, variable: 'SECRET_FILE')]) {
                            def configFile = "configs/site/${params.ENVIRONMENT}.json"
                            def configFileFullPath = "${WORKSPACE}/${configFile}"
                            def secretFileFullPath = SECRET_FILE
                            def configFileContent = readFile secretFileFullPath
                            writeFile file: configFileFullPath, text: configFileContent
                        }

                    } catch (Exception e) {
                        echo 'Exception occurred: ' + e.toString()
                    }
                }
            }
        }

        stage('Install Dependencies on Linux') {
            when {
                expression {
                    return (params.SELECTED_NODE_LABEL == 'MASTER' || params.SELECTED_NODE_LABEL == 'auto_agent')
                }
            }
            steps {
                script {
                    def changes = sh(script: "git diff HEAD^ HEAD --name-only | grep 'requirements.txt' || true", returnStdout: true).trim()

                    if(params.REQUIREMENTS_CHANGED == 'true' || changes.contains('requirements.txt')) {
                        env.REQUIREMENTS_CHANGED = 'true'
                        echo "Requirements.txt changed: ${env.REQUIREMENTS_CHANGED}"
                    } else {
                        env.REQUIREMENTS_CHANGED = 'false'
                        echo "Requirements.txt not changed: ${env.REQUIREMENTS_CHANGED}"
                    }
                }
            }
        }

        stage('Run Tests on Linux') {
            when {
                expression {
                    return params.SELECTED_NODE_LABEL != 'MASTER'
                }
            }
            steps {
                script {
                    // if ENVIRONMENT is PROD or STAGING or QA, add sleep time to wait for the deployment to be completed
                    if (params.ENVIRONMENT == 'staging' || params.ENVIRONMENT == 'prod') {
                        def waitTime = Integer.parseInt(params.WAIT_TIME) * 60
                        echo "Waiting ${waitTime} seconds for deployment to complete prior starting automation testing"
                        sleep waitTime
                    }
                    try {
                        sh '''
                            source /home/jenkins-agent/.bashrc
                            ENVNAME=fusebox
                            python3 --version
                            python3 -m venv $ENVNAME
                            source $ENVNAME/bin/activate

                            if [ "$REQUIREMENTS_CHANGED" = "true" ]; then
                                echo 'Updating libraries...'
                                python -m pip install --upgrade pip
                                python -m pip install -r requirements.txt
                                pip list
                            else
                                echo 'Skipping library updates...'
                            fi
                            python runner.py -e $ENVIRONMENT --test-ids "$TEST_IDS" --max-execution-time $MAX_EXECUTION_TIME --testing-role $TESTING_ROLE --execution-url $BUILD_URL --testing-type $TESTING_TYPE --test-execution-type $TEST_EXECUTION_TYPE
                        '''
                    } catch (Exception e) {
                        error("Runner execution failed.")
                    }
                }
            }
        }
    }


    post {
        always {
            archiveArtifacts artifacts: 'results/report_archive/report_archive.zip', allowEmptyArchive: true

            script {
                def buildStatus = currentBuild.currentResult ?: 'SUCCESS'
                def statusEmoji = (buildStatus == 'SUCCESS') ? "✅" : "❌"
                def statusColor = (buildStatus == 'SUCCESS') ? "Good" : "Attention"

                
                withCredentials([string(credentialsId: 'teams-webhook-url', variable: 'TEAMS_WEBHOOK_URL')]) {
                    def teamsCard = """
                    {
                        "type": "message",
                        "attachments": [
                            {
                                "contentType": "application/vnd.microsoft.card.adaptive",
                                "content": {
                                    "\$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
                                    "type": "AdaptiveCard",
                                    "version": "1.4",
                                    "body": [
                                        {
                                            "type": "TextBlock",
                                            "text": "${statusEmoji} Jenkins Build: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                                            "weight": "Bolder",
                                            "size": "Medium",
                                            "color": "${statusColor}"
                                        },
                                        {
                                            "type": "FactSet",
                                            "facts": [
                                                { "title": "Status:", "value": "${buildStatus}" },
                                                { "title": "Environment:", "value": "${params.ENVIRONMENT ?: 'N/A'}" },
                                                { "title": "Branch:", "value": "${params.TARGET_BRANCH ?: 'main'}" },
                                                { "title": "Testing Type:", "value": "${params.TESTING_TYPE}" },
                                                { "title": "Duration:", "value": "${currentBuild.durationString}" }
                                            ]
                                        }
                                    ],
                                    "actions": [
                                        {
                                            "type": "Action.OpenUrl",
                                            "title": "🔍 View Console / Report",
                                            "url": "${env.BUILD_URL}"
                                        }
                                    ]
                                }
                            }
                        ]
                    }
                    """

                    writeFile file: 'teams_payload.json', text: teamsCard
                    sh '''
                        curl -s -H "Content-Type: application/json" -X POST -d @teams_payload.json "$TEAMS_WEBHOOK_URL"
                        rm -f teams_payload.json
                    '''
                }
            }

            echo "Cleaning up..."
            sh '''
                echo "Cleaning up Chrome/Chromium temp directories..."
                rm -rf /tmp/com.google.Chrome.* /tmp/org.chromium.Chromium.* || true
            '''
        }
    } 

}
