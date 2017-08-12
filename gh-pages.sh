#!/bin/bash
set -e

rm -rf gh-pages || exit 0;

mkdir -p gh-pages

cp index.html main.css main.js gh-pages

cd gh-pages

# init branch and commit
git init
git config user.name "Victor Berger (via Travis CI)"
git config user.email "victor.berger@m4x.org"
git add .
git commit -m "Deploy to GitHub Pages [Travis CI]"
git push --force "https://${GH_TOKEN}@github.com/vberger/idfma.git" master:gh-pages
