setlocal EnableDelayedExpansion
@ECHO ON


@REM Here we ditch the -GL flag, which messes up symbol resolution.
set "CFLAGS=-MD"
set "CXXFLAGS=-MD"

:: set pkg-config path so that host deps can be found
:: (set as env var so it's used by both meson and during build with g-ir-scanner)
set "PKG_CONFIG_PATH=%LIBRARY_LIB%\pkgconfig;%LIBRARY_PREFIX%\share\pkgconfig;%BUILD_PREFIX%\Library\lib\pkgconfig"

mkdir forgebuild
cd forgebuild

set ^"MESON_OPTIONS=^
  --prefix="%LIBRARY_PREFIX%" ^
  --default-library=shared ^
  --buildtype=release ^
  --backend=ninja ^
  -Dtests=false ^
  -Dpython="%PYTHON%" ^
  -Dpython.platlibdir="%SP_DIR%" ^
  -Dpython.purelibdir="%SP_DIR%" ^
 ^"

%BUILD_PREFIX%\Scripts\meson !MESON_OPTIONS!
if errorlevel 1 exit 1

ninja -v
if errorlevel 1 exit 1

ninja install
if errorlevel 1 exit 1

