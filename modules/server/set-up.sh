#! /bin/bash

# REPLACE WITH GIT USERNAME, TOKEN AND REPO DETAILS
# example script for server set-up which:
# 1. clones repo, 2. clones nvm, 3. installs npm and dependencies, 4. installs pm2 and configures startup script

git clone https://[username]:[token]@github.com/[repo-owner]/[repo-name].git &&
cd "[repo-name]" &&
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash &&
. ~/.nvm/nvm.sh &&
nvm install --lts &&
npm install pm2@latest -g &&
npm i &&
pm2 start npm -- run start &&
pm2 startup | bash &&
pm2 save

