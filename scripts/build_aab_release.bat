@echo off
setlocal

REM Builds a release App Bundle (.aab). Assumes android\key.properties exists.

REM Change to repo root (this script lives in scripts\)
pushd "%~dp0.."

call flutter pub get
if errorlevel 1 goto :done

call flutter build appbundle --release
if errorlevel 1 goto :done

set AAB=build\app\outputs\bundle\release\app-release.aab

echo.
if exist "%AAB%" (
	echo Build succeeded. AAB:
	echo   %AAB%
	echo Upload this file to Google Play Console.
) else (
	echo Build finished. If AAB not found, check Flutter/Gradle output above.
)

popd
endlocal

:done
