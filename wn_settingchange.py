import win32gui
import win32con

# notify the system about the changes
win32gui.SendMessage(win32con.HWND_BROADCAST, win32con.WM_SETTINGCHANGE, 0, 'Environment')