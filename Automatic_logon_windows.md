# How to turn on automatic logon in Windows

This article describes how to configure Windows to automate the logon process by storing your  
password and other pertinent information in the registry database. By using this feature, other  
users can start your computer and use the account that you establish to automatically log on.

To turn on automatic logon and follow these steps: 

 - Execute **Registry Editor**  
   >>
   Locate the following subkey in the registry:
   > HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon 

 - Set **DefaultUserName** entry:  
   >>
   type your user account   

 - Set **DefaultPassword** entry:  
   >>
   type your password
   -  Note If the **DefaultPassword** value does not exists, it must be added. To add the value, follow these steps:  
     >>
     1. On the Edit menu, click New, and then point to String Value.
     2. Type DefaultPassword, and then press Enter.
     3. Double-click DefaultPassword.
     4. In the Edit String dialog, type your password and then click OK.
 - Create a **AutoAdminLogon** entry:
   >>
   set String Value to **1**

 - Restart your computer. You can  now log on automatically
