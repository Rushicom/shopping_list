
pipeline {
    agent any

    environment {
        // FLUTTER_HOME = "/home/ubuntu/flutter"
        // ANDROID_HOME = "/home/ubuntu/android-sdk"
        // PATH = "${FLUTTER_HOME}/bin:${ANDROID_HOME}/cmdline-tools/bin:${ANDROID_HOME}/platform-tools:${env.PATH}"
        FLUTTER_HOME = "/home/worker01/flutter"
        ANDROID_HOME = "/home/worker01/android-sdk"
        PATH = "${FLUTTER_HOME}/bin:${ANDROID_HOME}/cmdline-tools/bin:${ANDROID_HOME}/platform-tools:${env.PATH}"
    }

    stages {
        stage('Environment Debug') {
            steps {
                // Debugging environment variables
                sh 'echo FLUTTER_HOME=$FLUTTER_HOME'
                sh 'echo ANDROID_HOME=$ANDROID_HOME'
                sh 'echo PATH=$PATH'
                sh 'whoami'  // Check the user running the script
                sh 'ls -l ${FLUTTER_HOME}/bin/'  // Verify that the flutter binary exists
                sh 'which flutter'  // Verify the flutter command is found
            }
        }

        stage('Checkout') {
            steps {
                git(
                    // url: 'https://github.com/SaffronEdgeTech/SaffronSync.git',
                    // branch: 'main',
                    // credentialsId: 'f2e74fff-93c9-497f-b444-72352c75d475'
                     url: 'https://github.com/Rushicom/shopping_list.git',
                    branch: 'main',
                    credentialsId: '3c505f4d-dc22-45b0-8716-2baa6d8ca436'

                )
            }
        }

        stage('Install Dependencies') {
            steps {
                // Ensure the safe directory configuration for Git
                sh 'git config --global --add safe.directory /home/ubuntu/flutter'
                sh '${FLUTTER_HOME}/bin/flutter clean'
                sh '${FLUTTER_HOME}/bin/flutter clean build'
                // Run flutter pub get to install dependencies
                sh '${FLUTTER_HOME}/bin/flutter pub get'
            }
        }

        // stage('Run Tests') {
        //     steps {
        //         // Run flutter tests
        //         sh '${FLUTTER_HOME}/bin/flutter test'
        //     }
        // }

                stage('Build APK') {
            steps {
                script {
                    // Extract the version from pubspec.yaml (without build number)
                    def version = sh(script: "grep 'version:' pubspec.yaml | head -1 | awk '{print \$2}' | cut -d '+' -f1", returnStdout: true).trim()

                    // Define custom APK name
                    // def apkName = "krushi_sanskruti_stage-v${version}.apk"
                    def apkName = "saffron_sync-v${version}.apk"

                    // Build the Flutter APK
                    sh "${FLUTTER_HOME}/bin/flutter build apk --release"

                    // Rename the APK with the custom name and version
                    sh "mv build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/${apkName}"

                    // Store the APK name for use in the Archive APK stage
                    env.APK_NAME = apkName
                }
            }
        }

        stage('Archive APK') {
            steps {
                // Archive the renamed APK file as a build artifact using the dynamic APK name
                archiveArtifacts artifacts: "build/app/outputs/flutter-apk/${env.APK_NAME}", allowEmptyArchive: false
            }
        }
    }

    post {
        always {
            // Clean up workspace after the build
            cleanWs()
        }
    }
}
