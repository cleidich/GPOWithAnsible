<#
.SYNOPSIS
    Sets a local Group Policy setting via script parameters from an Ansible play.
    Requires the PolicyFileEditor module: https://github.com/dlwyatt/PolicyFileEditor

.PARAMETER PolLocation
    The path to the .pol file to be updated by the Policy File Editor module. 
    This is typically the local Group Policy machine or user .pol files, located in C:\Windows\System32\GroupPolicy.

.PARAMETER RegistryPath
   The registry key containing the registry value of the policy setting that is to be updated. This will typically be a subkey of HKLM\Software\Policies or HKCU\Software\Policies for computer or user policy settings, respectively.
   
.PARAMETER RegistryValue
    The name of the registry value of the policy setting that is to be updated with the data from the RegistryData & RegistryType parameters.

.PARAMETER RegistryData
    The data value that should be set for the registry value.

.PARAMETER RegistryType
    The type of registry value being updated. Values from the RegistryValueKind enum are legal, but blank or unknown values are not permitted.

.INPUTS
    All parameters should be specified as strings in the script execution command. 
    Pipeline input is not currently supported.
    PolLocation is not required, and will default to the Machine Registry.pol file location unless otherwise specified.

.OUTPUTS
    None. This script does not generate outputs.
#>

#Requires -Version 3
#Requires -Modules PolicyFileEditor

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory=$false)]
    [String]$PolLocation = "C:\Windows\System32\GroupPolicy\Machine\Registry.pol",
    [Parameter(Mandatory=$true)]
    [String]$RegistryPath,
    [Parameter(Mandatory=$true)]
    [String]$RegistryValue,
    [Parameter(Mandatory=$true)]
    [String]$RegistryData,
    [Parameter(Mandatory=$true)]
    [ValidateSet("Dword", "String", "ExpandString","MultiString","Binary","Qword")]
    [String]$RegistryType
)

$params = @{
    Path = $PolLocation
    Key = $RegistryPath
    ValueName = $RegistryValue
    Data = $RegistryData
    Type = $RegistryType
}

# Check to see if we need to make a change.
# Get the current policy file value data.
$CurrentData = Get-PolicyFileEntry -Path $PolLocation -Key $RegistryPath -ValueName $RegistryValue

# Check to see if the current policy file value data
# If it does, we do not need to change, and can signal that back to Ansible
if ($CurrentData.Data -eq $params.Data) {
    $Ansible.Changed = $false
}

# If the current value does not match the desired value, proceed with making
# a change.

else {
    # If we are in Check mode, use the -WhatIf flag to estimate output.
    if ($Ansible.CheckMode) {
        Set-PolicyFileEntry @params -WhatIf
    }

    # If we are not in Check mode, try to apply the change
    else {
        try {
            Set-PolicyFileEntry @params
        }
        catch {
            # For any error encountered, signal to Ansible that a failure occurred
            # and that a change has not occurred.
            $Ansible.Failed = $true
            $Ansible.Changed = $false
        }
    }
}