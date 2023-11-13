set "PATH=C:\WINDOWS\system32;C:\WINDOWS;%~1;%~3;%~4"
set "LIBRARY_PREFIX=%~1\win-amd64"

echo %LIBRARY_PREFIX%
echo %PATH%

set MACHINE="AMD64"
set ARCH="AMD64"

set "VCINSTALLDIR=%~5"
echo "%VCINSTALLDIR%Auxiliary\Build\vcvarsall.bat"

call "%VCINSTALLDIR%Auxiliary\Build\vcvarsall.bat" x64

if %2=="14" (
  echo "Switching SDK versions"
  call "%VS140COMNTOOLS%..\..\VC\vcvarsall.bat" x64 10.0.15063.0
)

echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Installing in %LIBRARY_PREFIX% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
pushd %~3
dir
set
nmake nmakehlp.exe
nmake -f makefile.vc BUILDDIRTOP=RELEASE_win_amd64 INSTALLDIR=%LIBRARY_PREFIX% MACHINE=%MACHINE% release
:: nmake -f makefile.vc INSTALLDIR=%LIBRARY_PREFIX% MACHINE=%MACHINE% install
if %ERRORLEVEL% GTR 0 exit 1
popd
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ SUCCESS ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
