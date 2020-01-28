# SSH on Windows Subsystem for Linux

## 1. Install SSH:
To get the ssh server working properly, you must uninstall and then reinstall it using the following command:  
>sudo apt remove openssh-server  
>sudo apt install openssh-server  
## 2. Edit sshd_config:  
Edit **sshd_config** file by running the command:
> sudo nano /etc/ssh/sshd_config  
  
In the **sshd_config** file:
* Change **PasswordAuthentication** to **yes**
* Add your login user to the bottom of the file by using this command: **AllowUsers yourname**  
Save and exit.
## 3. Start or restart the SSH service:
Check the status of the ssh service:
>service ssh status  

If you see:  **sshd is not running**
Then run this command:
>sudo service ssh start  

If you see: **sshd is running**
Then run this command:
>sudo service ssh --full-restart

## 4. Allow SSH service to start without password:  
run the command
>sudo visudo  

add the following line
>%sudo ALL=NOPASSWD: /usr/sbin/sshd  
>%sudo ALL=NOPASSWD: /etc/init.d/ssh  

after  
>%sudo  ALL=(ALL:ALL) ALL  

You can test that you don’t need a sudo password when you start ssh by running
>sudo service ssh --full-restart  

(if ssh is already running) or
>sudo service ssh start  

if ssh is not running)

## 5. Add a Windows Task Scheduler to automatically start ssh server:
* Open Windows Task Scheduler;  
* Create a Basic Task;  
**Name:** Start Bash SSH Server  
**Description:** Start the WSL SSh Serer via a bash command  

* Under Trigger  

**select When the Computer Starts**  

* Under Action  
**Select Start a Program**  

* Under Program/script:

> %windir%\System32\bash.exe  

* Under Add arguments (optional):  

>-c "sudo /etc/init.d/ssh start"  

* Check Security options in Genereal tab  
**Run whether user is logged on or not**

## 6.Conclusion  
**You should now have SSH enabled as a service that automatically starts on boot on your Windows Subsystem for Linux (WSL)**

[Illuminia Studios](https://www.illuminiastudios.com/dev-diaries/ssh-on-windows-subsystem-for-linux/)
