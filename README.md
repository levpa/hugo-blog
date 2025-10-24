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
# install precommit hook (local validations)
make precommit

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
# create post from archetype: archetypes/post.md
make new-post

# draft development
make serve

# publish drafts for release
make publish-drafts

# git add/commit/push changes
# deploy new release to github-pages
make release
```

[Web Server is at localhost:1313](http://localhost:1313/)

### Utility

```sh

# Create icons for the site with ImageMagick
convert --version
convert input.png -define icon:auto-resize=64,48,32,16 favicon.ico
convert label.png -resize 40x40 label-icon.png

# Windows /Pictures and /Documents folder binds here:
ls $HOME/Pictures $HOME/Documents

# Example to copy from Windows
cp $HOME/Pictures/profile/profile.png blog/content/about
```
