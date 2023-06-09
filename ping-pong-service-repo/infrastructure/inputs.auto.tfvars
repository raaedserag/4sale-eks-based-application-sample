codecommit_repo_name = "ping-pong"
repository_branch = "master"
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