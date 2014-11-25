##################################################################################
# Description : Custom Fact that retrieve the runlevel that the machine is running
# Author : Edouard Fazenda <edouard.fazenda@gmail.com>
# Date : 25/11/2014
##################################################################################

# Include the needed module
require 'facter'

# Executing the command runlevel and storing the output
outputRunlevel = %x{runlevel 2>&1}

# Checking if the return code of the command and matching with a regex the value of the runlevel
if $?.exitstatus and outputRunlevel.match(/^[A-Za-z]\s(\d)$/)

        # Adding the value to the fact
        Facter.add('runlevel') do
                confine :kernel => 'linux'
                setcode do
                        $1
                end
        end
else
        runlevel = "error"
        puts("runlevel=" + runlevel)
end
