@echo off

set dftDir=%~dp0
set newDir=%~dp0\..\
call :resolve "%newDir%"

set VBS=%dftDir%shortcuts.vbs

rem ********************
rem Python3.6.7 Shortcut
rem ********************

set SRC_LNK="%USERPROFILE%\Desktop\Python3.6.7.lnk"
set ARG1_APPLCT="%_return%python.exe"
set ARG2_APPARG=""
set ARG3_WRKDRC="%_return%"
set ARG4_ICOLCT="%_return%DLLs\python.ico, 0"
set ARG5_DESCRT=""

echo [Criando atalho %SRC_LNK%...]
if exist %SRC_LNK% (
del /s /q /f %SRC_LNK%
)
cscript %VBS% %SRC_LNK% %ARG1_APPLCT% %ARG2_APPARG% %ARG3_WRKDRC% %ARG4_ICOLCT% %ARG5_DESCRT%

rem *********************
rem IPython7.4.0 Shortcut
rem *********************

set SRC_LNK="%USERPROFILE%\Desktop\IPython7.4.0.lnk"
set ARG1_APPLCT="%_return%python.exe"
set ARG2_APPARG="%_return%Scripts\ipython-script.py"
set ARG3_WRKDRC="%_return%Scripts"
set ARG4_ICOLCT="%_return%DLLs\ipython1.ico, 0"
set ARG5_DESCRT=""

echo [Criando atalho %SRC_LNK%...]
if exist %SRC_LNK% (
del /s /q /f %SRC_LNK%
)
cscript %VBS% %SRC_LNK% %ARG1_APPLCT% %ARG2_APPARG% %ARG3_WRKDRC% %ARG4_ICOLCT% %ARG5_DESCRT%
 
rem ******************************
rem IPython7.4.0 (+pylab) Shortcut
rem ******************************

set SRC_LNK="%USERPROFILE%\Desktop\IPython7.4.0 (pylab).lnk"
set ARG1_APPLCT="%_return%python.exe"
set ARG2_APPARG="%_return%Scripts\ipython-script.py --pylab"
set ARG3_WRKDRC="%_return%Scripts"
set ARG4_ICOLCT="%_return%DLLs\ipython2.ico, 0"
set ARG5_DESCRT=""

echo [Criando atalho %SRC_LNK%...]
if exist %SRC_LNK% (
del /s /q /f %SRC_LNK%
)
cscript %VBS% %SRC_LNK% %ARG1_APPLCT% %ARG2_APPARG% %ARG3_WRKDRC% %ARG4_ICOLCT% %ARG5_DESCRT%

rem *******************************
rem Python3.6.7 GUI (IDLE) Shortcut
rem *******************************

rem set SRC_LNK="%USERPROFILE%\Desktop\Python3.6.7 GUI (IDLE).lnk"
rem set ARG1_APPLCT="%_return%pythonw.exe"
rem set ARG2_APPARG="%_return%Scripts\idle-script.py"
rem set ARG3_WRKDRC="%_return%Scripts"
rem set ARG4_ICOLCT="%_return%Lib\idlelib\Icons\idle.ico, 0"
rem set ARG5_DESCRT=""
rem 
rem echo [Criando atalho %SRC_LNK%...]
rem if exist %SRC_LNK% (
rem del /s /q /f %SRC_LNK%
rem )
rem cscript %VBS% %SRC_LNK% %ARG1_APPLCT% %ARG2_APPARG% %ARG3_WRKDRC% %ARG4_ICOLCT% %ARG5_DESCRT%

rem ****************
rem Spyder3 Shortcut
rem ****************

set SRC_LNK="%USERPROFILE%\Desktop\Spyder3.lnk"
set ARG1_APPLCT="%_return%python.exe"
set ARG2_APPARG="%_return%Scripts\spyder-script.py"
set ARG3_WRKDRC="%HOMEDRIVE%%HOMEPATH%"
set ARG4_ICOLCT="%_return%Scripts\spyder.ico, 0"
set ARG5_DESCRT=""

echo [Criando atalho %SRC_LNK%...]
if exist %SRC_LNK% (
del /s /q /f %SRC_LNK%
)
cscript %VBS% %SRC_LNK% %ARG1_APPLCT% %ARG2_APPARG% %ARG3_WRKDRC% %ARG4_ICOLCT% %ARG5_DESCRT%

rem pause
goto :EOF

:resolve
set _return=%~f1
goto :EOF
