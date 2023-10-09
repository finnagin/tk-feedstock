set "PATH=C:\WINDOWS\system32;C:\WINDOWS;%~1;%~3;%~4"
set "LIBRARY_PREFIX=%~1\win-amd64"

echo %LIBRARY_PREFIX%
echo %PATH%

set MACHINE="AMD64"
set ARCH="AMD64"

echo "%~4\..\..\..\..\..\..\..\vcvarsall.bat"
set "VS170COMNTOOLS=%~5"
echo "%VS170COMNTOOLS%..\..\VC\vcvarsall.bat"

call "%VS170COMNTOOLS%..\..\VC\vcvarsall.bat" x64

if %2=="14" (
  echo "Switching SDK versions"
  call "%VS140COMNTOOLS%..\..\VC\vcvarsall.bat" x64 10.0.15063.0
)

echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Installing in %LIBRARY_PREFIX% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
pushd %~3
dir
set
nmake -f makefile.vc BUILDDIRTOP=RELEASE_win_amd64 INSTALLDIR=%LIBRARY_PREFIX% MACHINE=%MACHINE% release
:: nmake -f makefile.vc INSTALLDIR=%LIBRARY_PREFIX% MACHINE=%MACHINE% install
if %ERRORLEVEL% GTR 0 exit 1
popd
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ SUCCESS ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
