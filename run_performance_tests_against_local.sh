#!/bin/bash

export PATH=$PATH:${BIN_DIR}
export CURRENT_DIR=`pwd`

check_variable_is_set(){
    if [[ -z ${!1} ]]; then
        echo "$1 must be set and non empty"
        exit 1
    fi
}

check_variable_is_set BIN_DIR
check_variable_is_set GATLING_FOLDER_NAME
check_variable_is_set GATLING_URL
check_variable_is_set RESULTS_DIRECTORY
check_variable_is_set PERF_TEST_START_NUMBER_OF_USERS
check_variable_is_set PERF_TEST_END_NUMBER_OF_USERS
check_variable_is_set THRESHOLD_95TH_PERCENTILE_MILLIS
check_variable_is_set THRESHOLD_MEAN_MILLIS

export CF_DIR=${PERF_TESTS_DIR}/cloud_foundry
/bin/bash ${PERF_TESTS_DIR}/install_cf_cli.sh
export PATH=${PATH}:${CF_DIR}

if [[ ! -e ${BIN_DIR}/${GATLING_FOLDER_NAME} ]]; then
  echo "Downloading gatling"
  mkdir -p ${BIN_DIR}
  cd ${BIN_DIR}
  wget -q -O gatling.zip ${GATLING_URL}
  unzip -q -o gatling.zip
  rm gatling.zip
  cd ${CURRENT_DIR}
fi

export BASE_URL="http://localhost:8080"

${BIN_DIR}/${GATLING_FOLDER_NAME}/bin/gatling.sh -sf ${PERF_TESTS_DIR}/uk/gov/dhsc/htbhf --run-description "Performance tests" --results-folder ${RESULTS_DIRECTORY}
