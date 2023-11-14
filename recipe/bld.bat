if "%ARCH%"=="32" (
   set MACHINE="IX86"
   :: A different SDK is needed when build with VS 2017 and 2015
   :: http://wiki.tcl.tk/54819
   if "%VS_MAJOR%"=="14" (
    echo "Switching SDK versions"
    call "%VS140COMNTOOLS%..\..\VC\vcvarsall.bat" x86 10.0.15063.0
   )
) else if "%ARCH%"=="arm64" (
  set MACHINE="ARM64"
  set ARCH="ARM64"
  echo %SRC_DIR%\tcl%PKG_VERSION%\win
  echo %SRC_DIR%\..\..\..\.scripts\win_64_native_build.bat
  if EXIST %SRC_DIR%\..\..\..\.scripts\win_64_native_build.bat echo "found native .bat"
  where nmake
  echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ RUNNING NATIVE BUILD ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
  start /B /I /WAIT cmd /c %SRC_DIR%\..\..\..\.scripts\win_64_native_build.bat "%PIP_CACHE_DIR%\..\_h_env\Library" "%VS_MAJOR%" "%PIP_CACHE_DIR%\..\work\tcl%PKG_VERSION%\win" "%VCToolsInstallDir%bin\Hostx64\x64" "%VCINSTALLDIR%"
  echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ FINISHED NATIVE BUILD ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
  set "TCLSH_NATIVE=%SRC_DIR%\tcl%PKG_VERSION%\win\RELEASE_win_amd64\tclsh86t.exe"
  for /D %%f in (%SRC_DIR%\tcl%PKG_VERSION%\pkgs\*) do (
    echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Moving %SRC_DIR%\tcl%PKG_VERSION%\win\rules-ext.vc -> %%f\rules-ext.vc ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    copy /Y "%SRC_DIR%\tcl%PKG_VERSION%\win\rules-ext.vc" "%%f\win\rules-ext.vc"
    copy /Y "%SRC_DIR%\tcl%PKG_VERSION%\win\nmakehlp.exe" "%%f\win\nmakehlp.exe"
  )
  set
  :: A different SDK is needed when build with VS 2017 and 2015
  :: http://wiki.tcl.tk/54819
  if "%VS_MAJOR%"=="14" (
    echo "Switching SDK versions"
    call "%VS140COMNTOOLS%..\..\VC\vcvarsall.bat" amd64_arm64 10.0.15063.0
  )
) else (
  set MACHINE="AMD64"
  :: A different SDK is needed when build with VS 2017 and 2015
  :: http://wiki.tcl.tk/54819
  if "%VS_MAJOR%"=="14" (
    echo "Switching SDK versions"
    call "%VS140COMNTOOLS%..\..\VC\vcvarsall.bat" x64 10.0.15063.0
  )
)

pushd tcl%PKG_VERSION%\win
if NOT "%ARCH%"=="arm64" (
  nmake nmakehlp.exe
) else (
  set "PATH=%PATH%;%SRC_DIR%\tcl%PKG_VERSION%\win"
)
nmake -f makefile.vc INSTALLDIR=%LIBRARY_PREFIX% MACHINE=%MACHINE% release
nmake -f makefile.vc INSTALLDIR=%LIBRARY_PREFIX% MACHINE=%MACHINE% install
if %ERRORLEVEL% GTR 0 exit 1
popd

REM Required for having tmschema.h accessible.  Newer VS versions do not include this.
REM If you don't have this path, you are missing the Windows 7 SDK.  Please install this.
REM   NOTE: Later SDKs remove tmschema.h.  It really is necessary to use the Win 7 SDK.
set INCLUDE=%INCLUDE%;c:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Include

:: Tk build

pushd tk%PKG_VERSION%\win
nmake nmakehlp.exe
nmake -f makefile.vc INSTALLDIR=%LIBRARY_PREFIX% MACHINE=%MACHINE% TCLDIR=..\..\tcl%PKG_VERSION% release
nmake -f makefile.vc INSTALLDIR=%LIBRARY_PREFIX% MACHINE=%MACHINE% TCLDIR=..\..\tcl%PKG_VERSION% install
if %ERRORLEVEL% GTR 0 exit 1

if "%ARCH%"=="ARM64" (
  set ARCH="arm64"
)
:: Make sure that `wish` can be called without the version info.
copy %LIBRARY_PREFIX%\bin\wish86t.exe %LIBRARY_PREFIX%\bin\wish.exe
copy %LIBRARY_PREFIX%\bin\tclsh86t.exe %LIBRARY_PREFIX%\bin\tclsh.exe

:: No `t` version of wish86.exe
copy %LIBRARY_PREFIX%\bin\wish86t.exe %LIBRARY_PREFIX%\bin\wish86.exe
copy %LIBRARY_PREFIX%\bin\tclsh86t.exe %LIBRARY_PREFIX%\bin\tclsh86.exe
popd
