{
    "auths":
    {
        "ghcr.io":
            {
                "auth":"${ local.docker_secret_encoded }"
            }
    }
}
