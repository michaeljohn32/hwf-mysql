#!groovy
def buildVersion = null
node {
   // Mark the code checkout 'stage'....
   stage 'Checkout'
       git url: 'https://github.com/michaeljohn32/hwf-mysql.git'
   
   stage 'Build Docker Image'
       def hwfMysqlAppImage 
       sh "/bin/ls"
       // copy any needed files from git repo to target directory
       sh "mkdir target || echo 'target folder'"
       sh "cp -R Dockerfile info.xml support_files target"
       def matcher = readFile('info.xml') =~ '<version>(.+)</version>'
       if (matcher) {
         buildVersion = matcher[0][1]
         echo "Release version: ${buildVersion}"
       }
       matcher = null
       dir('target') {
            hwfMysqlAppImage = docker.build "michaeljohn32/hwf-mysql:${buildVersion}"
//            if (hwfMysqlAppImage.indexOf("sha256"))
//            {
//              hwfMysqlAppImage = hwfMysqlAppImage.substring(6)
//            }
       }
       sh "/bin/ls"

    stage "Publish and Deploy?"
        input 'Do you want to publish and deploy this image?'

    stage "Publish Docker Image"
        sh "docker -v"
        withDockerRegistry(registry: [credentialsId: 'docker-hub-michaeljohn32']) {
                hwfMysqlAppImage.push()
        }
    stage "Deploy the Image"
        sh "docker stop hwf-mysql-prod || echo 'No Container deployed'"
        sh "docker rm hwf-mysql-prod || echo 'No Container to delete'"
        sh "docker run -d -p 3306:3306 -e MYSQL_ALLOW_EMPTY_PASSWORD=1 --name hwf-mysql-prod 'michaeljohn32/hwf-mysql:${buildVersion}'"
}
