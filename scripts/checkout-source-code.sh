#!/bin/bash
 
source basefunctions.conf

#function checkout() {
#    set -e
#
#    # Basic git operations
#    git clean -f
#    git fetch
#    git-lfs fetch
#    git-lfs checkout
#
#    # If re-running previously ran build, revert to original commit:
#    if [ ! -z "${bamboo_RerunBuildTriggerReason_noOfRetries}" ]; then
#        if [[ "${bamboo_BRANCH}" = "master" ]]; then
#            echo "### INFO: Reverting to original specified branch/revision: \"${bamboo_BRANCH}\""
#            git reset --hard origin/"${bamboo_BRANCH}" || echo "git-reset returned $?"
#	    exit 0
#        else
#            echo "### Reverting to original branch/revision build run: ${bamboo_repository_git_branch} / ${bamboo_repository_revision_number}"
#            git reset --hard "${bamboo_repository_revision_number}" || echo "git-reset returned $?"
#	    exit 0
#        fi
#    fi
#
#    # If BRANCH var is specified:
#    if [ ! -z "${bamboo_BRANCH}" ]; then
#        echo "### INFO: Checking out from specified branch: \"${bamboo_BRANCH}\""
#        
#        if git checkout -f ${bamboo_BRANCH}; then
#            echo "### INFO: Successfully checked out from: \"${bamboo_BRANCH}\""
#      	 else
#	    exit 1
#        fi
#
#        if git pull; then
#            echo "### INFO: git pull successful!"
#        else
#            git reset --hard origin/"${bamboo_BRANCH}"
#        fi
#    else
#        git checkout -f ${bamboo_repository_git_branch}
#        echo "INFO: Successfully checked out from: ${bamboo_repository_git_branch}"
#        if git pull; then
#            echo "INFO: git pull successful!"
#        else
#            git reset --hard origin/${bamboo_repository_git_branch}
#        fi
#    fi
#
#    # Ensure latest git submodules
#    if git submodule foreach git clean -f; then
#        echo "### INFO: Successfully cleaned submodules"
#    fi
#    if git submodule foreach git pull --ff-only origin master; then
#        echo "### INFO: Successfully updated git submodules"
#    else
#	echo "### ERROR: git submodules operation encountered an error, performing a git clean and re-pull ..."
#	git submodule foreach git reset --hard origin master
#	git submodule foreach git pull --ff-only origin master
#    fi
#    git show
#}

# Precise
if [[ ${bamboo_OS} = 'precise' ]]; then
    export FILEPATH=/home/bamboo/vm/u12-build-server/vada
    ssh_into_ciserver <<-EOF1
	$(typeset -f checkout)
	echo "### INFO: Performing source code checkout on \"${bamboo_OS}\" build server ..."
	cd ${FILEPATH} && echo "### INFO: Changed directory to ${FILEPATH}"
	scp -o StrictHostKeyChecking=no package.json vagrant@10.1.0.231:/tmp	# Copy previous package.json for comparison
	checkout 
EOF1

# Embassy
elif [[ ${bamboo_REPO} = 'embassy' ]]; then
    ssh_into_ciserver <<-EOF2
	$(typeset -f checkout)
        echo "### INFO: Performing \"${bamboo_REPO}\" repo source code checkout on ciserver build server ..."
	cd ~/repos/${bamboo_REPO} && echo "### INFO: Changed directory to `pwd`"
	checkout
EOF2

# Bionic
elif [[ ${bamboo_OS} = 'bionic' ]] || [[ ${bamboo_PRODUCT} = 'passport' ]]; then
    export FILEPATH=/home/atxuser/vada
    ssh_into_bionic <<EOF3
	$(typeset -f checkout)
	echo "### INFO: Performing source code checkout on \"${bamboo_OS}\" build server ..."    
	cd ${FILEPATH} && echo "### INFO: Changed directory to ${FILEPATH}"
	cp -v package.json /tmp		# Copy previous package.json for comparison
	checkout
EOF3

# CentOS
else
    ssh_into_container <<-EOF4
	$(typeset -f checkout)
        echo "### INFO: Performing source code checkout in docker container \"${bamboo_CONTAINER_NAME}\"..."
	cd ~/vada && echo "### INFO: Changed directory to `pwd`"
        cp -v package.json /tmp		# Copy previous package.json for comparison
	checkout
EOF4
fi
