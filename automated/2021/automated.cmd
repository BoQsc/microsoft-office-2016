@ECHO OFF
NET SESSION >NUL 
IF %ERRORLEVEL% NEQ 0 GOTO ELEVATE
GOTO ADMINTASKS

:ELEVATE
MSHTA "javascript: var shell = new ActiveXObject('shell.application'); shell.ShellExecute('%~nx0', '', '', 'runas', 1);close();"
EXIT

:ADMINTASKS
CD "%~dp0"
ECHO %cd%
IF EXIST "C:\Windows\System32\curl.exe" (
	curl -L -O https://github.com/BoQsc/microsoft-office-2016/raw/BoQsc-patch-1/O2016RTool.zip
) ELSE (
	IF EXIST "C:\Windows\System32\bitsadmin.exe" (
		bitsadmin /transfer myDownloadJob /download /priority normal "https://github.com/BoQsc/microsoft-office-2016/raw/BoQsc-patch-1/O2016RTool.zip" "%CD%O2016RTool.zip"
	) ELSE (

		CD "%USERPROFILE%\Downloads"
		powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%CD%\0O2016RTool.zip'"
		IF EXIST "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" START /MIN /WAIT "" "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"  --incognito https://github.com/BoQsc/microsoft-office-2016/raw/BoQsc-patch-1/O2016RTool.zip"
		IF EXIST "%ProgramFiles%\Google\Chrome\Application\chrome.exe" START /MIN /WAIT "" "%ProgramFiles%\Google\Chrome\Application\chrome.exe"  --incognito https://github.com/BoQsc/microsoft-office-2016/raw/BoQsc-patch-1/O2016RTool.zip"
		
		
	)
)
MKDIR ".\0O2016RTool"
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%CD%\0O2016RTool'"
tar -xf ".\O2016RTool.zip" --directory ".\0O2016RTool"
@ECHO ON
START /WAIT "" ".\0O2016RTool\O2016RTool.cmd" | BREAK 

RD /S /Q ".\0O2016RTool"
DEL ".\O2016RTool.zip"
powershell -inputformat none -outputformat none -NonInteractive -Command "Remove-MpPreference -ExclusionPath '%CD%\0O2016RTool'"
powershell -inputformat none -outputformat none -NonInteractive -Command "Remove-MpPreference -ExclusionPath '%CD%\0O2016RTool.zip'"

REM DEL test.cmd