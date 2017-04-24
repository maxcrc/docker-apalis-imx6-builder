#!/bin/bash

CMD=${1:-"shell"}
git config --global user.email "verder@example.com"
git config --global user.name "Robot Verder"
REPO_PATH=/opt/oe-core/repo-bin
test -d "${REPO_PATH}" || mkdir "${REPO_PATH}"
export PATH="${REPO_PATH}":$PATH

if [[ "${CMD}" == "shell" ]]
then
   exec /bin/bash
fi

if [[ "${CMD}" == "sync" ]]
then	
	repo sync
fi
   
if [[ "${CMD}" == "init" ]]
then
	mkdir ~/.ssh
	echo -e "Host git.maxcrc.de\n\tStrictHostKeyChecking no\n" > ~/.ssh/config

	curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > "${REPO_PATH}"/repo
	chmod a+x "${REPO_PATH}"/repo
	repo init -u git@git.maxcrc.de:maxcrc/toradex-bsp-platform.git -b LinuxImageV2.7-maxcrc
	repo sync
	sed -ie '/if 0 == os.getuid()/d' ./layers/openembedded-core/meta/classes/sanity.bbclass
	sed -ie '/Do not use Bitbake as root./d' ./layers/openembedded-core/meta/classes/sanity.bbclass
fi


if [[ "${CMD}" == "build" ]]
then
	touch conf/sanity.conf
	. export
	bitbake -f console-trdx-image
fi

if [[ "${CMD}" == "clean" ]]
then
	rm -rf /opt/oe-core/*
	rm -rf /opt/oe-core/.*
fi
