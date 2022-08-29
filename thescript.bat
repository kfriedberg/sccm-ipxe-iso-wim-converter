set pathtodism=

::Relaunch with admin permissions if not already there
setlocal enabledelayedexpansion

set CmdDir=%~dp0
set CmdDir=%CmdDir:~0,-1%

:: Check for Mandatory Label\High Mandatory Level
whoami /groups | find "S-1-16-12288" > nul
if "%errorlevel%"=="0" (
    echo Running as elevated user.  Continuing script.
) else (
    echo Not running as elevated user.
    echo Relaunching Elevated: "%~dpnx0" %*

    if exist "%CmdDir%\elevate.cmd" (
        set ELEVATE_COMMAND="%CmdDir%\elevate.cmd"
    ) else (
        set ELEVATE_COMMAND=elevate.cmd
    )

    set CARET=^^
    !ELEVATE_COMMAND! cmd /c cd /d "%~dp0" !CARET!^& call "%~dpnx0" %*
    goto :EOF
) 
::end of relaunch with admin permissions block

set PATH=%pathtodism%;%PATH%

for /f "tokens=* USEBACKQ" %%g in (`powershell -Command "(Mount-DiskImage -ImagePath '%1').DevicePath"`) do (set "isomount=%%g")
mkdir sccmfiles
copy /y "%isomount%\sources\boot.wim" sccmfiles\boot.wim
mkdir mntpnt
dism /mount-wim "/wimfile:sccmfiles\boot.wim" /index:1 /mountdir:mntpnt
mkdir mntpnt\sms\data
copy /y "%isomount%\sms\data\*" mntpnt\sms\data\
powershell -Command "Dismount-DiskImage -ImagePath '%1'"
rem Uncomment the next line to force the .wim to be unattended (usually needed because of missing option in SCCM 2007)
rem powershell -Command "(gc mntpnt\sms\data\TsmBootstrap.ini) -replace 'Unattended=false', 'Unattended=true' | Out-File mntpnt\sms\data\TsmBootstrap.ini"
copy /y changeStartOptions.vbs mntpnt\Windows\System32\
copy /y winpeshl.ini mntpnt\Windows\System32\
dism /unmount-wim /mountdir:mntpnt /commit
move sccmfiles\boot.wim "%~dpn1.wim"
rd /s /q mntpnt
rd /s /q sccmfiles
