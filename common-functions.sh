#!/bin/bash

#
# Common functions used in scripts.
#

# ensure the script is sourced
if [ "${BASH_SOURCE[0]}" -ef "$0" ]
then
    echo "Hey, you should source this script, not execute it!"
    exit 1
fi

#
# reporting
#

export RED='\033[1;31m'
export WHITE='\033[1;37m'
export YELLOW='\033[1;33m'
export NC='\033[0m'

if [ "$BATCH_MODE" == "yes" ] ; then
	export ERROR="[error]"
	export WARNING="[warning]"
	export INFO="[info]"
	export DEBUG_INFO="[debug]"
else
	export ERROR="${RED}[error]${NC}"
	export WARNING="${YELLOW}[warning]${NC}"
	export INFO="${WHITE}[info]${NC}"
	export DEBUG_INFO="${WHITE}[debug]${NC}"
fi

function error() {
	echo -e "${ERROR} $@"
}

function warn() {
	echo -e "${WARNING} $@"
}

function info() {
	echo -e "${INFO} $@"
}

function info_n() {
	echo -n -e "${INFO} $@"
}

function debug() {
	if [ "${DEBUG}" == "yes" ] ; then
		echo -e "${DEBUG_INFO} $@"
	fi
}

#
# functions
#

# $1 = NAME, $2 = EXECUTABLE
function checkExecutable() {
	if [ "$2" == "" ] ; then
		error "$1 variable for executable not set."
		exit 1
	fi
	if [ ! -x "$2" ] ; then
		error "$1 not found at: $2"
		exit 1
	fi
}

# $1 = NAME, $2 = FILE
function checkFile() {
	if [ "$2" == "" ] ; then
		error "$1 variable for file not set."
		exit 1
	fi
	if [ ! -f "$2" ] ; then
		if [ "$3" == "clean" ] ; then
			touch "$2"
		else
			error "$1 not found at: $2"
			exit 1
		fi
	else
		if [ "$3" == "clean" ] ; then
			info "$1 recreated, now empty"
			rm -f "$2"
			touch "$2"
		fi
	fi
}

# $1 = NAME, $2 = FILE
function checkDirectory() {
	if [ "$2" == "" ] ; then
		error "$1 directory variable not set."
		exit 1
	fi
	if [ ! -d "$2" ] ; then
		if [ "$3" == "create" ] || [ "$3" == "recreate" ] ; then
			info "$1: directory does not exist, creating it"
			mkdir -p "$2"
		else
			error "$1: directory $2 does not exist."
			exit 1
		fi
	else
		if [ "$3" == "recreate" ] ; then
			info "$1: exists, recreating it"
			rm -rf "$2"
			mkdir -p "$2"
		fi
	fi
}

#
# default constants
#

DATA_DIR="${BASE_DIR}/data"

MODEL_DIR="${BASE_DIR}/models"
MODEL_FILE_DIR="${MODEL_DIR}/file"
MODEL_MAP_DIR="${MODEL_DIR}/map"
MODEL_FILE_MAP_DIR="${MODEL_DIR}/file-map"
MODEL_FILE_INTERFACE_DIR="${MODEL_DIR}/file-interface"
MODEL_MAP_INTERFACE_DIR="${MODEL_DIR}/map-interface"
MODEL_FILE_MAP_INTERFACE_DIR="${MODEL_DIR}/file-map-interface"

MAP_FILE="${BASE_DIR}/module-file-function-map.csv"

# end
