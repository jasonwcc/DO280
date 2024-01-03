#!/bin/bash

################################################################################
#	Variables

SKU=DO280
LAB=declarative-manifests
APP_DIR="${LAB}"

GITLAB_HOSTNAME="git.ocp4.example.com"
GITLAB_USERNAME="developer"
GITLAB_PASSWORD="developer"
GITLAB_NAMESPACE="${GITLAB_USERNAME}"

GITLAB_REMOTE=https://${GITLAB_USERNAME}:${GITLAB_PASSWORD}@${GITLAB_HOSTNAME}/${GITLAB_NAMESPACE}/${LAB}.git
GIT_DEFAULT_BRANCH=main

LABS_DIR="${HOME}/${SKU}/labs/${LAB}"
SOLUTIONS_DIR="${HOME}/${SKU}/solutions/${LAB}"

export PAGER=cat
export TERM=linux
export NO_COLOR=1
export NO_PROMPT=1

set -exuo pipefail

################################################################################
#	Configure GIT
git config --global user.name  'Student User'
git config --global user.email 'student@workstation.lab.example.com'
git config --global init.defaultBranch "${GIT_DEFAULT_BRANCH}"

# TODO: Configure git-credential-manager (cache or libsecret)

################################################################################
#	Create temporary directory to "bake" the git repository

for DIR in "${LABS_DIR}" "${SOLUTIONS_DIR}"
do
  test -d "${DIR}" || mkdir -vp "${DIR}"
done

TMP_DIR="/tmp/${LAB}"
test -d "${TMP_DIR}" && rm -vrf "${TMP_DIR}"
mkdir -vp "${TMP_DIR}"
pushd "${TMP_DIR}"

################################################################################
#	Prepare GIT repository

# Initial commit
git init .
touch .gitkeep
git add .gitkeep
git commit -m "Initial commit" .gitkeep
git branch -M "${GIT_DEFAULT_BRANCH}"

# README
touch README.md
echo "Exoplanets" >> README.md
git add README.md
git commit -m "README" README.md

# Add reference to remote repository
git remote add origin "${GITLAB_REMOTE}"

#	v1.0
cp -v "${SOLUTIONS_DIR}"/database-v1.0.yaml database.yaml
git add database.yaml
git commit -m "Database v1.0" database.yaml
cp -v "${SOLUTIONS_DIR}"/exoplanets-v1.0.yaml exoplanets.yaml
git add exoplanets.yaml
git commit -m "Exoplanets v1.0" exoplanets.yaml
git tag -a -m "first app version" first
git checkout -b v1.0
git checkout "${GIT_DEFAULT_BRANCH}"

#	v1.1.0
# cp -v "${SOLUTIONS_DIR}"/database-v1.1.0.yaml database.yaml
# git add database.yaml
# git commit -m "Database v1.1.0" database.yaml
cp -v "${SOLUTIONS_DIR}"/exoplanets-v1.1.0.yaml exoplanets.yaml
git add exoplanets.yaml
git commit -m "Exoplanets v1.1.0" exoplanets.yaml
git tag -a -m "second app version" second
git checkout -b v1.1.0
git checkout "${GIT_DEFAULT_BRANCH}"

#	v1.1.1
cp -v "${SOLUTIONS_DIR}"/database-v1.1.1.yaml database.yaml
git add database.yaml
git commit -m "Database v1.1.1" database.yaml
cp -v "${SOLUTIONS_DIR}"/exoplanets-v1.1.1.yaml exoplanets.yaml
git add exoplanets.yaml
git commit -m "Exoplanets v1.1.1" exoplanets.yaml
git tag -a -m "third app version" third
git checkout -b v1.1.1
git checkout "${GIT_DEFAULT_BRANCH}"

################################################################################
#	Finish

echo "${TMP_DIR}"

ls -la
git log --decorate=full --oneline --color=never
git log --name-status --color=never

# Push the "baked" repo to the GitLab server
git push -u origin --mirror
git fetch
git pull

popd

# Delete "${TMP_DIR}"
test -d "${TMP_DIR}" && rm -vrf "${TMP_DIR}"
unset SSH_ASKPASS
