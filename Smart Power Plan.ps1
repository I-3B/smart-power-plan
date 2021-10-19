param([switch]$Elevated)

#read configuration 
$lines = Get-Content "$env:USERPROFILE/Documents/Smart Power Plan-config.txt" ;
foreach ($line in $lines) {
    $configName = $line.split('=')[0].trim();
    $config = $line.split('=')[1].trim();
    switch ($configName) {
        "application full path" { 
            $processPath = $config
        }
        "power plan while the application is running" {
            $ppForApp = $config;
        }
        "power plan after the application terminate" {
            $ppAfterApp = $config;
        }
        Default {
            Write-Error "Something went wrong with the config file, make sure you wrote it correctly."
        }
        
    }
}

#gain admin rights
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false) {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    }
    else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-windowstyle hidden -noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
     
}

$processName = [io.path]::GetFileNameWithoutExtension($processPath)
$ProcessActive = Get-Process $processName -ErrorAction SilentlyContinue
#check if app isn't already open
if ($null -eq $ProcessActive) {
    Start-Process $processPath 
}
#change power plan
$p = Get-CimInstance -Name root\cimv2\power -Class win32_PowerPlan -Filter "ElementName = '$ppForApp'"      
powercfg /setactive ([string]$p.InstanceID).Replace("Microsoft:PowerPlan\{", "").Replace("}", "")
$app = get-process $processName
$app.waitforexit()
$p = Get-CimInstance -Name root\cimv2\power -Class win32_PowerPlan -Filter "ElementName = '$ppAfterApp'"      
powercfg /setactive ([string]$p.InstanceID).Replace("Microsoft:PowerPlan\{", "").Replace("}", "")
