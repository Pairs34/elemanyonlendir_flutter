@echo off
echo ==========================================
echo     Elemanyonlendir App Bundle Builder
echo ==========================================
echo.

REM Proje dizinine git
cd /d "c:\Users\Pairs\Desktop\Projects\Flutter\elemanyonlendir_flutter"

echo [1/5] Flutter temizligi yapiliyor...
flutter clean
if %errorlevel% neq 0 (
    echo HATA: Flutter clean basarisiz!
    pause
    exit /b 1
)

echo [2/5] Dependencies yukluyor...
flutter pub get
if %errorlevel% neq 0 (
    echo HATA: Dependencies yukleme basarisiz!
    pause
    exit /b 1
)

echo [3/5] Keystore dosyasi kontrol ediliyor...
if not exist "elemanyonlendir.jks" (
    echo HATA: Keystore dosyasi bulunamadi!
    echo Dosya yolu: %cd%\elemanyonlendir.jks
    echo Lutfen elemanyonlendir.jks dosyasini proje ana dizinine kopyalayin.
    pause
    exit /b 1
)

echo [4/5] key.properties dosyasi guncelleniyor...
(
echo storeFile=../elemanyonlendir.jks
echo storePassword=Mes958958!
echo keyAlias=MYSGrup
echo keyPassword=Mes958958!
) > android\key.properties

echo [5/5] Profile App Bundle olusturuluyor...
flutter build appbundle --profile
if %errorlevel% neq 0 (
    echo Profile build basarisiz oldu, debug mode deneniyor...
    flutter build appbundle --debug
    if %errorlevel% neq 0 (
        echo HATA: App Bundle olusturma basarisiz!
        pause
        exit /b 1
    )
    set "BUILD_TYPE=debug"
) else (
    set "BUILD_TYPE=profile"
)

echo.
echo ==========================================
echo        BUILD BASARIYLA TAMAMLANDI!
echo ==========================================
echo.
if "%BUILD_TYPE%"=="debug" (
    echo App Bundle dosyasi olusturuldu:
    echo build\app\outputs\bundle\debug\app-debug.aab
    echo.
    echo Boyut bilgisi:
    for %%I in (build\app\outputs\bundle\debug\app-debug.aab) do echo Dosya boyutu: %%~zI bytes
    echo.
    echo Dosya explorer'da acilsin mi? (Y/N)
    set /p openExplorer=
    if /i "%openExplorer%"=="Y" (
        explorer build\app\outputs\bundle\debug\
    )
) else (
    echo App Bundle dosyasi olusturuldu:
    echo build\app\outputs\bundle\profile\app-profile.aab
    echo.
    echo Boyut bilgisi:
    for %%I in (build\app\outputs\bundle\profile\app-profile.aab) do echo Dosya boyutu: %%~zI bytes
    echo.
    echo Dosya explorer'da acilsin mi? (Y/N)
    set /p openExplorer=
    if /i "%openExplorer%"=="Y" (
        explorer build\app\outputs\bundle\profile\
    )
)

echo.
echo Build tamamlandi! Cikis yapmak icin bir tusa basin...
pause