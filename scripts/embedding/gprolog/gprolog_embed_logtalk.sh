#!/usr/bin/env bash

#############################################################################
## 
##   This script creates a new GNU Prolog top-level
##   interpreter that embeds Logtalk
## 
##   Last updated on April 3, 2018
## 
##   This file is part of Logtalk <https://logtalk.org/>  
##   Copyright 1998-2018 Paulo Moura <pmoura@logtalk.org>
##   
##   Licensed under the Apache License, Version 2.0 (the "License");
##   you may not use this file except in compliance with the License.
##   You may obtain a copy of the License at
##   
##       http://www.apache.org/licenses/LICENSE-2.0
##   
##   Unless required by applicable law or agreed to in writing, software
##   distributed under the License is distributed on an "AS IS" BASIS,
##   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##   See the License for the specific language governing permissions and
##   limitations under the License.
## 
#############################################################################


directory="$HOME/collect"

if ! [ "$LOGTALKHOME" ]; then
	echo "The environment variable LOGTALKHOME should be defined first, pointing"
	echo "to your Logtalk installation directory!"
	echo "Trying the default locations for the Logtalk installation..."
	if [ -d "/usr/local/share/logtalk" ]; then
		LOGTALKHOME=/usr/local/share/logtalk
		echo "... using Logtalk installation found at /usr/local/share/logtalk"
	elif [ -d "/usr/share/logtalk" ]; then
		LOGTALKHOME=/usr/share/logtalk
		echo "... using Logtalk installation found at /usr/share/logtalk"
	elif [ -d "/opt/local/share/logtalk" ]; then
		LOGTALKHOME=/opt/local/share/logtalk
		echo "... using Logtalk installation found at /opt/local/share/logtalk"
	elif [ -d "/opt/share/logtalk" ]; then
		LOGTALKHOME=/opt/share/logtalk
		echo "... using Logtalk installation found at /opt/share/logtalk"
	elif [ -d "$HOME/share/logtalk" ]; then
		LOGTALKHOME="$HOME/share/logtalk"
		echo "... using Logtalk installation found at $HOME/share/logtalk"
	elif [ -f "$( cd "$( dirname "$0" )" && pwd )/../core/core.pl" ]; then
		LOGTALKHOME="$( cd "$( dirname "$0" )" && pwd )/.."
		echo "... using Logtalk installation found at $( cd "$( dirname "$0" )" && pwd )/.."
	else
		echo "... unable to locate Logtalk installation directory!"
		echo
		exit 1
	fi
	echo
	export LOGTALKHOME=$LOGTALKHOME
elif ! [ -d "$LOGTALKHOME" ]; then
	echo "The environment variable LOGTALKHOME points to a non-existing directory!"
	echo "Its current value is: $LOGTALKHOME"
	echo "The variable must be set to your Logtalk installation directory!"
	echo
	exit 1
fi

print_version() {
	echo "$(basename "$0") 0.3"
	exit 0
}

usage_help()
{
	echo 
	echo "This script creates a new GNU Prolog top-level interpreter that embeds the"
	echo "Logtalk compiler and runtime and an optional application from an application"
	echo "source code given its loader file."
	echo
	echo "Usage:"
	echo "  $(basename "$0") [-d directory]"
	echo "  $(basename "$0") [-l loader]"
	echo "  $(basename "$0") [-s settings]"
	echo "  $(basename "$0") -v"
	echo "  $(basename "$0") -h"
	echo
	echo "Optional arguments:"
	echo "  -v print version of $(basename "$0")"
	echo "  -d directory to use for intermediate and final results (default is $HOME/collect)"
	echo "  -l optional loader file for the application"
	echo "  -s optional settings file for the application"
	echo "  -h help"
	echo
	exit 0
}

while getopts "vd:l:s:h" option
do
	case $option in
		v) print_version;;
		d) d_arg="$OPTARG";;
		l) l_arg="$OPTARG";;
		s) s_arg="$OPTARG";;
		h) usage_help;;
		*) usage_help;;
	esac
done

if [ "$d_arg" != "" ] ; then
	directory="$d_arg"
fi

if [ "$l_arg" != "" ] ; then
	if [ -f "$l_arg" ] ; then
		loader="$l_arg"
	else
		echo "The $l_arg loader file does not exist!"
		exit 1
	fi
else
	loader=""
fi

if [ "$s_arg" != "" ] ; then
	if [ -f "$s_arg" ] ; then
		settings="$s_arg"
	else
		echo "The $s_arg settings file does not exist!"
		exit 1
	fi
else
	settings=""
fi

mkdir -p "$directory"
cd "$directory"

operating_system=$(uname -s)

if [ "${operating_system:0:10}" == "MINGW32_NT" ] || [ "${operating_system:0:10}" == "MINGW64_NT" ] ; then
	# assume that we're running on Windows using the Git for Windows bash shell
	extension='.sh'
elif [ "$LOGTALKHOME" != "" ] && [ "$LOGTALKUSER" != "" ] && [ "$LOGTALKHOME" == "$LOGTALKUSER" ] ; then
	# assume that we're running Logtalk without using the installer scripts
	extension='.sh'
else
	extension=''
fi

gplgt$extension --query-goal "logtalk_compile([core(expanding),core(monitoring),core(forwarding),core(user),core(logtalk),core(core_messages)],[optimize(on),scratch_directory('$directory')]),halt"

cp "$LOGTALKHOME/adapters/gnu.pl" .
cp "$LOGTALKHOME/paths/paths_core.pl" .
cp "$LOGTALKHOME/core/core.pl" .

if [ "$settings" != "" ] ; then
	gplgt$extension --query-goal "logtalk_compile('$settings',[optimize(on),scratch_directory('$directory')]),halt"
else
	touch settings_lgt.pl
fi

if [ "$loader" != "" ] ; then
	mkdir -p "$directory/application"
	cd "$directory/application"
	gplgt$extension --query-goal "set_logtalk_flag(source_data, off),set_logtalk_flag(optimize, on),set_logtalk_flag(clean, off),set_logtalk_flag(context_switching_calls, deny),set_logtalk_flag(scratch_directory, '$directory/application'),logtalk_load('$loader', [clean(on)]),halt"
	rm -f $directory/application/*loader*
	cd ..
else
	touch application.pl
fi

gplc -o logtalk gnu.pl expanding*_lgt.pl monitoring*_lgt.pl forwarding*_lgt.pl user*_lgt.pl logtalk*_lgt.pl core_messages*_lgt.pl settings*_lgt.pl core.pl paths_core.pl $(ls application/*.pl)

rm *.pl
rm application/*.pl
