# Hugo blog template

## Create local dev environment

```sh
# configure your auth and signing in ~/.ssh folder and .gitconfig
/home/<user>/.ssh
├── allowed_signers
├── azure_rsa
├── config
├── github_ed25519
├── id_ed25519.pub
└── known_hosts

/home/<user>/.gitconfig
└── git_config

# Create local environment in devcontainer:
# tap in left down corner (remote type)
- Reopen in Container # look at build logs 

# container config change or rebuild:
Ctrl + Shift + P: Dev Containers: Rebuild Container (opt: without Cache)
```
