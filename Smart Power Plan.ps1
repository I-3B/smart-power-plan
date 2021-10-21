#ask for admin permission
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-windowstyle hidden -NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $args" -Verb RunAs; exit }
#read configuration 
$lines = Get-Content "$env:USERPROFILE/Documents/Smart Power Plan-config.txt" ;
$linesCount = $lines.Length;
$linesCounter = 0;
$configFound = $false;
$processPath = "";
$ppForApp = "";
$ppAfterApp = "";
$appCallName = $args[0];
while (($linesCounter -lt $linesCount) -or !$configFound) {
    if ($lines[$linesCounter].Length -eq 0) {
        $linesCounter++;
    }
    elseif ($lines[$linesCounter].contains("[") -and $lines[$linesCounter].contains( "]") ) {
        $appID = [regex]::match($lines[$linesCounter++] , '\[(.*)\]').Groups[1].Value;
        if ($appID -eq $appCallName) {
            $configFound = $true;
            1..3 | ForEach-Object {  
                $configName = $lines[$linesCounter].split('=')[0].trim();
                $config = $lines[$linesCounter++].split('=')[1].trim();
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
        }
        else {
            $linesCounter += 3;
        }
    }
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
