@echo ON

if "%target_platform%"=="win-64" (
  set MACHINE="AMD64"
)
if "%target_platform%"=="win-arm64" (
  set MACHINE="ARM64"
)

if "%build_platform%"=="win-64" (
  set BUILD_MACHINE="AMD64"
)
if "%build_platform%"=="win-arm64" (
  set BUILD_MACHINE="ARM64"
)

if NOT "%target_platform%"=="%build_platform%" (
  set "TCLSH_NATIVE=TCLSH_NATIVE=%BUILD_PREFIX%\Library\bin\tclsh86.exe"
)

pushd tcl%PKG_VERSION%\win
nmake nmakehlp.exe MACHINE=%BUILD_MACHINE%
nmake -f makefile.vc INSTALLDIR=%LIBRARY_PREFIX% %TCLSH_NATIVE% MACHINE=%MACHINE% release
nmake -f makefile.vc INSTALLDIR=%LIBRARY_PREFIX% %TCLSH_NATIVE% MACHINE=%MACHINE% install
if %ERRORLEVEL% GTR 0 exit 1
popd

:: Tk build

pushd tk%PKG_VERSION%\win
nmake nmakehlp.exe MACHINE=%BUILD_MACHINE%
nmake -f makefile.vc INSTALLDIR=%LIBRARY_PREFIX% %TCLSH_NATIVE% MACHINE=%MACHINE% TCLDIR=..\..\tcl%PKG_VERSION% release
nmake -f makefile.vc INSTALLDIR=%LIBRARY_PREFIX% %TCLSH_NATIVE% MACHINE=%MACHINE% TCLDIR=..\..\tcl%PKG_VERSION% install
if %ERRORLEVEL% GTR 0 exit 1

:: Make sure that `wish` can be called without the version info.
copy %LIBRARY_PREFIX%\bin\wish86t.exe %LIBRARY_PREFIX%\bin\wish.exe
copy %LIBRARY_PREFIX%\bin\tclsh86t.exe %LIBRARY_PREFIX%\bin\tclsh.exe

:: No `t` version of wish86.exe
copy %LIBRARY_PREFIX%\bin\wish86t.exe %LIBRARY_PREFIX%\bin\wish86.exe
copy %LIBRARY_PREFIX%\bin\tclsh86t.exe %LIBRARY_PREFIX%\bin\tclsh86.exe
popd
