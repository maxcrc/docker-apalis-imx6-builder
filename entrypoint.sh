#!/bin/bash

CMD=${1:-"shell"}

ln -s /bin/sh /bin/bash
echo "dash dash/sh boolean false" | debconf-set-selections
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

git config --global user.email "verder@example.com"
git config --global user.name "Robot Verder"
REPO_PATH=/opt/oe-core/repo-bin
test -d "${REPO_PATH}" || mkdir "${REPO_PATH}"
export PATH="${REPO_PATH}":$PATH

if [[ "${CMD}" == "sync" ]]
then	
	repo sync
	exit 0
fi

if [[ "${CMD}" == "shell" ]]
then
	exec /bin/bash
	exit 0
fi
   
if [[ "${CMD}" == "init" ]]
then
	mkdir ~/.ssh
	echo -e "Host git.maxcrc.de\n\tStrictHostKeyChecking no\n" > ~/.ssh/config

	curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > "${REPO_PATH}"/repo
	chmod a+x "${REPO_PATH}"/repo
	repo init -u git@git.maxcrc.de:maxcrc/toradex-bsp-platform.git -b LinuxImageV2.7-maxcrc
	repo sync

	#Disable root check
	
	sed -ie '/if 0 == os.getuid()/d' ./layers/openembedded-core/meta/classes/sanity.bbclass
	sed -ie '/Do not use Bitbake as root./d' ./layers/openembedded-core/meta/classes/sanity.bbclass
	. export
	exit 0
fi

. export

if [[ "${CMD}" == "clean" ]]
then
	bitbake -c cleanall angstrom-chrome-image-wanzl
	exit 0
fi

if [[ "${CMD}" == "build" ]]
then
	bitbake -f angstrom-chrome-image-wanzl
	exit 0
fi
