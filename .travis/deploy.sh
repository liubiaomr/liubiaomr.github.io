#!/bin/bash
set -ev
export TZ='Asia/Shanghai'

# 先 clone 再 commit，避免直接 force commit
git clone -b master git@github.com:liubiaomr/liubiaomr.github.io.git _config.yml

# cd .deploy_git
# git checkout master
# cp -r ../public/* ./

# git add .
# git commit -m "Site updated: `date +"%Y-%m-%d %H:%M:%S"`"

# git push origin master:master --force --quiet
