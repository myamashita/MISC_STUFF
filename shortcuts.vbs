Set objWSHShell = WScript.CreateObject("WScript.Shell")

sShortcut = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(0))
sTargetPath = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(1))
sArguments = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(2))
sWorkingDirectory = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(3))
sIconLocation = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(4))
sDescription = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(5))

set objSC = objWSHShell.CreateShortcut(sShortcut) 
objSC.TargetPath = sTargetPath
rem objSC.Arguments = Replace(sArguments, "QuteQ", Chr(34))
objSC.Arguments = sArguments
objSC.WorkingDirectory = sWorkingDirectory
objSC.IconLocation = sIconLocation
objSC.Description = sDescription
objSC.WindowStyle = "1"
rem objSC.Hotkey = "Nenhum"

objSC.Save
WScript.Quit