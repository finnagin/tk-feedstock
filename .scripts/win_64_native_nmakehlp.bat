set "PATH=C:\WINDOWS\system32;C:\WINDOWS;%~1;%~2;%~3"

set MACHINE="AMD64"
set ARCH="AMD64"

set "VCINSTALLDIR=%~4"

call "%VCINSTALLDIR%Auxiliary\Build\vcvarsall.bat" x64

pushd %~2
nmake nmakehlp.exe
if %ERRORLEVEL% GTR 0 exit 1
popd