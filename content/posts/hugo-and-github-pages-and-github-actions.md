---
title: Hugo + GitHub Pages + GitHub Actions でこの記事を世に届けている
date: 2019-09-11T12:10:48+09:00
draft: false 
---

最近自分のアカウントも GitHub Actions が有効になったので、  
早速使ってみようと思いこの GitHub Pages を Actions でリリースするようにしてみた。  
実際の YAML を見るのが早いと思うので貼る。以下の通り。

```yaml
name: publish

on:
  push:
    branches:
      - develop
jobs:
  build-deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - name: build
      uses: peaceiris/actions-hugo@v0.58.1
      with:
        args: --gc --minify --cleanDestinationDir
    - name: deploy
      uses: peaceiris/actions-gh-pages@v2.2.0
      env:
        ACTIONS_DEPLOY_KEY: ${{ secrets.ACTIONS_DEPLOY_KEY }}
        PUBLISH_BRANCH: master
        PUBLISH_DIR: ./public
```

すでに世に出回っている Action が便利なのでそれを使うだけの記事になってしまった。  

#### 参考
- https://github.com/marketplace/actions/deploy-action-for-github-pages
