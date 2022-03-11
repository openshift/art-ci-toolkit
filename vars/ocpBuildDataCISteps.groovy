def call() {
    script {
        //fetching latest state (HEAD) of CHANGE_TARGET
        sh "git fetch --no-tags --progress -- ${env.GIT_URL} ${env.CHANGE_TARGET}"

        def ignoredFiles = [
            "erratatool.yml",
        ]

        modifiedFiles = sh(
            returnStdout: true,
            script: "git diff --name-only --diff-filter=ACMR \$(git ls-remote origin --tags ${env.CHANGE_TARGET} | cut -f1) ${env.GIT_COMMIT}"
        ).trim().split("\n").findAll { it.endsWith(".yml") }.findAll { !(it in ignoredFiles) }

        if ("group.yml" in modifiedFiles || "streams.yml" in modifiedFiles) {
            modifiedFiles = ["{images,rpms}/*"]
        }

        catchError(stageResult: 'FAILURE') {
            if (modifiedFiles.isEmpty()) {
                sh "echo 'No files to validate' > results.txt"
            } else {
                sh "validate-ocp-build-data ${modifiedFiles.join(" ")} > results.txt 2>&1"
            }
        }

        results = readFile("results.txt").trim()
        echo results
        String msg = ""
        def changeLogSets = currentBuild.changeSets
        for (int i = 0; i < changeLogSets.size(); i++) {
            def entries = changeLogSets[i].items
            for (int j = 0; j < entries.length; j++) {
                def entry = entries[j]
                msg = msg + "${entry.commitId}\n"
            }
        }
        commentOnPullRequest(msg: "### Build <span>#</span>${env.BUILD_NUMBER}\n```\n${results}\n```\n${msg}\n")
    }
}
