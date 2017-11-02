@echo off
rem Bad Rabbit Ransomware vaccine as described by Cybereason here:
rem https://www.cybereason.com/blog/cybereason-researcher-discovers-vaccine-for-badrabbit-ransomware 

mode con:cols=110 lines=25
color 0b
title Bad Rabbit vaccine
echo.

:start
rem echo Did you run the script as Administrator? (y/n)
set /p answer="Did you run the script as Administrator? (y/n) "
if "%answer%"=="n" goto exiting
if "%answer%"=="N" goto exiting
if "%answer%"=="y" goto vaccinate
if "%answer%"=="Y" goto vaccinate
echo Invalid selection: %answer%
echo.
goto start

:exiting
echo.
echo.
echo Please run the script again as Administrator. 
echo Right-click the script icon and select "Run as Administrator"
echo.
timeout 6
exit

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