#!/bin/bash

set -o errexit -o nounset

if [ "$TRAVIS_BRANCH" != "development" ]
then
  echo "This commit was made against the $TRAVIS_BRANCH and not the master! No deploy!"
  exit 0
fi

rev=$(git rev-parse --short HEAD)

HSAMPLE_EVENT="${HSAMPLE_EVENT:-Open\ Tech\ Summit}"
GH_EVENT="${GH_EVENT:-FOSSASIA\ 2016}"

eval cd dist/a@a.com/$HSAMPLE_EVENT/
echo "yup this is working"
find . -type f -exec curl --ftp-ssl --cacert ../../../cacert.pem -k --user $FTP_USER:$FTP_PASSWORD --ftp-create-dirs -T {} ftp://ftp.taxation365.com:21/ots/{} \;

cd ../../../
eval cd dist/a@a.com/$GH_EVENT

git init
git config user.name "shubham-padia"
git config user.email "shubhamapadia@gmail.com"

git remote add upstream "https://$GH_TOKEN@github.com/fossasia/open-event-webapp.git"
git fetch upstream
git reset upstream/gh-pages

touch .

git add -A .
git commit -m "rebuild pages at ${rev}"
git push -q upstream HEAD:gh-pages


