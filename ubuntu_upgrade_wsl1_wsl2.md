# Upgrade version from WSL 1 to WSL 2
[tutorial here](https://docs.microsoft.com/en-us/windows/wsl/install#upgrade-version-from-wsl-1-to-wsl-2)

New Linux installations, installed using the `wsl --install` command, will be set to WSL 2 by default.

The `wsl --set-version` command can be used to downgrade from WSL 2 to WSL 1 or to update previously installed Linux distributions from WSL 1 to WSL 2.

To see whether your Linux distribution is set to WSL 1 or WSL 2, use the command: `wsl -l -v`.

To change versions, use the command: `wsl --set-version <distro name> 2` replacing `<distro name>` with the name of the 
Linux distribution that you want to update. For example, `wsl --set-version Ubuntu-20.04 2` will set your Ubuntu 20.04 distribution to use WSL 2.

If you manually installed WSL prior to the `wsl --install` command being available, you may also need to
[enable the virtual machine optional component](https://docs.microsoft.com/en-us/windows/wsl/install-manual#step-3---enable-virtual-machine-feature) used 
by WSL 2 and [install the kernel package](https://docs.microsoft.com/en-us/windows/wsl/install-manual#step-4---download-the-linux-kernel-update-package)
if you haven't already done so.

1. Enable the virtual machine  
Before installing WSL 2, you must enable the Virtual Machine Platform optional feature. Your machine will require virtualization capabilities to use this feature.
Open PowerShell as Administrator and run:  
`dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart`  

```
PS C:\WINDOWS\system32> dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

Deployment Image Servicing and Management tool
Version: 10.0.19041.844

Image Version: 10.0.19042.1586

Enabling feature(s)
[==========================100.0%==========================]
The operation completed successfully.
PS C:\WINDOWS\system32>
```    


Restart your machine to complete the WSL install and update to WSL 2.

2. Download the Linux kernel update package  
Download the latest package:  
[WSL2 Linux kernel update package for x64 machines](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi)  
Run the update package downloaded in the previous step. (Double-click to run - you will be prompted for elevated permissions, select ‘yes’ to approve this installation.)

To learn more, see the Command reference for WSL for a list of WSL commands, Comparing WSL 1 and WSL 2 for guidance on which to use for your work scenario, 
or Best practices for setting up a WSL development environment for general guidance on setting up a good development workflow with WSL.
