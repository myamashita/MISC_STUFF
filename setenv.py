import os
import sys
from pathlib import Path
import win32con
from win32gui import SendMessage
from winreg import (
    CloseKey, OpenKey, QueryValueEx, SetValueEx,
    HKEY_CURRENT_USER, HKEY_LOCAL_MACHINE,
    KEY_ALL_ACCESS, KEY_READ, REG_EXPAND_SZ
)


def env_keys(user=True):
    if user:
        root = HKEY_CURRENT_USER
        subkey = 'Environment'
    return root, subkey


def get_env(name, user=True):
    root, subkey = env_keys(user)
    key = OpenKey(root, subkey, 0, KEY_READ)
    try:
        value, _ = QueryValueEx(key, name)
    except WindowsError:
        return ''
    return value


def set_env(name, value):
    key = OpenKey(HKEY_CURRENT_USER, 'Environment', 0, KEY_ALL_ACCESS)
    SetValueEx(key, name, 0, REG_EXPAND_SZ, value)
    CloseKey(key)
    SendMessage(
        win32con.HWND_BROADCAST, win32con.WM_SETTINGCHANGE, 0, 'Environment')


def remove(paths, value):
    while value in paths:
        paths.remove(value)


def unique(paths):
    unique = []
    for value in paths:
        if value not in unique:
            unique.append(value)
    return unique


def prepend_env(name, values):
    paths = get_env(name).split(';')
    remove(paths, '')
    paths = unique(paths)
    paths = [item for item in paths if 'python_dist' not in item]
    for value in values[::-1]:
        paths.insert(0, value)
    set_env(name, ';'.join(paths))


if __name__ == "__main__":
    dist = os.path.basename(Path(__file__).parent.parent)
    python_dist = f'%USERPROFILE%\\Fugro\\{dist}'
    prepend_env('Path', [
        f'{python_dist}',
        f'{python_dist}\\condabin',
        f'{python_dist}\\Lib',
        f'{python_dist}\\Lib\\site-packages',
        f'{python_dist}\\Lib\\site-packages\\pywin32_system32',
        f'{python_dist}\\Library\\bin',
        f'{python_dist}\\Library\\mingw-w64\\bin',
        f'{python_dist}\\Scripts',
    ])
    set_env('PROJ_LIB', f'{python_dist}\\Library\\share\\proj')
    set_env('UDUNITS2_XML_PATH', 
            f'{python_dist}\\Library\\share\\udunits\\udunits2.xml')

