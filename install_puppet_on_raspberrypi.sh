#!/bin/bash
# Aurthor : Edouard Fazenda <edouard.fazenda@gmail.com>
# Date : 07 July 2014
# Install puppet puppetmaster facter and all dependencies on raspberry pi
# Source : http://stdout.no/puppet-on-raspberry-pi/
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

# Getting the public GPG key of Puppetlabs manually 
apt-key adv --keyserver pool.sks-keyservers.net --recv-keys 4BD6EC30

# Creating an puppetlabs.list in our /etc/apt/sources.list.d/
# (Only the sources)
cat > /etc/apt/sources.list.d/puppetlabs.list << EOF
deb-src http://apt.puppetlabs.com wheezy main
deb-src http://apt.puppetlabs.com wheezy dependencies
EOF

# Reload the apt cache
apt-get update

# Creating temporaty directoy for building
mkdir temp && cd temp

# Download build dependencies and build facter, hiera and ruby-rgen
for pkg in facter hiera ruby-rgen
do
	apt-get -y build-dep $pkg
	apt-get -b source $pkg
done

# Install dependencies and the packages we just built (Puppet will not build unless a recent version of facter is installed)
apt-get install -y virt-what ruby-json
dpkg -i facter_*.deb hiera_*.deb ruby-rgen_*.deb


# Building now the puppet packages
apt-get -y build-dep puppet
apt-get -b source puppet

# Install dependencies and puppet
apt-get install augeas-lenses libaugeas0 libaugeas-ruby1.8 ruby-shadow libshadow-ruby1.8
dpkg -i puppet-common_*.deb puppet_*.deb
dpkg -i puppetmaster-common_*.deb puppetmaster_*.deb

# Copying the *.deb packages and cleaning a bit
mkdir ../puppetpackages
cp *.deb ../puppetpackages
cd .. && rm -rf temp


