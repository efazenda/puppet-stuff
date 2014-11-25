##################################################################################
# Description : Custom Fact that retrieve the local users that have a shell
# Author : Edouard Fazenda <edouard.fazenda@gmail.com>
# Date : 25/11/2014
##################################################################################

# Include the needed module
#require 'facter'

# Executing the command `cat /etc/passwd` and storing the output
outputUsers = %x{cat /etc/passwd 2>&1}

# Check the return code 
if $?.exitstatus
    listUsers = outputUsers.split(/\n/)

    # Initialize the users array
    users = []

    # Browse each elements of the output array
    listUsers.each { 

        # Check if it match the regex 
        | user | if user.match(/(\w+):.*:\d+:\d+:(.*):.*:(.+)$/)
            
            # If not a fake shell add to the list
            if $3 != "/sbin/nologin" and $3 != "/sbin/shutdown" and $3 != "/sbin/halt" and $3 != "/bin/sync" 
                users.push($1.to_s)
            end
         end
    }

    # Add the list of users to the fact users
    Facter.add('users') do
        confine :kernel => 'linux'  
        setcode do
            users.join(",")
        end
    end
else
    users = "error"
    puts("users=" + users)
end
