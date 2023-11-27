## SSH KEYGEN
1. Generate a new key pair in a terminal with the next command:  
>ssh-keygen -t rsa
2. Copy the public half of the key pair to your cloud server using the following command:  
Replace the user and server with your username and the server address you wish to use the key authentication on.

>ssh-copy-id -i ~/.ssh/id_rsa.pub user@server
