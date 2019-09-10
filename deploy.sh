#!/bin/sh
set -e

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

hugo

git add -f public
git stash
git checkout master
git stash pop
ls | grep -v public | xargs rm -rf
mv public/* .

git add .
msg="rebuilding site $(LC_ALL=POSIX date)"
if [ -n "$*" ]; then
	msg="$*"
fi
git commit -m "$msg"
git push origin master
