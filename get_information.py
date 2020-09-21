import getpass
import os.path
import socket

def get_user():
    username = getpass.getuser()
    return print(username)

def get_home_dir():
    homedir = os.path.expanduser("~")
    return print(homedir)
    
def get_hostname():
    hostname = socket.gethostname()
    return print(hostname)
