#!/bin/bash
set -ev
export TZ='Asia/Shanghai'

# 先 clone 再 commit，避免直接 force commit
# git clone -b master git@github.com:liubiaomr/liubiaomr.github.io.git .deploy_git

cd .deploy_git
git checkout master
mv .git/ ../public/
cd ../public

git add .
git commit -m "Site updated: `date +"%Y-%m-%d %H:%M:%S"`"

# 同时 push 一份到自己的服务器上
git remote add vps git@47.52.116.180:/var/repo/blog.git

git push vps master:master --force --quiet
git push origin master:master --force --quiet