# Tutorial to install ubuntu in windows 10

The full version of the Windows Subsystem for Linux is only available for the Fall Creators Update (1709, build 16215 and later). With that version of Windows you can actually install the Windows Subsystem for Linux from the Windows Store. You just need to do some preparation in PowerShell.

### Step 1 - Turn on the subsystem in PowerShell
1. Open PowerShell as Administrator and run:
>Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

2. Press Y, then Enter to restart your computer when prompted. Your PC will restart instantly, so be sure to save any work beforehand.
### Step 2 - Download distro
1. Open PowerShell and run:
>Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile Ubuntu.appx -UseBasicParsing
2. Then run:
>Add-AppxPackage .\Ubuntu.appx

### Step 3 - Launch a distro
 1. Launching the distro from the Start menu
 2. Once installation is complete, you will be prompted to create a new user account (and its password).
 3. You're done! Enjoy using your new Linux distro
