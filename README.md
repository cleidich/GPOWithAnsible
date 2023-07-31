# GPOWithAnsible

Scripts and samples for managing Windows settings with Ansible &amp; GPO.

## Repository Contents

- Set-GPOWithAnsible.ps1 - A script that leverages the PolicyFileEditor Powershell Module to update local Group Policy settings. Designed to be triggered in an Ansible play via the win_powershell module.
- samples - Sample playbook showing a use case for the Set-GPOWithAnsible.ps1 script.

## Important Note

While using this script is generally no more or less safe than manually editing the Registry or clicking around in the Group Policy editor, there are some unique conditions that can arise from using Registry.pol to control certain Windows settings.

Make sure that you read the information on SecPol settings [here](https://gist.github.com/cleidich/ab47f80f6fd4b25dbc582f2791d8e205) before you deploy Windows Account Policies or Local Policies settings.

## Prerequisites

The PowerShell script requires the [PolicyFileEditor module](https://github.com/dlwyatt/PolicyFileEditor/). You can place this into the Program Files\WindowsPowershell\Modules\PolicyFileEditor folder, or store it elsewhere and modify the code to Import-Module from a location of your choosing.

## Warranty

No warranty express or implied. You are responsible for any breakage as a result of using any of the scripts or information within this repository.

## License.

See LICENSE file.
