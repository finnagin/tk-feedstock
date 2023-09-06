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
  :: set TCLSH_NATIVE=0
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
nmake nmakehlp.exe INSTALLDIR=%LIBRARY_PREFIX%
set PATH=%PATH%;%SRC_DIR%\tcl%PKG_VERSION%\win
if %ARCH%=="ARM64" (
   echo "^^^^^^^^^^^^^^^^^^^^^^^^ build native tcl ^^^^^^^^^^^^^^^^^^^^^^^^"
   mkdir %SRC_DIR%\tclnative
   nmake -f makefile.vc INSTALLDIR=%SRC_DIR%\tclnative MACHINE="AMD64" ARCH="AMD64" release
   nmake -f makefile.vc INSTALLDIR=%SRC_DIR%\tclnative MACHINE="AMD64" ARCH="AMD64" install
   set TCLSH_NATIVE=%SRC_DIR%\tclnative
   echo "^^^^^^^^^^^^^^^^^^^^^^^^ set TCLSH_NATIVE ^^^^^^^^^^^^^^^^^^^^^^^^"
   cd %TCLSH_NATIVE%
   dir
   cd %SRC_DIR%\tcl%PKG_VERSION%\win
) else (
   echo "^^^^^^^^^^^^^^^^^^^^^^^^ skipped TCLSH_NATIVE ^^^^^^^^^^^^^^^^^^^^^^^^"
   echo %ARCH%
)
echo "^^^^^^^^^^^^^^^^^^^^^ running tcl build ^^^^^^^^^^^^^^^^^^^^^"
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
nmake -f makefile.vc INSTALLDIR=%LIBRARY_PREFIX% MACHINE=%MACHINE% TCLDIR=..\..\tcl%PKG_VERSION% release
nmake -f makefile.vc INSTALLDIR=%LIBRARY_PREFIX% MACHINE=%MACHINE% TCLDIR=..\..\tcl%PKG_VERSION% install
if %ERRORLEVEL% GTR 0 exit 1

:: Make sure that `wish` can be called without the version info.
copy %LIBRARY_PREFIX%\bin\wish86t.exe %LIBRARY_PREFIX%\bin\wish.exe
copy %LIBRARY_PREFIX%\bin\tclsh86t.exe %LIBRARY_PREFIX%\bin\tclsh.exe

:: No `t` version of wish86.exe
copy %LIBRARY_PREFIX%\bin\wish86t.exe %LIBRARY_PREFIX%\bin\wish86.exe
copy %LIBRARY_PREFIX%\bin\tclsh86t.exe %LIBRARY_PREFIX%\bin\tclsh86.exe
popd

if "%ARCH%"=="ARM64" (
  set ARCH="arm64"
)
