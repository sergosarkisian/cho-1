@ECHO OFF
cd c:\sfxtmp.001
SET ThisScriptsDirectory=%~dp0
SET PowerShellScriptPath=%ThisScriptsDirectory%set-ip.ps1
regedit.exe /S %ThisScriptsDirectory%EnableScripts.reg
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%PowerShellScriptPath%'";
pause