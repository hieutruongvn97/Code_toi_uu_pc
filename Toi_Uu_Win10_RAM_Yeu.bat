@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title Cong Cu Toi Uu Windows 10 Thong Minh Theo Cau Hinh
color 0B

rem --- TU DONG XIN QUYEN ADMINISTRATOR ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Dang yeu cau quyen Administrator...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

rem --- TU DONG NHAN DIEN CAU HINH HIEN TAI DE GOI Y ---
cls
echo Dang kiem tra thong tin phan cung may tinh, vui long doi...

set "OS_NAME=Windows 10"
set "CPU_NAME=Unknown CPU"
set "GPU_NAME=Standard VGA"
set "DETECTED_RAM=4"
set "DETECTED_DISK=HDD/SSD"
set "PC_TYPE=PC De Ban"

for /f "tokens=1,* delims==" %%a in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='SilentlyContinue'; $cv=Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'; $cap=(Get-CimInstance Win32_OperatingSystem).Caption; $ver=if($cv.DisplayVersion){$cv.DisplayVersion}else{$cv.ReleaseId}; Write-Output ('OS_NAME='+$cap+' - Version '+$ver+' [Build '+$cv.CurrentBuild+'.'+$cv.UBR+']'); Write-Output ('CPU_NAME='+(Get-CimInstance Win32_Processor | Select-Object -First 1).Name.Trim()); Write-Output ('GPU_NAME='+((Get-CimInstance Win32_VideoController | ForEach-Object {$_.Name}) -join ' + ')); Write-Output ('DETECTED_RAM='+[math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory/1GB)); $dn=(Get-Partition -DriveLetter C).DiskNumber; $d=if($null -ne $dn){Get-PhysicalDisk | Where-Object DeviceId -eq $dn}else{Get-PhysicalDisk | Select-Object -First 1}; $dt=if($d.MediaType -and $d.MediaType -ne 'Unspecified'){$d.MediaType+' - '+$d.FriendlyName}else{'Disk - '+$d.FriendlyName}; Write-Output ('DETECTED_DISK='+$dt); $bat=if(Get-CimInstance Win32_Battery){'Laptop - Co Pin'}else{'PC De Ban - Desktop'}; Write-Output ('PC_TYPE='+$bat)"') do (
    set "%%a=%%b"
)

cls
echo ===========================================================================
echo       CONG CU TOI UU WINDOWS 10 THEO CAU HINH MAY [CUSTOMIZER PRO]
echo ===========================================================================
echo   [Thong tin may hien tai phat hien duoc]:
echo   - Ten may tinh   : %COMPUTERNAME% [%PC_TYPE%]
echo   - He dieu hanh   : %OS_NAME%
echo   - Vi xu ly CPU   : %CPU_NAME%
echo   - Card do hoa    : %GPU_NAME%
echo   - Dung luong RAM : Khoang %DETECTED_RAM% GB
echo   - O cung cai Win : %DETECTED_DISK%
echo ===========================================================================
echo.

rem ======================================================================
rem CAU HOI 1: CHON MUC RAM
rem ======================================================================
echo [CAU HOI 1/3] May tinh nay co dung luong RAM la bao nhieu?
echo   [1] 4 GB  - Toi uu triet de, Pagefile 6GB, tat Transparency
echo   [2] 6 GB  - Toi uu can bang, Pagefile 4GB, tat Transparency
echo   [3] 8 GB  - Toi uu muot ma, Pagefile 4GB, giu Transparency
echo   [4] Tren 8 GB [12GB/16GB+] - Pagefile 4GB, tat nen RAM giam tai CPU
echo.
choice /c 1234 /n /m ">> Nhan phim so [1, 2, 3 hoac 4] de chon muc RAM: "
set "RAM_OPT=%errorlevel%"
echo Da chon muc [%RAM_OPT%].
echo.

if "%RAM_OPT%"=="1" ( set "PF_INIT=6144" & set "PF_MAX=6144" & set "TRANS_VAL=0" & set "DISABLE_MM=0" )
if "%RAM_OPT%"=="2" ( set "PF_INIT=4096" & set "PF_MAX=4096" & set "TRANS_VAL=0" & set "DISABLE_MM=0" )
if "%RAM_OPT%"=="3" ( set "PF_INIT=4096" & set "PF_MAX=4096" & set "TRANS_VAL=1" & set "DISABLE_MM=0" )
if "%RAM_OPT%"=="4" ( set "PF_INIT=4096" & set "PF_MAX=4096" & set "TRANS_VAL=1" & set "DISABLE_MM=1" )

rem ======================================================================
rem CAU HOI 2: CHON LOAI O CUNG
rem ======================================================================
echo [CAU HOI 2/3] O cung cai Windows [O C:] la HDD hay SSD?
echo   [1] O cung HDD - Chong 100%% Disk: Tat SysMain ^& Search, giu Fast Startup
echo   [2] O cung SSD - Giu Windows Search de tim file nhanh, toi uu Hibernation
echo.
choice /c 12 /n /m ">> Nhan phim so [1 hoac 2] de chon loai o cung: "
set "DISK_OPT=%errorlevel%"
echo Da chon muc [%DISK_OPT%].
echo.

rem ======================================================================
rem CAU HOI 3: TUY CHON WINDOWS UPDATE
rem ======================================================================
echo [CAU HOI 3/3] Ban muon xu ly Windows Update nhu the nao?
echo   [1] Tat tu dong Update nhung GIU LAI Microsoft Store [Khuyen dung]
echo   [2] Tat han va khoa cung Windows Update [Khong dung Store]
echo   [3] Giu nguyen Windows Update mac dinh
echo.
choice /c 123 /n /m ">> Nhan phim so [1, 2 hoac 3] de chon che do Update: "
set "UPD_OPT=%errorlevel%"
echo Da chon muc [%UPD_OPT%].
echo.

cls
echo ===========================================================================
echo   TONG HOP CAU HINH TOI UU DA CHON:
echo   - Muc RAM option     : [%RAM_OPT%] - Pagefile: %PF_INIT%MB - %PF_MAX%MB
echo   - Loai o cung option : [%DISK_OPT%] [1=HDD, 2=SSD] - Loai may: %PC_TYPE%
echo   - Che do Update      : [%UPD_OPT%] [1=Tat Auto/Giu Store, 2=Khoa han, 3=Giu nguyen]
echo ===========================================================================
echo.

rem ======================================================================
rem BUOC 0: SAO LUU CAU HINH GOC TRUOC KHI TOI UU [SNAPSHOT BACKUP]
rem ======================================================================
set "BACKUP_DIR=%~dp0Backup_Cau_Hinh_Goc\%COMPUTERNAME%"
echo [BUOC 0/8] Dang sao luu cau hinh goc cua may vao thu muc Backup...
if exist "%BACKUP_DIR%\Snapshot_Original.json" goto SKIP_BACKUP

mkdir "%BACKUP_DIR%" >nul 2>&1
reg export "HKCU\Control Panel\Desktop" "%BACKUP_DIR%\HKCU_Desktop.reg" /y >nul 2>&1
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

powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='SilentlyContinue'; $bk=@{}; $bk.Timestamp=(Get-Date).ToString('yyyy-MM-dd HH:mm:ss'); $bk.ComputerName=$env:COMPUTERNAME; $bk.OS='%OS_NAME%'; $svcs=@('SysMain','WSearch','DiagTrack','dmwappushservice','MapsBroker','XblAuthManager','XblGameSave','XboxNetApiSvc','XboxGipSvc','WerSvc','PcaSvc','RetailDemo','Fax','wuauserv','UsoSvc','dosvc','WaaSMedicSvc'); $bk.Services=@{}; foreach($s in $svcs){$sc=Get-CimInstance Win32_Service | Where-Object Name -eq $s; if($sc){$bk.Services[$s]=@{StartMode=$sc.StartMode;State=$sc.State}}}; $tasks=@('\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser','\Microsoft\Windows\Application Experience\ProgramDataUpdater','\Microsoft\Windows\Customer Experience Improvement Program\Consolidator','\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip','\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector','\Microsoft\Windows\Windows Error Reporting\QueueReporting'); $bk.Tasks=@{}; foreach($t in $tasks){$tk=Get-ScheduledTask -TaskName ($t.Split('\')[-1]) | Select-Object -First 1; if($tk){$bk.Tasks[$t]=$tk.State.ToString()}}; $cs=Get-CimInstance Win32_ComputerSystem; $pf=Get-CimInstance Win32_PageFileSetting | Select-Object -First 1; $bk.Pagefile=@{Auto=$cs.AutomaticManagedPagefile;Init=$(if($pf){$pf.InitialSize}else{0});Max=$(if($pf){$pf.MaximumSize}else{0})}; $pwr=(powercfg /getactivescheme); if($pwr -match '([a-f0-9-]{36})'){$bk.PowerScheme=$matches[1]}; $hib=Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Power'; $hibOn=if($null -ne $hib.HibernateEnabled){$hib.HibernateEnabled}elseif($null -ne $hib.HibernateEnabledDefault){$hib.HibernateEnabledDefault}else{1}; $bk.Hibernate=@{Enabled=$hibOn;Type=$hib.HiberFileType}; $bk.MemoryCompression=(Get-MMAgent).MemoryCompression; $bk | ConvertTo-Json -Depth 4 | Set-Content -Path '%BACKUP_DIR%\Snapshot_Original.json' -Encoding UTF8"
echo       - Da luu ban sao cau hinh goc tai: Backup_Cau_Hinh_Goc\%COMPUTERNAME%
goto DONE_BACKUP

:SKIP_BACKUP
echo       - Da co san ban Backup Goc cua may [%COMPUTERNAME%], giu nguyen ban goc de bao ve!

:DONE_BACKUP
powershell -NoProfile -ExecutionPolicy Bypass -Command "Enable-ComputerRestore -Drive 'C:\' -ErrorAction SilentlyContinue; Checkpoint-Computer -Description 'Before_Antigravity_Win10_Optimization' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction SilentlyContinue" >nul 2>&1

rem ======================================================================
rem BAT DAU THUC THI CAC LENH TOI UU
rem ======================================================================

rem 1. Tat Background Apps, Quang cao ngam & Edge chay ngam
echo [1/8] Dang tat Ung dung chay ngam, Edge Background va Quang cao...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsRunInBackground /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BackgroundAppGlobalToggle /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v BackgroundModeEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v StartupBoostEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SilentInstalledAppsEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SoftLandingEnabled /t REG_DWORD /d 0 /f >nul 2>&1

rem 2. Toi uu Services & Scheduled Tasks theo loai O CUNG
echo [2/8] Dang toi uu Services va Tac vu ngam theo loai o cung...
for %%s in (SysMain DiagTrack dmwappushservice MapsBroker XblAuthManager XblGameSave XboxNetApiSvc XboxGipSvc RetailDemo Fax) do (
    sc stop "%%s" >nul 2>&1
    sc config "%%s" start= disabled >nul 2>&1
)
if "%DISK_OPT%"=="1" (
    echo       - Phat hien tuy chon HDD: Dang tat Windows Search de chong 100%% Disk...
    sc stop "WSearch" >nul 2>&1
    sc config "WSearch" start= disabled >nul 2>&1
) else (
    echo       - Phat hien tuy chon SSD: Giu lai Windows Search o che do Automatic...
    sc config "WSearch" start= delayed-auto >nul 2>&1
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

rem 3. Tat Game Bar, Game DVR, News & Interests va OneDrive Startup
echo [3/8] Dang tat Game Bar, News ^& Interests va OneDrive chay ngam...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" /v ShellFeedsTaskbarViewMode /t REG_DWORD /d 2 /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f >nul 2>&1

rem 4. Toi uu Visual Effects & Transparency theo muc RAM
echo [4/8] Dang toi uu hieu ung hinh anh theo muc RAM...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d "2" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d %TRANS_VAL% /f >nul 2>&1

if "%DISABLE_MM%"=="1" (
    echo       - RAM tren 8GB: Tat Memory Compression de giam tai cho CPU...
    powershell -NoProfile -Command "Disable-MMAgent -mc -ErrorAction SilentlyContinue" >nul 2>&1
)

rem 5. Toi uu Nguon dien & Hibernation/Fast Startup
echo [5/8] Dang cau hinh Nguon dien High Performance va Che do khoi dong...
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
if "%DISK_OPT%"=="1" (
    echo       - O cung HDD: Bat Fast Startup thu gon [Tiet kiem 50%% dung luong, bat may nhanh]...
    powercfg /h on >nul 2>&1
    powercfg /h /type reduced >nul 2>&1
) else (
    echo "%PC_TYPE%" | findstr /i "Laptop" >nul
    if !errorlevel! equ 0 (
        echo       - Phat hien Laptop dung SSD: Giu Hibernation thu gon de bao ve du lieu khi het pin...
        powercfg /h on >nul 2>&1
        powercfg /h /type reduced >nul 2>&1
    ) else (
        echo       - Phat hien PC De Ban dung SSD: Tat han Hibernation giai phong 4GB-25GB o C...
        powercfg -h off >nul 2>&1
    )
)

rem 6. Go bo Bloatware sieu toc bang Regex Filter
echo [6/8] Dang go bo Bloatware chay ngam bang bo loc nhanh...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$regex = 'BingWeather|BingNews|Microsoft3DViewer|MicrosoftOfficeHub|MicrosoftSolitaireCollection|MixedReality\.Portal|People|SkypeApp|Wallet|WindowsAlarms|WindowsFeedbackHub|WindowsMaps|WindowsSoundRecorder|XboxApp|XboxGameOverlay|XboxIdentityProvider|XboxSpeechToTextOverlay|YourPhone|ZuneMusic|ZuneVideo'; Get-AppxPackage -AllUsers | Where-Object { $_.Name -match $regex } | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -match $regex } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue"

rem 7. Thiet lap Virtual Memory [Pagefile] theo muc RAM da chon
echo [7/8] Dang cau hinh RAM ao [Pagefile: %PF_INIT%MB - %PF_MAX%MB]...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='SilentlyContinue'; $cs = Get-CimInstance -ClassName Win32_ComputerSystem; if ($cs.AutomaticManagedPagefile) { Set-CimInstance -InputObject $cs -Property @{AutomaticManagedPagefile=$false} | Out-Null }; $pf = Get-CimInstance -ClassName Win32_PageFileSetting | Where-Object { $_.Name -like 'C:*' }; if ($pf) { Set-CimInstance -InputObject $pf -Property @{InitialSize=%PF_INIT%; MaximumSize=%PF_MAX%} | Out-Null } else { New-CimInstance -ClassName Win32_PageFileSetting -Property @{Name='C:\pagefile.sys'; InitialSize=%PF_INIT%; MaximumSize=%PF_MAX%} | Out-Null }"

rem 8. Xu ly Windows Update theo tuy chon
echo [8/8] Dang ap dung tuy chon Windows Update...
if "%UPD_OPT%"=="1" (
    echo       - Dang chan Auto Update nhung giu Microsoft Store hoat dong...
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 2 /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v AutoDownload /t REG_DWORD /d 2 /f >nul 2>&1
    sc stop "wuauserv" >nul 2>&1
    sc config "wuauserv" start= demand >nul 2>&1
)
if "%UPD_OPT%"=="2" (
    echo       - Dang khoa cung toan bo dich vu Windows Update...
    for %%u in (wuauserv UsoSvc dosvc) do (
        sc stop "%%u" >nul 2>&1
        sc config "%%u" start= disabled >nul 2>&1
    )
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 1 /f >nul 2>&1
)
if "%UPD_OPT%"=="3" (
    echo       - Giu nguyen Windows Update mac dinh.
)

echo.
echo ===========================================================================
echo    HOAN TAT TOI UU!
echo    - Ban sao luu cau hinh goc da duoc luu tai: Backup_Cau_Hinh_Goc\%COMPUTERNAME%
echo    - Nhan phim bat ky de KHOI DONG LAI MAY NGAY...
echo ===========================================================================
pause >nul
shutdown /r /t 0
