@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title Cong Cu Khoi Phuc Cau Hinh Goc va Hoan Tac Toi Uu [Backup Restore]
color 0E

rem --- TU DONG XIN QUYEN ADMINISTRATOR ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Dang yeu cau quyen Administrator...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

:RESTORE_MENU
set "BACKUP_DIR=%~dp0Backup_Cau_Hinh_Goc\%COMPUTERNAME%"
set "HAS_BACKUP=0"
set "BK_TIME=Chua co ban sao luu nao cho may nay"
set "BK_OS=Khong xac dinh"

if exist "%BACKUP_DIR%\Snapshot_Original.json" (
    set "HAS_BACKUP=1"
    for /f "tokens=*" %%t in ('powershell -NoProfile -Command "(Get-Content '%BACKUP_DIR%\Snapshot_Original.json' | ConvertFrom-Json).Timestamp"') do set "BK_TIME=%%t"
    for /f "tokens=*" %%o in ('powershell -NoProfile -Command "(Get-Content '%BACKUP_DIR%\Snapshot_Original.json' | ConvertFrom-Json).OS"') do set "BK_OS=%%o"
)

cls
echo ===========================================================================
echo       CONG CU KHOI PHUC CAU HINH GOC ^& CUU HO HE THONG [WIN 10 / 11]
echo ===========================================================================
echo   [THONG TIN BAN SAO LUU DU PHONG CUA MAY: %COMPUTERNAME%]
if "%HAS_BACKUP%"=="1" (
    echo   - Trang thai Backup : DA TIM THAY BAN BACKUP GOC!
    echo   - Thoi diem sao luu : %BK_TIME%
    echo   - He dieu hanh      : %BK_OS%
    echo   - Thu muc luu tru   : Backup_Cau_Hinh_Goc\%COMPUTERNAME%
) else (
    echo   - Trang thai Backup : CHUA CO FILE BACKUP TRONG THU MUC HIEN TAI
    echo     [Ban van co the dung Muc 2, 3, 4, 5 hoac 6 ben duoi]
)
echo ===========================================================================
echo.
echo   CHON CHE DO KHOI PHUC:
echo   [1] KHOI PHUC 100%% CAU HINH TRUOC LUC TOI UU [Doc tu file Backup Goc]
echo       - Tra lai nguyen trang Services, Pagefile, Registry, Power Plan,
echo         Hieu ung, Menu Chuot Phai... dung nhu luc truoc khi chay Toi Uu
echo   [2] Chi bat lai Windows Update ^& Microsoft Store [Giu nguyen cac toi uu khac]
echo   [3] Chi bat lai Windows Search ^& SysMain [Khi nang cap tu HDD len SSD]
echo   [4] Chi bat lai VBS / Core Isolation [Khi can choi Valorant / Vanguard Win 11]
echo   [5] Dua tat ca ve Mac Dinh Chuan cua Microsoft Windows [Khong can file Backup]
echo   [6] Mo giao dien System Restore Point cua Windows [rstrui.exe]
echo   [7] Thoat cong cu
echo ===========================================================================
echo.
choice /c 1234567 /n /m ">> Nhan phim so [1 - 7] de chon thao tac khoi phuc: "
set "RES_OPT=%errorlevel%"
echo.

if "%RES_OPT%"=="7" exit /b
if "%RES_OPT%"=="6" (
    echo Dang mo cong cu System Restore cua Windows...
    start rstrui.exe
    goto RESTORE_MENU
)
if "%RES_OPT%"=="1" goto DO_RESTORE_SNAPSHOT
if "%RES_OPT%"=="2" goto DO_RESTORE_UPDATE
if "%RES_OPT%"=="3" goto DO_RESTORE_SEARCH
if "%RES_OPT%"=="4" goto DO_RESTORE_VBS
if "%RES_OPT%"=="5" goto DO_RESTORE_DEFAULT
goto RESTORE_MENU

:DO_RESTORE_SNAPSHOT
if "%HAS_BACKUP%"=="0" (
    echo [CANH BAO] Khong tim thay thu muc Backup_Cau_Hinh_Goc\%COMPUTERNAME%!
    echo Vui long chon Muc [5] de dua ve mac dinh chuan cua Windows.
    pause
    goto RESTORE_MENU
)
echo ---------------------------------------------------------------------------
echo [1/4] Dang xoa cac khoa Policy va thiet lap xung dot do cong cu Toi Uu tao ra...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Edge" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /f >nul 2>&1
reg delete "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" /f >nul 2>&1
reg delete "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v EnableVirtualizationBasedSecurity /f >nul 2>&1

echo [2/4] Dang nap lai toan bo cac file Registry [.reg] goc truoc luc toi uu...
for %%r in ("%BACKUP_DIR%\*.reg") do (
    reg import "%%r" >nul 2>&1
)
powershell -NoProfile -ExecutionPolicy Bypass -Command "if (-not (Get-AppxPackage *GetHelp*)) { winget install --id 9PKDZBMV1H3T --source msstore --accept-package-agreements --accept-source-agreements }; Get-AppxPackage *Windows.ImmersiveControlPanel* | ForEach-Object { Add-AppxPackage -DisableDevelopmentMode -Register ($_.InstallLocation + '\AppXManifest.xml') -ErrorAction SilentlyContinue }" >nul 2>&1

echo [3/4] Dang khoi phuc trang thai Services, Scheduled Tasks, Pagefile, Power Plan...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='SilentlyContinue'; $bk=Get-Content '%BACKUP_DIR%\Snapshot_Original.json' | ConvertFrom-Json; if($bk.Services){$bk.Services.PSObject.Properties | ForEach-Object {$name=$_.Name; $mode=$_.Value.StartMode; $state=$_.Value.State; $scMode=switch($mode){'Auto'{'auto'}'Manual'{'demand'}'Disabled'{'disabled'}default{'demand'}}; sc.exe config $name start= $scMode | Out-Null; if($state -eq 'Running'){Start-Service -Name $name}}}; if($bk.Tasks){$bk.Tasks.PSObject.Properties | ForEach-Object {if($_.Value -ne 'Disabled'){schtasks.exe /Change /TN $_.Name /Enable 2>$null | Out-Null}}}; if($bk.Pagefile){$cs=Get-CimInstance -ClassName Win32_ComputerSystem; if($bk.Pagefile.Auto){Set-CimInstance -InputObject $cs -Property @{AutomaticManagedPagefile=$true} | Out-Null}else{Set-CimInstance -InputObject $cs -Property @{AutomaticManagedPagefile=$false} | Out-Null; $pf=Get-CimInstance -ClassName Win32_PageFileSetting | Select-Object -First 1; if($pf -and $bk.Pagefile.Max -gt 0){Set-CimInstance -InputObject $pf -Property @{InitialSize=$bk.Pagefile.Init;MaximumSize=$bk.Pagefile.Max} | Out-Null}}}; if($bk.PowerScheme){powercfg.exe /setactive $bk.PowerScheme 2>$null}; if($bk.Hibernate){if($bk.Hibernate.Enabled -eq 1){powercfg.exe /h on 2>$null}else{powercfg.exe /h off 2>$null}}; if($null -ne $bk.Win10ContextMenu){if($bk.Win10ContextMenu -eq $true){reg.exe add 'HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32' /f /ve 2>$null | Out-Null}else{reg.exe delete 'HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}' /f 2>$null | Out-Null}}; if($bk.MemoryCompression -eq $true){Enable-MMAgent -mc}elseif($bk.MemoryCompression -eq $false){Disable-MMAgent -mc}"

echo [4/4] Dang khoi dong lai File Explorer de cap nhat giao dien...
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
echo.
echo ===========================================================================
echo   DA KHOI PHUC 100%% CAU HINH GOC TU BAN BACKUP [%BK_TIME%]!
echo   Vui long Khoi dong lai may de moi thay doi co hieu luc hoan toan.
echo ===========================================================================
pause
goto RESTORE_MENU

:DO_RESTORE_UPDATE
echo Dang mo khoa va bat lai Windows Update ^& Microsoft Store...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v Start /t REG_DWORD /d 3 /f >nul 2>&1
for %%u in (wuauserv UsoSvc dosvc bits) do (
    sc config "%%u" start= demand >nul 2>&1
    sc start "%%u" >nul 2>&1
)
echo -> Da bat lai Windows Update ^& Store thanh cong!
pause
goto RESTORE_MENU

:DO_RESTORE_SEARCH
echo Dang bat lai dich vu Windows Search [WSearch] va SysMain...
sc config "WSearch" start= delayed-auto >nul 2>&1
sc start "WSearch" >nul 2>&1
sc config "SysMain" start= auto >nul 2>&1
sc start "SysMain" >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 1 /f >nul 2>&1
reg delete "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /f >nul 2>&1
echo -> Da bat lai Windows Search ^& SysMain thanh cong!
pause
goto RESTORE_MENU

:DO_RESTORE_VBS
echo Dang bat lai VBS [Virtualization-Based Security] ^& Memory Integrity...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v Enabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v EnableVirtualizationBasedSecurity /t REG_DWORD /d 1 /f >nul 2>&1
echo -> Da bat lai VBS / Core Isolation! Ban can KHOI DONG LAI MAY de co hieu luc.
pause
goto RESTORE_MENU

:DO_RESTORE_DEFAULT
echo Dang dua toan bo cau hinh ve Mac dinh chuan cua Microsoft Windows...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Edge" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /f >nul 2>&1
reg delete "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" /f >nul 2>&1
reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f >nul 2>&1

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 1 /f >nul 2>&1

for %%s in (SysMain WSearch DiagTrack WerSvc PcaSvc) do (
    sc config "%%s" start= auto >nul 2>&1
    sc start "%%s" >nul 2>&1
)
for %%u in (wuauserv UsoSvc dosvc XblAuthManager XblGameSave XboxNetApiSvc) do (
    sc config "%%u" start= demand >nul 2>&1
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "$cs = Get-CimInstance -ClassName Win32_ComputerSystem; Set-CimInstance -InputObject $cs -Property @{AutomaticManagedPagefile=$true} | Out-Null; Enable-MMAgent -mc -ErrorAction SilentlyContinue" >nul 2>&1
powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1
powercfg /h on >nul 2>&1

echo -> Da dua toan bo thiet lap ve Mac dinh chuan cua Windows!
pause
goto RESTORE_MENU
