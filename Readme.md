# Hugo install

`hugo new site LevArc --format yaml`

## PaperMod install

```sh
git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
git submodule update --init --recursive # needed when you reclone your repo (submodules may not get cloned automatically)

# UPDATE: Inside the folder of your Hugo site MyFreshWebsite, run:
git submodule update --remote --merge
```

### Configuration

In `hugo.yaml` add:
```
theme: ["PaperMod"]
```
