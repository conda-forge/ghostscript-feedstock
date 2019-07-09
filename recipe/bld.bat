nmake -f psi\msvc.mak GSROOTDIR=%LIBRARY_PREFIX% WIN64= MSVC_VERSION=%VS_MAJOR% DEVSTUDIO=
if errorlevel 1 exit 1

move bin\*.dll %LIBRARY_BIN%
cp bin\gswin64c.exe %LIBRARY_BIN%\gs.exe
move bin\*.exe %LIBRARY_BIN%
move bin\*.lib %LIBRARY_LIB%
move bin\*.exp %LIBRARY_LIB%
move Resource %LIBRARY_PREFIX%
move fonts %LIBRARY_PREFIX%\Resource\Font
