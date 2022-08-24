#!/bin/bash

#
# Run anaylsis experiment for UVic
#
# Usage: experiment.sh

# configure base dir
BASE_DIR=$(cd "$(dirname "$0")"; pwd)

#
# source functionality
#

if [ ! -d "${BASE_DIR}" ] ; then
	echo "Base directory ${BASE_DIR} does not exist."
	exit 1
fi

if [ -f "${BASE_DIR}/common-functions.sh" ] ; then
	source "${BASE_DIR}/common-functions.sh"
else
	echo "Missing library: ${BASE_DIR}/common-functions.sh"
	exit 1
fi

# load configuration and common functions
if [ -f "${BASE_DIR}/config.rc" ] ; then
	source "${BASE_DIR}/config.rc"
else
	echo "Missing configuration: ${BASE_DIR}/config.rc"
	exit 1
fi


#
# check for tools
#

checkExecutable dar "${DAR_BIN}"
checkExecutable maa "${MAA_BIN}"
checkExecutable addr2line "${ADDR2LINE_BIN}"

checkFile uvic "${UVIC_BIN}"
checkFile map-file "${MAP_FILE}"
checkFile project-file-template "${BASE_DIR}/.project.template"

checkDirectory data-kieker-directory "${DATA_KIEKER_DIR}"

#
# run experiment
#

"${DAR_BIN}" -l dynamic -a "${ADDR2LINE_BIN}" -c -e  "${UVIC_BIN"} -o "${MODEL_FILE_DIR}" -s elf -m file-mode -E ssp -i "${DATA_KIEKER_DIR}"
"${BASE_DIR}/cleanup-model.sh" "${MODEL_FILE_DIR}"

"${DAR_BIN}" -l dynamic -a "${ADDR2LINE_BIN}" -c -e  "${UVIC_BIN}" -o "${MODEL_MAP_DIR}" -s elf -ms , -m map-mode -M "${MAP_FILE}" -E ssp -i "${DATA_KIEKER_DIR}"
"${BASE_DIR}/cleanup-model.sh" "${MODEL_DIR_DIR}"

"${MAA_BIN}" -s -I -i "${MODEL_MAP_DIR}" -c -o "${MODEL_MAP_INTERFACE_DIR}"
"${BASE_DIR}/cleanup-model.sh" "${MODEL_FILE_DIR}"

"${MAA_BIN}" -s -I -i "${MODEL_FILE_DIR}" -c -o "${MODEL_FILE_INTERFACE_DIR}" 
"${BASE_DIR}/cleanup-model.sh" "${MODEL_FILE_INTERFACE_DIR}"

"${MAA_BIN}" -s -g "${MAP_FILE}" -i "${MODEL_FILE_DIR}"  -c -o "${MODEL_FILE_MAP_DIR}"
"${BASE_DIR}/cleanup-model.sh" "${MODEL_FILE_MAP_DIR}"

"${MAA_BIN}" -s -I -i "${MODEL_FILE_MAP_DIR}"  -c -o "${MODEL_FILE_MAP_INTERFACE_DIR}"
"${BASE_DIR}/cleanup-model.sh" "${MODEL_FILE_MAP_INTERFACE_DIR}"

for P in $MODEL_FILE_DIR $MODEL_MAP_DIR $MODEL_FILE_MAP_DIR $MODEL_FILE_INTERFACE_DIR $MODEL_MAP_INTERFACE_DIR $MODEL_FILE_MAP_INTERFACE_DIR ; do
	if [ -d $P ] ; then
		rm -rf $P
	fi
	NAME=`basename $P`
	cat "${BASE_DIR}/.project.template" | sed "s/%NAME%/$NAME/g" > "${P}/.project"
done

# end
