import groovy.json.JsonOutput
def call() {
    withCredentials([string(credentialsId: "openshift-bot-token", variable: "GITHUB_TOKEN")]) {
        script {
            repositoryName = env.GIT_URL.replace("https://github.com/", "").replace(".git", "")

            httpRequest(
                contentType: 'APPLICATION_JSON',
                customHeaders: [[
                    maskValue: true,
                    name: 'Authorization',
                    value: "token ${env.GITHUB_TOKEN}"
                ]],
                httpMode: 'DELETE',
                responseHandle: 'NONE',
                url: "https://api.github.com/repos/${repositoryName}/issues/${env.CHANGE_ID}/labels/art-bot-ci-passed"
            )
        }
    }
}
