##################################################################################
# Description : Custom Fact that that return true or false if the kernel is compiled with a set of parameters that allow crash-dumping
# Author : Edouard Fazenda <edouard.fazenda@gmail.com>
# Date : 25/11/2014
##################################################################################

# Include needed module
require 'facter'
require 'rubygems'

# Function that get the crashdump capability by returning true or false
def get_crashdump_capability()
    begin
        
        # Initialize the variables
        config_kexec = false
        config_crash_dump = false
        config_proc_vmcore = false
        config_debug_info = false

        kernelrelease = Facter.value(:kernelrelease)
        configfile = "/boot/config-" + kernelrelease.to_s 
        
        # Check of the directives in the kernel config file
        if File.readlines(configfile).grep(/CONFIG_KEXEC=y/)[0] != nil
            config_kexec = true
        end

        if File.readlines(configfile).grep(/CONFIG_CRASH_DUMP=y/)[0] != nil
            config_crash_dump = true
        end

        if File.readlines(configfile).grep(/CONFIG_PROC_VMCORE=y/)[0] != nil
            config_proc_vmcore = true
        end

        if File.readlines(configfile).grep(/CONFIG_DEBUG_INFO=y/)[0] != nil
            config_debug_info = true
        end

        if (config_kexec == true and config_crash_dump == true and config_proc_vmcore == true and config_debug_info == true)
            return true
        else
            return false
        end  

    # In case of faillure it exit with a debug message    
    rescue
        Facter.debug('Imposible to find the kernel configuration.')
        return false
    end
end

# Give the value to the fact is_crashdump
Facter.add("is_crashdump") do
    confine :kernel => "Linux"
    setcode do
        value = get_crashdump_capability    
    end
end 
