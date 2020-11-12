@echo off
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)

echo "=== Stopping WebClient ==="
sc stop WebClient

:: See https://support.netdocuments.com/hc/en-us/articles/205212850-WebDAV-as-a-Mapped-Drive
echo "=== Configure WebClient to Autostart ==="
sc config WebClient start= auto

:: See http://www.geeks-on-wheels.net/solved-unable-to-save-remember-password-for-mapped-webdav-folder/
echo "=== Enable WebDav Drive Mounts ==="
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WebClient\Parameters" /v "BasicAuthLevel" /t REG_DWORD /d 2 /f
echo "=== Allow Credentials for LMR-Cloud ==="
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WebClient\Parameters" /v AuthForwardServerList /t REG_MULTI_SZ /d "https://cloud.lmr-hh.de" /f

echo "=== Do not Mount Drives on Boot"
:: See https://www.windows-faq.de/2018/06/02/es-konnten-nicht-alle-netzlaufwerke-wiederhergestellt-werden/
reg add "HKLM\SYSTEM\CurrentControlSet\Control\NetworkProvider" /v RestoreConnection /t REG_DWORD /d 0 /f

echo "=== Starting WebClient ==="
sc start WebClient

pause
