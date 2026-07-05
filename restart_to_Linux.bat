@echo off
::DK

:: find Ubuntu GUI and set as acticve
setlocal EnableDelayedExpansion

set "UBUNTU_GUID="

for /f "delims=" %%L in ('bcdedit /enum firmware') do (
    set "L=%%L"

    echo(!L! | findstr /b /c:"identifier" >nul
    if not errorlevel 1 (
        for %%A in (!L!) do set "UBUNTU_GUID=%%A"
    )

    echo(!L! | findstr /b /c:"description" >nul
    if not errorlevel 1 (
        echo(!L! | findstr /i /c:"ubuntu" >nul
        if not errorlevel 1 (
            echo Ubuntu GUID: !UBUNTU_GUID!
            goto :next
        )
    )
)




:next
:: --------------------------------------
:: Set Ubuntu as default boot via BCD
:: --------------------------------------
:: Ubuntu firmware entry GUID from backup
set UBUNTU_GUID=!UBUNTU_GUID!

:: Windows Boot Manager GUID (fallback)
set WIN_GUID={bootmgr}

:: Set Ubuntu as default firmware boot
bcdedit /set {fwbootmgr} default %UBUNTU_GUID%

:: Set display order: Ubuntu first, Windows second
bcdedit /set {fwbootmgr} displayorder %UBUNTU_GUID% %WIN_GUID%

:: Optional: set boot menu timeout 
bcdedit /timeout 2

:: --------------------------------------
:: Confirmation before restart
:: --------------------------------------

set "VBS=%TEMP%\confirm_restart.vbs"

> "%VBS%" echo Set WshShell = CreateObject("WScript.Shell")
>>"%VBS%" echo answer = MsgBox("Ubuntu has been configured as the next boot option." ^& vbCrLf ^& vbCrLf ^& "Restart the computer now?", vbQuestion + vbYesNo + vbDefaultButton1, "Cherry")
>>"%VBS%" echo If answer = vbYes Then
>>"%VBS%" echo   WshShell.Run "%SystemRoot%\System32\shutdown.exe /r /t 0", 0, False
>>"%VBS%" echo End If

cscript //nologo "%VBS%"
del "%VBS%"

exit /b
