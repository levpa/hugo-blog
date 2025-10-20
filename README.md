# Hugo blog template

## Initial configuration

```sh
# create site templates in empty folder
hugo new site blog --format yaml

# install and update PaperMod theme
git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git blog/themes/PaperMod
git submodule update --init --recursive
```

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

## Development

Create post:

```sh
# create post from template: archetypes/post.md
hugo new --kind post <name>

# or
hugo new posts/hello-world.md
```

Observe or test site locally:

```sh
hugo serve -D

# or execute with arguments:
hugo --buildDrafts    # or -D
hugo --buildExpired   # or -E
hugo --buildFuture    # or -F
```

[Web Server is at localhost:1313](http://localhost:1313/)
