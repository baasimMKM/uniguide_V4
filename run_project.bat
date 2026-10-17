@echo off
powershell.exe -NoProfile -File "%~dp0run_project.ps1"
exit /b %errorlevel%
