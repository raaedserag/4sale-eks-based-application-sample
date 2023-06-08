codecommit_repo_name = "ping-pong"
repository_branch = "feature/build-pipeline"
environments_config = [
    {
        name = "staging"
        manual_approval_required = false
    },
    {
        name = "production"
        manual_approval_required = true
    }
]