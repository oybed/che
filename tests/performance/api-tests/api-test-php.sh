#!/bin/bash -x
set -e

wget -O /tmp/api-utils.sh https://raw.githubusercontent.com/oybed/che/main/tests/performance/api-tests/api-utils.sh
source /tmp/api-utils.sh

export TEST_DEVFILE_PATH="devfile-registry/devfiles/TP__php__php-hello-world/devworkspace-che-code-latest.yaml"
export WORKSPACE_NAME="php-hello-world"
export projectName="php-hello-world"
export expectedCommandOutput="Hello, world!"
export containerName="tools"
export commandToTest="cd /projects/$projectName; php hello-world.php >> command_log.txt; grep '$expectedCommandOutput' ./command_log.txt;"

oc login -u $OCP_USERNAME -p $OCP_PASSWORD --server=$OCP_SERVER_URL --insecure-skip-tls-verify
oc new-project ${OCP_USERNAME}-test
cd /tmp

startWorkspace ${BASE_URL} ${TEST_DEVFILE_PATH} ${WORKSPACE_NAME}

testProjectImported ${WORKSPACE_NAME} ${containerName} ${projectName}

testCommand ${WORKSPACE_NAME} ${containerName} "${commandToTest}" "${expectedCommandOutput}"

sleep 300

deleteWorkspace ${WORKSPACE_NAME}
oc delete project ${OCP_USERNAME}-test
