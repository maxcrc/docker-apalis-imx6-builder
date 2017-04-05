#!/bin/bash

CMD=${1:-"shell"}

git config --global user.email "verder@example.com"
git config --global user.name "Robot Verder"
REPO_PATH=/opt/oe-core/repo-bin
test -d "${REPO_PATH}" || mkdir "${REPO_PATH}"
export PATH="${REPO_PATH}":$PATH

if [[ "${CMD}" == "sync" ]]
then
	repo sync
fi
   
if [[ "${CMD}" == "init" ]]
then
	curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > "${REPO_PATH}"/repo
	chmod a+x "${REPO_PATH}"/repo
	repo init -u git@git.maxcrc.de:maxcrc/toradex-bsp-platform.git -b LinuxImageV2.7-maxcrc
	repo sync
fi


if [[ "${CMD}" == "build" ]]
then
   . export
   bitbake -f console-trdx-image
fi


if [[ "${CMD}" == "shell" ]]
then
   exec /bin/bash
fi


