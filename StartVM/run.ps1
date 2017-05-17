# Define Variables
$Server = 's2016'
$RG = 'servers'
$Email = 'spr@properevents.org'

# Send an email
$uri = "https://wakafunctions.azurewebsites.net/api/SendEmail"
$webhookdata = @"
{"webhookdata": {"to":"$($Email)","subject":"VM: $($Server), is powering on time to start work!","Body":"VM: $($Server), is powering on!"}}
"@
Invoke-WebRequest -Method Post -Uri $uri -Body $webhookdata -usebasicparsing


# Start a VM
Write-Output "PowerShell Timer trigger function executed at:$(get-date)";
$credname = $env:usr
$credpwd = ConvertTo-SecureString $env:pwd -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $credname, $credpwd
Login-AzureRmAccount -Credential $cred -SubscriptionId $env:subid
Write-Output "Changing the state of the VM:$(get-date)";
$start = Start-AzureRmVM -Name $Server -ResourceGroupName $RG