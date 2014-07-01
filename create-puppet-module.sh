#!/bin/bash
# Aurthor : Edouard Fazenda <edouard.fazenda@gmail.com>
# Date : 30 June 2014
# Create structural tree for a puppet module

# The MIT License (MIT)
#
# Copyright (c) <year> <copyright holders>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


# Function Usage
function usage ()
{
cat << EOF
usage $0 [-t] TYPE modulename

Create a puppet module structured as puppet (Open Source / Entreprise) requirements

	-t TYPE (opensource|entreprise)
EOF
}


# Checking if no parameters are passed to the program , if no it print the usage
if [ $# == 0 ] ; then
	usage
	exit 1
fi

function createModule() {
	mkdir -p $1/$2/{manifests,files,templates,lib,tests,spec,facts.d}
	if [ $? -eq 0 ]; then
		echo -e "[INFO] Structural directories created"
	else
		echo -e "[ERROR] Creation of the structural directories has failed !"
		exit 2
	fi
}


# Function that create the LISENCE file
function createLicense(){
	wget -q -O - https://www.gnu.org/licenses/gpl.txt > $1/$2/LICENSE.txt
}


# Function that initialize the module with the needed files
function initializeModule() {
 
	echo -e "class $2 { \n }" > $1/$2/manifests/init.pp	
	touch $1/$2/tests/init.pp
	touch $1/$2/README
}


while getopts "t:" opt; do
	case $opt in
		t)
			PUPPET_TYPE=$OPTARG
			if [ "$PUPPET_TYPE" == "opensource" ] ; then
				MODULE_PATH="/etc/puppet/modules/"
				if [ -d "$MODULE_PATH/$3" ] ; then 
					echo -e "[ERROR] Module already exist" && exit 6 
				fi
				createModule $MODULE_PATH $3
				createLicense $MODULE_PATH $3
				initializeModule $MODULE_PATH $3
				tree $MODULE_PATH/$3
				echo -e "[INFO] Module $3 created."
			elif [ "$PUPPET_TYPE" == "entreprise" ] ; then
				MODULE_PATH="/etc/puppetlabs/puppet/modules/"
				if [ -d "$MODULE_PATH/$3" ] ; then 
					echo -e "[ERROR] Module already exist" && exit 6 
				fi
                                createModule $MODULE_PATH $3
                                createLicense $MODULE_PATH $3
                                initializeModule $MODULE_PATH $3
				tree $MODULE_PATH/$3
				echo -e "[INFO] Module $3 created."
			else
				echo -e "[ERROR] This puppet type does not exist ... exit now !"
				exit 3
			fi
		;;
		h)
			usage $OPTARG
		;;
		/?)
			echo -e "[ERROR] Invalid option: -$OPTARG" >2&
			usage
			exit 4
		;;
		::)
			echo -e "[ERROR] Option -$OPTARG requires an argument." >2&
			exit 5
		;;
	esac
done	
