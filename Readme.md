# Hugo install
[Hugo installation page](https://gohugo.io/installation/)
- [install Git](https://git-scm.com/downloads)
- [install GoLang](https://go.dev/doc/install)
- install Dart Sass (optional): `brew install sass/sass/sass`
- install hugo `brew install hugo`
- generate new codebase for the blog `hugo new site LevArc --format yaml`

## PaperMod theme INSTALL

```sh
git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod

# execute when you reclone your repo
git submodule update --init --recursive 
```

### PaperMod them UPDATE
`git submodule update --remote --merge`

### Configuration

In `hugo.yaml` add:
```
theme: ["PaperMod"]
```
## Development
Create post:

```sh
# create post from template: archetypes/post.md
hugo new --kind post <name>
```
Observe or test site locally:
---
```sh
hugo serve

# or execute with arguments:
hugo --buildDrafts    # or -D
hugo --buildExpired   # or -E
hugo --buildFuture    # or -F
```
---
[Web Server is at localhost:1313](http://localhost:1313/)
