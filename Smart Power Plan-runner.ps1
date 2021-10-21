$fileExists = Test-Path "$env:USERPROFILE\Documents\Smart Power Plan-config.txt" -PathType Leaf
$lines = Get-Content "$env:USERPROFILE/Documents/Smart Power Plan-config.txt";
$linesCount = $lines.Length;

if ($false -eq $fileExists -or $linesCount -lt 4 ) {
    Write-output "Starting Configuration... if you Want to edit your configuration or add more applications in it you can do so in your Document folder in the file with the name 'Smart Power plan-config.txt'"
    $app = Read-Host -Prompt 'Your app path, e.g., C:\Program Files\Google\Chrome\Application\chrome.exe ';
    $appName = Read-Host -Prompt 'Your app name (not necessarily the name of the app it can be anything)'
    $appPlan = Read-Host -Prompt 'The power plan you want to use while the app is running, e.g., Power saver ';
    $afterPlan = Read-Host -Prompt 'The power plan after the app is terminated, e.g., Balanced ' ;

    "[1] - $appName
application full path = $app
power plan while the application is running = $appPlan
power plan after the application terminate = $afterPlan" | Out-File "$env:USERPROFILE\Documents\Smart Power Plan-config.txt" 
}
$lines = Get-Content "$env:USERPROFILE/Documents/Smart Power Plan-config.txt";
$linesCount = $lines.Length;
if ( $linesCount -eq 4) {
    $appOrder = 1
}
else {
    
    foreach ($line in $lines) {
        if ([regex]::match($line, "\[(.*)\] - (.*)").success) {
            Write-Output $line
        }
    }
    $appOrder = Read-Host -Prompt "Select The app";
}
powershell.exe -file "Smart Power Plan.ps1" $appOrder

# -noexit -ArgumentList $appOrder 