#!/bin/bash

################################################################################
#	Variables

SKU=DO280
LAB=declarative-review
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

function add_layer() {
    VERSION="$1"
    test -d "${SOLUTIONS_DIR}/${VERSION}"
    rsync -avHc "${SOLUTIONS_DIR}/${VERSION}/" "${TMP_DIR}/"
    git add .
    git commit -am "Exoplanets '${VERSION}'"
    git checkout -b "${VERSION}"
    git checkout "${GIT_DEFAULT_BRANCH}"
}

add_layer v1.1.0
add_layer v1.1.1

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
