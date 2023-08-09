# this is probably not a good idea to use for security reasons
# PoC, could be refined.
# Author: Hunter Harkness

$CompName = Read-Host -Prompt "Hostname:"
$cred = Get-Credential -Message "Authenticate with administrator account"

Invoke-Command -ComputerName $CompName -Credential $cred -Authentication Kerberos -ScriptBlock {

$UserDIR = Get-CimInstance -ClassName Win32_ComputerSystem | ${_.UserName}
# remove DIR\ from username
$User = $UsirDIR.Substring(4)
$ExecuteTime = (Get-Date) + (New-TimeSpan -Seconds 30)

$Action = New-SchedulefTaskAction -Execute "PowerShell.exe" -Argument "whoami; Start-Sleep -Seconds 10"
$Trigger = New-ScheduledTaskTrigger -Once -At $ExecuteTime

Register-ScheduledTask -User $User -Action $Action -Trigger $Trigger -TaskName "RemoteTask"
}

Start-Sleep -Seconds 90

Invoke-Command -ComputerName $CompName -Credential $cred -Authentication Kerberos -ScriptBlock {
Unregister-ScheduledTask -TaskName "RemoteTask" -Confirm:$false
}
