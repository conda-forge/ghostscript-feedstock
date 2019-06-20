set LIB=%LIBRARY_LIB%;%LIB%
set INCLUDE=%LIBRARY_INC%;%INCLUDE%

mkdir build

nmake -f psi\msvc.mak GSROOTDIR="build" WIN64= MSVC_VERSION=%VS_MAJOR:"=% DEVSTUDIO=
if errorlevel 1 exit 1

robocopy build\ %LIBRARY_PREFIX% *.* /E
if %ERRORLEVEL% GTR 3 exit 1

exit 0
