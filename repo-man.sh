#!/usr/bin/env bash

_script_name=$(basename -s .sh "$0")
#-----------------------------------
# Usage Section

#<usage>
function __show_help__ {
	cat << EOF
Usage: ${_script_name} [OPTIONS] [<arguments>]

Description: Manage your repos, man!

Options:
  -d, --debug	Enable debug mode
  -h, --help	Display this help message

Examples:
  ${_script_name} foo
  ${_script_name} --debug bar
EOF
}

#</usage>

#<created>
# Created: 2026-06-29T09:34:29+00:00
# Tristan M. Chase <tristan.m.chase@gmail.com>
#</created>

#<depends>
# Depends on:
#  list
#  of
#  dependencies
#</depends>

#-----------------------------------
# TODO Section

#<todo>
# TODO
# * Insert script
# * Clean up stray ;'s
# * Modify command substitution to "$(this_style)"
# * Rename function_name() to function __function_name__ /\w+\(\)
# * Rename $variables to "${_variables}" /\$\w+/s+1 @v vEl,{n
# * Check that _variable="variable definition" (make sure it's in quotes)
# * Update usage, description, and options section
# * Update dependencies section

# DONE

#</todo>

#-----------------------------------
# License Section

#<license>
# Put license here
#</license>

#-----------------------------------
# Runtime Section

#<main>
# Initialize variables
#_temp="file.$$"
_repo=$(basename $(pwd))
# List of temp files to clean up on exit (put last)
#_tempfiles=("${_temp}")

# Put main script here
function __main_script__ {

	printf "%b\n" "${_repo}"

} #end __main_script__
#</main>

#-----------------------------------
# Local functions

#<functions>

function __create_repo__ {
	echo "# "${_repo}"" >> README.md
	git init
	git add --all
	#git add README.md
	git commit -m "First commit"
	git remote add origin git@github.com:tristanchase/"${_repo}".git
	git branch -M main
	git push -u origin main:
}

function __local_cleanup__ {
	:
}

function __push_existing__ {
	git remote add origin git@github.com:tristanchase/"${_repo}".git
	git branch -M main
	git push -u origin main:
}

#</functions>

#-----------------------------------
# Source helper functions
for _helper_file in functions colors git-prompt; do
	if [[ ! -e ${HOME}/."${_helper_file}".sh ]]; then
		printf "%b\n" "Downloading missing script file "${_helper_file}".sh..."
		sleep 1
		wget -nv -P ${HOME} https://raw.githubusercontent.com/tristanchase/dotfiles/main/"${_helper_file}".sh
		mv ${HOME}/"${_helper_file}".sh ${HOME}/."${_helper_file}".sh
	fi
done

source ${HOME}/.functions.sh

#-----------------------------------
# Get some basic options
# TODO Make this more robust
#<options>
shopt -s extglob
case "${1:-}" in
	(-d|--debug) __debugger__ ;;
	(-h|--help) __show_help__ ; exit 2 ;;
	(-c|--create-repo) __create_repo__ ;;
	(-e|--push-existing) __push_existing__ ;;
	(-*|--*)  printf "%b\n" ""${_script_name}": Option \""${1:-}"\" not recognized."  1>&2 ; __show_help__ ; exit 2  1>&2 ;;
	#('') printf "%b\n" ""${_script_name}": Argument required." 1>&2 ; __show_help__ ; exit 2  1>&2 ;;
	(*) _arg="${1:-}"
esac
#</options>

#-----------------------------------
# Bash settings
# Same as set -euE -o pipefail
#<settings>
set -o errexit
set -o nounset
set -o errtrace
set -o pipefail
IFS=$'\n\t'
#</settings>

#-----------------------------------
# Main Script Wrapper
if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
	trap __traperr__ ERR
	trap __ctrl_c__ INT
	trap __cleanup__ EXIT

	__main_script__


fi

exit 0
