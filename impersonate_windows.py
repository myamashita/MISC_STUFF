import win32security, win32con, win32api

class Impersonate:
    def __init__(self, login, password):
        self.domain = 'PETROBRAS'
        self.login = login
        self.password = password

    def logon(self):
        self.handle = win32security.LogonUser(self.login, self.domain,
            self.password, win32con.LOGON32_LOGON_INTERACTIVE,
            win32con.LOGON32_PROVIDER_DEFAULT)
        win32security.ImpersonateLoggedOnUser(self.handle)

    def logoff(self):
        win32security.RevertToSelf() # terminates impersonation
        self.handle.Close() # guarantees cleanup

if __name__=='__main__':
    # a = Impersonate('SABCSIS03', 'oceanop2')
    a = Impersonate('user', 'password')

    try:
        a.logon() # become the user
        try:
            # Do whatever you need to do, e.g.,:
            print win32api.GetUserName() # show you're someone else
        finally:
            a.logoff() # Ensure return-to-normal no matter what
    except:
        print 'Exception:', sys.exc_type, sys.exc_value