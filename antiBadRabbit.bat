@echo off
rem Bad Rabbit Ransomware vaccine as described by Cybereason here:
rem https://www.cybereason.com/blog/cybereason-researcher-discovers-vaccine-for-badrabbit-ransomware 
rem Created by Apostolos Smyrnakis - 11/2017

mode con:cols=110 lines=25
color 0b
cls
title Bad Rabbit vaccine
echo.

:init
setlocal DisableDelayedExpansion
set cmdInvoke=1
set winSysFolder=System32
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
echo.
echo **************************************
echo Invoking UAC for Privilege Escalation
echo **************************************

echo Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
echo args = "ELEV " >> "%vbsGetPrivileges%"
echo For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
echo args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
echo Next >> "%vbsGetPrivileges%"

if '%cmdInvoke%'=='1' goto InvokeCmd 

echo UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
goto ExecElevation

:InvokeCmd
echo args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
echo UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"

:ExecElevation
"%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
exit /B

:gotPrivileges
setlocal & cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

:vaccinate
echo Applying vaccine . . .
echo.

rem Create files infpub.dat & cscc.dat under C:\Windows\
type NUL > C:\Windows\cscc.dat
type NUL > C:\Windows\infpub.dat
if %ERRORLEVEL% == 1 goto error

echo.

rem Removes permissions - inheritance from created files
icacls C:\Windows\infpub.dat /inheritance:r /remove Administrators /Q
icacls C:\Windows\cscc.dat /inheritance:r /remove Administrators /Q
if %ERRORLEVEL% == 0 goto alldone
if %ERRORLEVEL% == 1 goto error

:error
echo.
echo An error occurred! Vaccine is NOT applied! 
echo Hit any key to exit ...
pause
exit

:alldone
echo.
echo All done! Hit any key to exit ...
pause
exit

ECHO %batchName% Arguments: P1=%1 P2=%2 P3=%3 P4=%4 P5=%5 P6=%6 P7=%7 P8=%8 P9=%9
cmd /k