@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title Cong Cu Toi Uu Windows 11 Chuyen Sau [Gaming / Van Phong / Full Features + Backup]
color 0B

rem --- TU DONG XIN QUYEN ADMINISTRATOR ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Dang yeu cau quyen Administrator...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

rem ======================================================================
rem BUOC 1: TU DONG QUET CAU HINH PHAN CUNG CHI TIET (1 LAN QUET NHANH)
rem ======================================================================
cls
echo Dang quet thong tin phan cung he thong Windows 11, vui long doi...

set "OS_NAME=Windows 11"
set "CPU_NAME=Unknown CPU"
set "GPU_NAME=Standard VGA"
set "DETECTED_RAM=8"
set "DETECTED_DISK=SSD/NVMe"
set "PC_TYPE=PC De Ban"

for /f "tokens=1,* delims==" %%a in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='SilentlyContinue'; $cv=Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'; $cap=(Get-CimInstance Win32_OperatingSystem).Caption; $ver=if($cv.DisplayVersion){$cv.DisplayVersion}else{$cv.ReleaseId}; Write-Output ('OS_NAME='+$cap+' - Version '+$ver+' [Build '+$cv.CurrentBuild+'.'+$cv.UBR+']'); Write-Output ('CPU_NAME='+(Get-CimInstance Win32_Processor | Select-Object -First 1).Name.Trim()); Write-Output ('GPU_NAME='+((Get-CimInstance Win32_VideoController | ForEach-Object {$_.Name}) -join ' + ')); Write-Output ('DETECTED_RAM='+[math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory/1GB)); $dn=(Get-Partition -DriveLetter C).DiskNumber; $d=if($null -ne $dn){Get-PhysicalDisk | Where-Object DeviceId -eq $dn}else{Get-PhysicalDisk | Select-Object -First 1}; $dt=if($d.MediaType -and $d.MediaType -ne 'Unspecified'){$d.MediaType+' - '+$d.FriendlyName}else{'SSD/NVMe - '+$d.FriendlyName}; Write-Output ('DETECTED_DISK='+$dt); $bat=if(Get-CimInstance Win32_Battery){'Laptop - Co Pin'}else{'PC De Ban - Desktop'}; Write-Output ('PC_TYPE='+$bat)"') do (
    set "%%a=%%b"
)

cls
echo ===========================================================================
echo          CONG CU TOI UU HOA WINDOWS 11 THONG MINH [ALL-IN-ONE PRO]
echo ===========================================================================
echo   [THONG TIN CAU HINH MAY QUET DUOC]:
echo   - Ten may tinh  : %COMPUTERNAME% [%PC_TYPE%]
echo   - He dieu hanh  : %OS_NAME%
echo   - Vi xu ly CPU  : %CPU_NAME%
echo   - Card do hoa   : %GPU_NAME%
echo   - Dung luong RAM: Khoang %DETECTED_RAM% GB
echo   - O cung cai Win: %DETECTED_DISK%
echo ===========================================================================
echo.

rem ===========================================================================
rem CAU HOI 1: NHU CAU SU DUNG CHINH [PROFILE]
rem ===========================================================================
echo [CAU HOI 1/4] Nhu cau su dung chinh cua ban tren may Windows 11 nay la gi?
echo   [1] CHOI GAME MUOT ^& NHANH NHAT [Gaming Mode]
echo       - Bat Ultimate Performance, Game Mode, GPU Scheduling, Giam Input Lag,
echo         Toi uu mang TCP, Go sach Widgets/Copilot/Recall/Bloatware
echo   [2] LAM VIEC VAN PHONG / MAY CAU HINH YEU [Office ^& Stability]
echo       - Tiet kiem RAM toi da, Tat Widgets/Copilot/Quang cao, Giu in an Print
echo         Spooler/OneDrive/Clipboard, Menu chuot phai Win 10 nhanh gon
echo   [3] XAI TOAN BO TINH NANG WINDOWS 11 [Full Features + Clean]
echo       - Giu nguyen giao dien Mica/Trong suot, Giu Copilot/Widgets/Store/Xbox,
echo         chi tat Telemetry theo doi ngam va don rac he thong de may chay muot
echo.
choice /c 123 /n /m ">> Nhan phim so [1, 2 hoac 3] de chon Nhu cau su dung: "
set "MODE_OPT=%errorlevel%"
echo Da chon che do [%MODE_OPT%].
echo.

set "VBS_OPT=1"
if not "%MODE_OPT%"=="1" goto SKIP_VBS_QUESTION
echo [CAU HOI PHU - ANTI-CHEAT GAME] Ban co choi Valorant / LoL [Riot Vanguard]
echo                                 hoac FaceIt CS2 tren may nay khong?
echo   [1] Khong - Tat VBS / Core Isolation de tang them 5-15%% FPS toi da
echo   [2] Co    - Giu nguyen VBS / Core Isolation de tranh loi Anti-Cheat Vanguard
echo.
choice /c 12 /n /m ">> Nhan phim so [1 hoac 2]: "
set "VBS_OPT=%errorlevel%"
echo Da chon [%VBS_OPT%].
echo.
:SKIP_VBS_QUESTION

rem ===========================================================================
rem CAU HOI 2: XAC NHAN MUC RAM DE TOI UU BO NHO
rem ===========================================================================
echo [CAU HOI 2/4] Xac nhan dung luong RAM cua may [Goi y quet duoc: %DETECTED_RAM% GB]:
echo   [1] Tu 4 GB - 6 GB  - RAM yeu: Dat Pagefile co dinh 6GB, Tat hieu ung trong suot
echo   [2] 8 GB            - RAM pho thong: Dat Pagefile co dinh 4GB, Can bang hieu ung
echo   [3] 16 GB tro len   - RAM cao: Dat Pagefile 4GB, Tat nen RAM giam tai cho CPU
echo.
choice /c 123 /n /m ">> Nhan phim so [1, 2 hoac 3] de chon muc RAM: "
set "RAM_OPT=%errorlevel%"
echo Da chon muc RAM [%RAM_OPT%].
echo.

rem ===========================================================================
rem CAU HOI 3: GIAO DIEN MENU CHUOT PHAI & TASKBAR WINDOWS 11
rem ===========================================================================
echo [CAU HOI 3/4] Ban co muon dua Menu Chuot Phai ve kieu Windows 10 [hien du
echo               tuy chon ngay lap tuc, khong can bam Show more options] khong?
echo   [1] Co - Dung Menu Chuot Phai kieu cu [Nhanh va tien loi hon]
echo   [2] Khong - Giu Menu Chuot Phai mac dinh cua Windows 11
echo.
choice /c 12 /n /m ">> Nhan phim so [1 hoac 2]: "
set "CTX_OPT=%errorlevel%"
echo Da chon [%CTX_OPT%].
echo.

rem ===========================================================================
rem CAU HOI 4: CHE DO WINDOWS UPDATE
rem ===========================================================================
echo [CAU HOI 4/4] Ban muon xu ly Windows Update nhu the nao?
echo   [1] Tat tu dong Update ngam nhung GIU Microsoft Store hoat dong [Khuyen dung]
echo   [2] Khoa cung hoan toan Windows Update
echo   [3] Giu nguyen Windows Update mac dinh
echo.
choice /c 123 /n /m ">> Nhan phim so [1, 2 hoac 3]: "
set "UPD_OPT=%errorlevel%"
echo Da chon [%UPD_OPT%].
echo.

if "%RAM_OPT%"=="1" ( set "PF_INIT=6144" & set "PF_MAX=6144" & set "TRANS_VAL=0" & set "DISABLE_MM=0" )
if "%RAM_OPT%"=="2" ( set "PF_INIT=4096" & set "PF_MAX=4096" & set "TRANS_VAL=0" & set "DISABLE_MM=0" )
if "%RAM_OPT%"=="3" ( set "PF_INIT=4096" & set "PF_MAX=4096" & set "TRANS_VAL=1" & set "DISABLE_MM=1" )
if "%MODE_OPT%"=="3" if not "%RAM_OPT%"=="1" set "TRANS_VAL=1"

cls
echo ===========================================================================
echo   BAT DAU TIEN HANH TOI UU WINDOWS 11 THEO CAU HINH DA CHON...
echo   - Che do su dung : [%MODE_OPT%] [1=Gaming, 2=Van Phong, 3=Full Tinh Nang]
echo   - Muc RAM Option : [%RAM_OPT%] [Pagefile: %PF_INIT%MB - %PF_MAX%MB]
echo   - Menu Chuot Phai: [%CTX_OPT%] [1=Win10 Classic, 2=Win11 Default]
echo   - Windows Update : [%UPD_OPT%]
echo ===========================================================================
echo.

rem ===========================================================================
rem BUOC 0: SAO LUU CAU HINH GOC TRUOC KHI TOI UU [SNAPSHOT BACKUP]
rem ===========================================================================
set "BACKUP_DIR=%~dp0Backup_Cau_Hinh_Goc\%COMPUTERNAME%"
echo [BUOC 0/8] Dang sao luu cau hinh goc cua may vao thu muc Backup...
if exist "%BACKUP_DIR%\Snapshot_Original.json" goto SKIP_BACKUP

mkdir "%BACKUP_DIR%" >nul 2>&1
reg export "HKCU\Control Panel\Desktop" "%BACKUP_DIR%\HKCU_Desktop.reg" /y >nul 2>&1
reg export "HKCU\Control Panel\Mouse" "%BACKUP_DIR%\HKCU_Mouse.reg" /y >nul 2>&1
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "%BACKUP_DIR%\HKCU_VisualEffects.reg" /y >nul 2>&1
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "%BACKUP_DIR%\HKCU_ExplorerAdvanced.reg" /y >nul 2>&1
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "%BACKUP_DIR%\HKCU_Personalize.reg" /y >nul 2>&1
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" "%BACKUP_DIR%\HKCU_Search.reg" /y >nul 2>&1
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "%BACKUP_DIR%\HKCU_BackgroundApps.reg" /y >nul 2>&1
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "%BACKUP_DIR%\HKCU_ContentDelivery.reg" /y >nul 2>&1
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" "%BACKUP_DIR%\HKCU_GameDVR.reg" /y >nul 2>&1
reg export "HKCU\System\GameConfigStore" "%BACKUP_DIR%\HKCU_GameConfigStore.reg" /y >nul 2>&1
reg export "HKCU\Software\Microsoft\GameBar" "%BACKUP_DIR%\HKCU_GameBar.reg" /y >nul 2>&1
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" "%BACKUP_DIR%\HKCU_Run.reg" /y >nul 2>&1
reg export "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" "%BACKUP_DIR%\HKLM_DeviceGuard.reg" /y >nul 2>&1
reg export "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "%BACKUP_DIR%\HKLM_GraphicsDrivers.reg" /y >nul 2>&1
reg export "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "%BACKUP_DIR%\HKLM_Multimedia.reg" /y >nul 2>&1

powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='SilentlyContinue'; $bk=@{}; $bk.Timestamp=(Get-Date).ToString('yyyy-MM-dd HH:mm:ss'); $bk.ComputerName=$env:COMPUTERNAME; $bk.OS='%OS_NAME%'; $svcs=@('SysMain','WSearch','DiagTrack','dmwappushservice','MapsBroker','XblAuthManager','XblGameSave','XboxNetApiSvc','XboxGipSvc','WerSvc','PcaSvc','RetailDemo','Fax','wuauserv','UsoSvc','dosvc','WaaSMedicSvc'); $bk.Services=@{}; foreach($s in $svcs){$sc=Get-CimInstance Win32_Service | Where-Object Name -eq $s; if($sc){$bk.Services[$s]=@{StartMode=$sc.StartMode;State=$sc.State}}}; $tasks=@('\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser','\Microsoft\Windows\Application Experience\ProgramDataUpdater','\Microsoft\Windows\Customer Experience Improvement Program\Consolidator','\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip','\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector','\Microsoft\Windows\Windows Error Reporting\QueueReporting'); $bk.Tasks=@{}; foreach($t in $tasks){$tk=Get-ScheduledTask -TaskName ($t.Split('\')[-1]) | Select-Object -First 1; if($tk){$bk.Tasks[$t]=$tk.State.ToString()}}; $cs=Get-CimInstance Win32_ComputerSystem; $pf=Get-CimInstance Win32_PageFileSetting | Select-Object -First 1; $bk.Pagefile=@{Auto=$cs.AutomaticManagedPagefile;Init=$(if($pf){$pf.InitialSize}else{0});Max=$(if($pf){$pf.MaximumSize}else{0})}; $pwr=(powercfg /getactivescheme); if($pwr -match '([a-f0-9-]{36})'){$bk.PowerScheme=$matches[1]}; $hib=Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Power'; $hibOn=if($null -ne $hib.HibernateEnabled){$hib.HibernateEnabled}elseif($null -ne $hib.HibernateEnabledDefault){$hib.HibernateEnabledDefault}else{1}; $bk.Hibernate=@{Enabled=$hibOn;Type=$hib.HiberFileType}; $bk.Win10ContextMenu=(Test-Path 'HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32'); $bk.MemoryCompression=(Get-MMAgent).MemoryCompression; $bk | ConvertTo-Json -Depth 4 | Set-Content -Path '%BACKUP_DIR%\Snapshot_Original.json' -Encoding UTF8"
echo       - Da luu ban sao cau hinh goc tai: Backup_Cau_Hinh_Goc\%COMPUTERNAME%
goto DONE_BACKUP

:SKIP_BACKUP
echo       - Da co san ban Backup Goc cua may [%COMPUTERNAME%], giu nguyen ban goc de bao ve!

:DONE_BACKUP
powershell -NoProfile -ExecutionPolicy Bypass -Command "Enable-ComputerRestore -Drive 'C:\' -ErrorAction SilentlyContinue; Checkpoint-Computer -Description 'Before_Antigravity_Win11_Optimization' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction SilentlyContinue" >nul 2>&1

rem ===========================================================================
rem BUOC 1: TOI UU CHUNG [TELEMETRY, QUANG CAO, DONG BO NGAM]
rem ===========================================================================
echo [1/8] Dang tat Telemetry theo doi, Quang cao Start Menu va Tac vu ngam...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SilentInstalledAppsEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SoftLandingEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_IrisRecommendations /t REG_DWORD /d 0 /f >nul 2>&1

for %%s in (DiagTrack dmwappushservice MapsBroker RetailDemo Fax) do (
    sc stop "%%s" >nul 2>&1
    sc config "%%s" start= disabled >nul 2>&1
)

for %%t in (
    "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
    "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
    "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
    "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
    "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
    "\Microsoft\Windows\Windows Error Reporting\QueueReporting"
) do (
    schtasks /Change /TN %%t /Disable >nul 2>&1
)

rem ===========================================================================
rem BUOC 2: TOI UU CHUYEN BIET THEO NHU CAU [GAMING / OFFICE / FULL]
rem ===========================================================================
echo [2/8] Dang ap dung goi toi uu chuyen biet theo Nhu cau su dung...

if "%MODE_OPT%"=="1" goto APPLY_GAMING
if "%MODE_OPT%"=="2" goto APPLY_OFFICE
goto APPLY_FULL

:APPLY_GAMING
echo       - [GAMING MODE]: Kich hoat Game Mode, Multimedia Priority, Tat GameDVR...
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul 2>&1

if "%VBS_OPT%"=="1" (
    echo       - [GAMING]: Tat VBS / Core Isolation de tang FPS toi da...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v Enabled /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v EnableVirtualizationBasedSecurity /t REG_DWORD /d 0 /f >nul 2>&1
) else (
    echo       - [GAMING]: Giu nguyen VBS / Core Isolation cho Riot Vanguard / FaceIt...
)

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 0xffffffff /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 10 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1

reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" /v DisableAIDataAnalysis /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v BackgroundModeEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v StartupBoostEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f >nul 2>&1
goto DONE_MODE

:APPLY_OFFICE
echo       - [VAN PHONG MODE]: Toi uu RAM, tat Widgets/Copilot/GameDVR, giu In an ^& OneDrive...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
for %%x in (XblAuthManager XblGameSave XboxNetApiSvc XboxGipSvc) do (
    sc stop "%%x" >nul 2>&1
    sc config "%%x" start= disabled >nul 2>&1
)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" /v DisableAIDataAnalysis /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsRunInBackground /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v BackgroundModeEnabled /t REG_DWORD /d 0 /f >nul 2>&1
goto DONE_MODE

:APPLY_FULL
echo       - [FULL FEATURES MODE]: Giu nguyen Copilot, Widgets, Xbox, OneDrive...
echo         Chi tinh chinh he thong muot ma hon va tat Recall AI ngam.
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" /v DisableAIDataAnalysis /t REG_DWORD /d 1 /f >nul 2>&1

:DONE_MODE

rem ===========================================================================
rem BUOC 3: TUY CHINH MENU CHUOT PHAI & FILE EXPLORER WINDOWS 11
rem ===========================================================================
echo [3/8] Dang toi uu File Explorer va Menu Chuot Phai Windows 11...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSyncProviderNotifications /t REG_DWORD /d 0 /f >nul 2>&1

if "%CTX_OPT%"=="1" (
    echo       - Kich hoat Menu Chuot Phai kieu Windows 10 nhanh gon...
    reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve >nul 2>&1
) else (
    echo       - Giu Menu Chuot Phai mac dinh cua Windows 11...
    reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f >nul 2>&1
)

rem ===========================================================================
rem BUOC 4: TOI UU DICH VU O CUNG [HDD vs SSD & LAPTOP vs PC]
rem ===========================================================================
echo [4/8] Dang kiem tra va toi uu cho o cung [%DETECTED_DISK%]...
echo "%DETECTED_DISK%" | findstr /i "HDD" >nul
if !errorlevel! equ 0 (
    echo       - Phat hien o HDD: Tat SysMain va Windows Search chong 100%% Disk...
    for %%d in (SysMain WSearch) do (
        sc stop "%%d" >nul 2>&1
        sc config "%%d" start= disabled >nul 2>&1
    )
    powercfg /h on >nul 2>&1
    powercfg /h /type reduced >nul 2>&1
) else (
    sc stop "SysMain" >nul 2>&1
    sc config "SysMain" start= disabled >nul 2>&1
    echo "%PC_TYPE%" | findstr /i "Laptop" >nul
    if !errorlevel! equ 0 (
        echo       - Phat hien Laptop dung SSD: Giu Windows Search, thu gon Hibernation bao ve pin...
        powercfg /h on >nul 2>&1
        powercfg /h /type reduced >nul 2>&1
    ) else (
        echo       - Phat hien PC De Ban dung SSD: Giu Windows Search, tat Hibernation giai phong o C...
        powercfg -h off >nul 2>&1
    )
)

rem ===========================================================================
rem BUOC 5: TOI UU HIEU UNG HINH ANH & MEMORY COMPRESSION
rem ===========================================================================
echo [5/8] Dang tinh chinh Visual Effects va Bo nho theo muc RAM...
if "%MODE_OPT%"=="3" (
    echo       - Che do Full Features: Giu nguyen hieu ung chuyen dong muot ma cua Win 11...
) else (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 3 /f >nul 2>&1
    reg add "HKCU\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d "2" /f >nul 2>&1
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul 2>&1
)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d %TRANS_VAL% /f >nul 2>&1

if "%DISABLE_MM%"=="1" (
    echo       - RAM ^>= 16GB: Tat Memory Compression giam tai xung nhip CPU...
    powershell -NoProfile -Command "Disable-MMAgent -mc -ErrorAction SilentlyContinue" >nul 2>&1
)

rem ===========================================================================
rem BUOC 6: KICH HOAT CHE DO NGUON DIEN CHUAN XAC
rem ===========================================================================
echo [6/8] Dang thiet lap Che do Nguon dien Power Plan...
if "%MODE_OPT%"=="1" (
    echo       - [GAMING]: Kich hoat Ultimate Performance Power Plan...
    set "ULT_GUID="
    for /f "tokens=4" %%p in ('powercfg /list ^| findstr /i "Ultimate"') do set "ULT_GUID=%%p"
    if not defined ULT_GUID (
        for /f "tokens=4" %%p in ('powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61') do set "ULT_GUID=%%p"
    )
    if defined ULT_GUID (
        powercfg /setactive !ULT_GUID! >nul 2>&1
    ) else (
        powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
    )
) else (
    echo       - Kich hoat High Performance Power Plan...
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
)

rem ===========================================================================
rem BUOC 7: GO BO BLOATWARE TREN WINDOWS 11 SIEU TOC BANG REGEX
rem ===========================================================================
echo [7/8] Dang don dep Bloatware Windows 11 bang bo loc nhanh...
if "%MODE_OPT%"=="3" (
    echo       - [FULL FEATURES]: Chi go bo cac goi Quang cao rac...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "$regex = 'BingNews|MicrosoftSolitaireCollection|WindowsFeedbackHub'; Get-AppxPackage -AllUsers | Where-Object { $_.Name -match $regex } | Remove-AppxPackage -ErrorAction SilentlyContinue"
) else (
    echo       - Dang go bo cac App chay ngam nang tren Windows 11...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "$regex = 'BingWeather|BingNews|Clipchamp|Microsoft3DViewer|MicrosoftOfficeHub|MicrosoftSolitaireCollection|MixedReality\.Portal|People|PowerAutomateDesktop|SkypeApp|Todos|Wallet|WindowsFeedbackHub|WindowsMaps|ZuneMusic|ZuneVideo'; Get-AppxPackage -AllUsers | Where-Object { $_.Name -match $regex } | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -match $regex } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue"
)

rem ===========================================================================
rem BUOC 8: THIET LAP PAGEFILE & WINDOWS UPDATE
rem ===========================================================================
echo [8/8] Dang cau hinh RAM ao [Pagefile: %PF_INIT%MB - %PF_MAX%MB] va Windows Update...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='SilentlyContinue'; $cs = Get-CimInstance -ClassName Win32_ComputerSystem; if ($cs.AutomaticManagedPagefile) { Set-CimInstance -InputObject $cs -Property @{AutomaticManagedPagefile=$false} | Out-Null }; $pf = Get-CimInstance -ClassName Win32_PageFileSetting | Where-Object { $_.Name -like 'C:*' }; if ($pf) { Set-CimInstance -InputObject $pf -Property @{InitialSize=%PF_INIT%; MaximumSize=%PF_MAX%} | Out-Null } else { New-CimInstance -ClassName Win32_PageFileSetting -Property @{Name='C:\pagefile.sys'; InitialSize=%PF_INIT%; MaximumSize=%PF_MAX%} | Out-Null }"

if "%UPD_OPT%"=="1" (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 2 /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v AutoDownload /t REG_DWORD /d 2 /f >nul 2>&1
    sc stop "wuauserv" >nul 2>&1
    sc config "wuauserv" start= demand >nul 2>&1
)
if "%UPD_OPT%"=="2" (
    for %%u in (wuauserv UsoSvc dosvc) do (
        sc stop "%%u" >nul 2>&1
        sc config "%%u" start= disabled >nul 2>&1
    )
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 1 /f >nul 2>&1
)

echo.
echo ===========================================================================
echo    HOAN TAT TOI UU WINDOWS 11!
echo    - Ban sao luu cau hinh goc da duoc luu tai: Backup_Cau_Hinh_Goc\%COMPUTERNAME%
echo    - Nhan phim bat ky de KHOI DONG LAI MAY NGAY...
echo ===========================================================================
pause >nul
shutdown /r /t 0
