@echo off
rem Wrap MSYS2 UCRT64 npm so cmd.exe can find node.exe (required for Vite web-ui build).
set "PATH=C:\msys64\ucrt64\bin;%PATH%"
"C:\msys64\ucrt64\bin\npm.cmd" %*
