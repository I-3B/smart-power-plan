$fileExists = Test-Path "$env:USERPROFILE\Documents\Smart Power Plan-config.txt" -PathType Leaf
if ($false -eq $fileExists ) {
    Write-output "Starting Cofiguration... if you Want to edit your configuration you can do so in your Document folder in the file with the name 'Smart Power plan-config.txt'"
    $app = Read-Host -Prompt 'Your app path, e.g., C:\Program Files\Google\Chrome\Application\chrome.exe ';
    $appPlan = Read-Host -Prompt 'The power plan you want to use while the app is running, e.g., Power saver ';
    $afterPlan = Read-Host -Prompt 'The power plan after the app is terminated, e.g., Balanced ' ;

    "application full path = $app
power plan while the application is running = $appPlan
power plan after the application terminate = $afterPlan" | Out-File "$env:USERPROFILE\Documents\Smart Power Plan-config.txt" 
}
Powershell.exe -File "Smart Power Plan.ps1"