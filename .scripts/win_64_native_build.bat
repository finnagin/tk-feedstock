set "PATH=C:\WINDOWS\system32;C:\WINDOWS;%~1"
set "LIBRARY_PREFIX=%~1\win-amd64"

set MACHINE="AMD64"
set ARCH="AMD64"

if %2=="14" (
  echo "Switching SDK versions"
  call "%VS140COMNTOOLS%..\..\VC\vcvarsall.bat" x64 10.0.15063.0
)

echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Installing in %LIBRARY_PREFIX% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
pushd %~1
nmake -f makefile.vc INSTALLDIR=%LIBRARY_PREFIX% MACHINE=%MACHINE% release
nmake -f makefile.vc INSTALLDIR=%LIBRARY_PREFIX% MACHINE=%MACHINE% install
if %ERRORLEVEL% GTR 0 exit 1
popd
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ SUCCESS ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
