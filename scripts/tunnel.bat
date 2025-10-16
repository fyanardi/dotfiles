@echo off

REM ===============================================
REM SSH Tunnel Script via Jump Server (lab)
REM Usage: tunnel <port>
REM Example: tunnel 8080
REM
REM NOTE:
REM This script assumes you have SSH access configured
REM in your ~/.ssh/config file, e.g.:
REM
REM   Host lab
REM     HostName lab.tenteram.io
REM     User fyanardi
REM
REM   Host internal
REM     HostName internal
REM     User fyanardi
REM     ProxyJump lab
REM ===============================================

if "%~1"=="" (
    echo Usage: %~n0 ^<port^>
    exit /b 1
)
set PORT=%~1

echo Starting SSH tunnel to internal:%PORT% ...
ssh -N -L %PORT%:localhost:%PORT% internal
