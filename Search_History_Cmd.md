Using **~/.bashrc**  
Edit ~/.bashrc with this command:

`nano ~/.bashrc`
Add the following lines:  

`bind '"\e[A": history-search-backward'`  
`bind '"\e[B": history-search-forward'`  
Save then close the file.
Execute this command in a terminal:

`source ~/.bashrc`  
