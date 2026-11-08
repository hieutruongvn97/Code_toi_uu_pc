@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title Cong Cu Kiem Tra Dung Luong va Don Rac Chuyen Sau [Win 10 / Win 11 Pro]
color 0A

rem --- TU DONG XIN QUYEN ADMINISTRATOR ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Dang yeu cau quyen Administrator...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

:MAIN_SCAN
cls
echo ===========================================================================
echo       CONG CU KIEM TRA DUNG LUONG O C: ^& DON RAC CHUYEN SAU [WIN 10/11]
echo ===========================================================================
echo   Dang quet nhanh dung luong o C: va cac bo dem rac he thong / trinh duyet...
echo ===========================================================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='SilentlyContinue'; $d=Get-PSDrive C; $tot=[math]::Round(($d.Used+$d.Free)/1GB,1); $used=[math]::Round($d.Used/1GB,1); $free=[math]::Round($d.Free/1GB,1); Write-Host '  [1] TONG QUAN DUNG LUONG O C:' -ForegroundColor Cyan; Write-Host ('      - Tong dung luong : '+$tot+' GB | Da dung: '+$used+' GB | Con trong: '+$free+' GB') -ForegroundColor White; Write-Host ''; Write-Host '  [2] CAC FILE HE THONG AN NGON DUNG LUONG LON NHAT [Tai C:\]:' -ForegroundColor Cyan; cmd /c 'dir /a C:\hiberfil.sys C:\pagefile.sys C:\swapfile.sys 2>nul' | Select-String 'sys' | ForEach-Object { Write-Host ('      '+$_.Line.Trim()) -ForegroundColor Yellow }; Write-Host ''; function Get-SizeMB($paths){$sum=0; foreach($p in $paths){if(Test-Path $p){$s=(Get-ChildItem $p -Recurse -Force -File | Measure-Object -Property Length -Sum).Sum; if($s){$sum+=$s}}}; return [math]::Round($sum/1MB,1)}; Write-Host '  [3] THONG KE DUNG LUONG RAC CO THE DON NGAY [AN TOAN 100%%]:' -ForegroundColor Cyan; $t1=Get-SizeMB @($env:TEMP,'C:\Windows\Temp','C:\Windows\Prefetch'); Write-Host ('      - File Tam He Thong [User Temp, Win\Temp, Prefetch]: '+$t1+' MB'); $t2=Get-SizeMB @('C:\Windows\SoftwareDistribution\Download'); Write-Host ('      - Rac cap nhat Windows [Windows Update Cache]     : '+$t2+' MB'); $t3=Get-SizeMB @('C:\ProgramData\Microsoft\Windows\WER',($env:LOCALAPPDATA+'\CrashDumps'),'C:\Windows\Minidump'); Write-Host ('      - Bao cao loi & File Crash [WER, CrashDumps]      : '+$t3+' MB'); $t4=Get-SizeMB @(($env:LOCALAPPDATA+'\D3DSCache'),($env:LOCALAPPDATA+'\AMD\DxCache'),($env:LOCALAPPDATA+'\NVIDIA\DXCache'),($env:LOCALAPPDATA+'\NVIDIA\GLCache')); Write-Host ('      - Bo dem Card Do Hoa [DirectX / AMD / NVIDIA]     : '+$t4+' MB'); $bPaths=@(($env:LOCALAPPDATA+'\Google\Chrome\User Data\*\Cache*'),($env:LOCALAPPDATA+'\Google\Chrome\User Data\*\Code Cache*'),($env:LOCALAPPDATA+'\Google\Chrome\User Data\*\GPUCache*'),($env:LOCALAPPDATA+'\Microsoft\Edge\User Data\*\Cache*'),($env:LOCALAPPDATA+'\Microsoft\Edge\User Data\*\Code Cache*'),($env:LOCALAPPDATA+'\Microsoft\Edge\User Data\*\GPUCache*'),($env:LOCALAPPDATA+'\CocCoc\Browser\User Data\*\Cache*'),($env:LOCALAPPDATA+'\CocCoc\Browser\User Data\*\Code Cache*'),($env:APPDATA+'\discord\Cache*'),($env:APPDATA+'\discord\Code Cache*'),($env:APPDATA+'\discord\GPUCache*')); $t5=Get-SizeMB $bPaths; Write-Host ('      - Cache Trinh Duyet [Chrome/Edge/CocCoc/Discord]  : '+$t5+' MB [Khong mat nick/mat khau]'); $t6=Get-SizeMB @('C:\Windows.old'); if($t6 -gt 0){Write-Host ('      - Ban Windows cu [C:\Windows.old]                 : '+$t6+' MB') -ForegroundColor Red}; $sumJunk=[math]::Round($t1+$t2+$t3+$t4+$t5+$t6,1); Write-Host ('      => TONG DUNG LUONG RAC CO THE DON NGAY            : '+$sumJunk+' MB') -ForegroundColor Green"

echo.
echo ===========================================================================
echo   MENU CHUC NANG DON RAC ^& PHAN TICH DUNG LUONG:
echo   [1] Don Rac Tieu Chuan + Cache Trinh Duyet ^& GPU [An toan 100%% - Giu nguyen
echo       mat khau/lich su web, xoa Temp, Update Cache, WER, Shader, Thung rac]
echo   [2] Don Rac Chuyen Sau + Xoa Hiberfil.sys + Toi uu TRIM SSD [Lam muc 1 +
echo       Xoa file Ngu dong hiberfil.sys giai phong 4GB -^> 27GB + TRIM o cung!]
echo   [3] Don Siet WinSxS ^& Windows.old [Chay DISM StartComponentCleanup nen
echo       cac goi cap nhat Windows cu - Mat khoang 2-5 phut]
echo   [4] SOI CHI TIET: Quet Top 10 Thu Muc Nang Nhat Trong AppData ^& ProgramData
echo   [5] Quet cap nhat lai bang thong ke
echo   [6] Thoat cong cu
echo ===========================================================================
echo.
choice /c 123456 /n /m ">> Nhan phim so [1, 2, 3, 4, 5 hoac 6] de chon thao tac: "
set "CLEAN_OPT=%errorlevel%"
echo.

if "%CLEAN_OPT%"=="6" exit /b
if "%CLEAN_OPT%"=="5" goto MAIN_SCAN
if "%CLEAN_OPT%"=="4" goto DEEP_SCAN

rem ===========================================================================
rem THUC HIEN DON RAC TIEU CHUAN [AP DUNG CHO CA MUC 1, 2, 3]
rem ===========================================================================
echo ---------------------------------------------------------------------------
echo [BUOC 1] Dang don sach File tam [%TEMP%, Windows\Temp, Prefetch]...
del /f /s /q "%temp%\*.*" >nul 2>&1
rd /s /q "%temp%" >nul 2>&1
md "%temp%" >nul 2>&1

del /f /s /q "C:\Windows\Temp\*.*" >nul 2>&1
for /d %%p in ("C:\Windows\Temp\*") do rd /s /q "%%p" >nul 2>&1

del /f /s /q "C:\Windows\Prefetch\*.*" >nul 2>&1

echo [BUOC 2] Dang xoa Cache Windows Update [SoftwareDistribution\Download]...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
del /f /s /q "C:\Windows\SoftwareDistribution\Download\*.*" >nul 2>&1
for /d %%p in ("C:\Windows\SoftwareDistribution\Download\*") do rd /s /q "%%p" >nul 2>&1

echo [BUOC 3] Dang xoa Bao cao loi WER, CrashDumps va Bo dem GPU Shader...
del /f /s /q "C:\ProgramData\Microsoft\Windows\WER\ReportArchive\*.*" >nul 2>&1
del /f /s /q "C:\ProgramData\Microsoft\Windows\WER\ReportQueue\*.*" >nul 2>&1
del /f /s /q "%LOCALAPPDATA%\CrashDumps\*.*" >nul 2>&1
del /f /s /q "%LOCALAPPDATA%\D3DSCache\*.*" >nul 2>&1
del /f /s /q "%LOCALAPPDATA%\AMD\DxCache\*.*" >nul 2>&1
del /f /s /q "%LOCALAPPDATA%\NVIDIA\DXCache\*.*" >nul 2>&1
del /f /s /q "%LOCALAPPDATA%\NVIDIA\GLCache\*.*" >nul 2>&1
del /f /q "C:\Windows\memory.dmp" >nul 2>&1
del /f /s /q "C:\Windows\Minidump\*.*" >nul 2>&1

echo [BUOC 4] Dang don Cache Trinh duyet [Chrome, Edge, CocCoc, Discord - Giu nguyen Login]...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='SilentlyContinue'; $bPaths=@(($env:LOCALAPPDATA+'\Google\Chrome\User Data\*\Cache\Cache_Data\*'),($env:LOCALAPPDATA+'\Google\Chrome\User Data\*\Code Cache\*'),($env:LOCALAPPDATA+'\Google\Chrome\User Data\*\GPUCache\*'),($env:LOCALAPPDATA+'\Microsoft\Edge\User Data\*\Cache\Cache_Data\*'),($env:LOCALAPPDATA+'\Microsoft\Edge\User Data\*\Code Cache\*'),($env:LOCALAPPDATA+'\Microsoft\Edge\User Data\*\GPUCache\*'),($env:LOCALAPPDATA+'\CocCoc\Browser\User Data\*\Cache\Cache_Data\*'),($env:LOCALAPPDATA+'\CocCoc\Browser\User Data\*\Code Cache\*'),($env:APPDATA+'\discord\Cache\*'),($env:APPDATA+'\discord\Code Cache\*'),($env:APPDATA+'\discord\GPUCache\*')); foreach($p in $bPaths){Remove-Item -Path $p -Recurse -Force}"

echo [BUOC 5] Dang don sach Thung rac Recycle Bin, Thumbnail Cache va DNS...
del /f /s /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1
ipconfig /flushdns >nul 2>&1

if "%CLEAN_OPT%"=="2" goto CLEAN_DEEP_HIBER
if "%CLEAN_OPT%"=="3" goto CLEAN_WINSXS
goto FINISH_CLEAN

:CLEAN_DEEP_HIBER
echo [BUOC 6 - CHUYEN SAU] Kiem tra loai may de xu ly file C:\hiberfil.sys...
set "IS_LAPTOP=Desktop"
for /f "tokens=*" %%p in ('powershell -NoProfile -Command "if (Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue) { 'Laptop' } else { 'Desktop' }"') do set "IS_LAPTOP=%%p"
if "%IS_LAPTOP%"=="Laptop" (
    echo       - Phat hien Laptop: Thu gon hiberfil.sys xuong muc toi thieu de bao ve pin!
    powercfg /h on >nul 2>&1
    powercfg /h /type reduced >nul 2>&1
) else (
    echo       - Phat hien PC De Ban: Tat Hibernation de xoa han file C:\hiberfil.sys!
    powercfg -h off >nul 2>&1
)
echo [BUOC 7 - CHUYEN SAU] Dang chay ReTrim / Toi uu hoa phan vung o C:...
defrag C: /O >nul 2>&1
goto FINISH_CLEAN

:CLEAN_WINSXS
if exist "C:\Windows.old" (
    echo [BUOC 6 - CHUYEN SAU] Dang xoa thu muc Windows.old...
    takeown /F "C:\Windows.old\*" /R /A /D Y >nul 2>&1
    icacls "C:\Windows.old\*.*" /T /grant administrators:F >nul 2>&1
    rd /s /q "C:\Windows.old" >nul 2>&1
)
echo [BUOC 7 - CHUYEN SAU] Dang thu gon thu muc he thong WinSxS [DISM Cleanup]...
echo       Vui long doi 2-5 phut de he thong nen cac goi cap nhat cu...
Dism.exe /online /Cleanup-Image /StartComponentCleanup
goto FINISH_CLEAN

:FINISH_CLEAN
echo.
echo ===========================================================================
echo   DA HOAN TAT DON RAC! Hay xem dung luong o C: sau khi don:
echo ===========================================================================
powershell -NoProfile -Command "$d=Get-PSDrive C; $used=[math]::Round($d.Used/1GB,2); $free=[math]::Round($d.Free/1GB,2); Write-Host ('  => Dung luong o C hien tai: Da dung '+$used+' GB | Con trong '+$free+' GB') -ForegroundColor Green"
echo.
echo Nhan phim bat ky de quay lai Man hinh kiem tra dung luong...
pause >nul
goto MAIN_SCAN

:DEEP_SCAN
echo ---------------------------------------------------------------------------
echo Dang quet chuyen sau cac thu muc trong AppData ^& ProgramData [10-20 giay]...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='SilentlyContinue'; $folders=Get-ChildItem -Path $env:LOCALAPPDATA,$env:APPDATA,'C:\ProgramData' -Directory -Force; $res=foreach($f in $folders){$s=(Get-ChildItem $f.FullName -Recurse -Force -File | Measure-Object -Property Length -Sum).Sum; if($s -gt 150MB){[PSCustomObject]@{Path=$f.FullName;GB=[math]::Round($s/1GB,2);MB=[math]::Round($s/1MB,0)}}}; Write-Host ''; Write-Host '  TOP 10 THU MUC DANG CHIEM NHIEU DUNG LUONG NHAT:' -ForegroundColor Yellow; $res | Sort-Object MB -Descending | Select-Object -First 10 | ForEach-Object { Write-Host ('  - {0,-56} : {1,6} GB [{2} MB]' -f $_.Path,$_.GB,$_.MB) -ForegroundColor White }"
echo ---------------------------------------------------------------------------
echo Nhan phim bat ky de quay lai Menu chinh...
pause >nul
goto MAIN_SCAN
