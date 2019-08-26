from win32security import LogonUser, LOGON32_LOGON_INTERACTIVE, LOGON32_PROVIDER_DEFAULT
import getpass

def check_credentials(username):
    domain = 'PETROBRAS'
    password = getpass.getpass("Password: ")
    sys.__stdin__ = sys.stdin
    try:
        hUser = LogonUser(username, domain, password,
                          LOGON32_LOGON_INTERACTIVE,
                          LOGON32_PROVIDER_DEFAULT) 
    except Exception:
        print "Failed"
    else:
        print "Succeeded"
        return hUser