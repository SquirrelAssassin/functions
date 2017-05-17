#hi there this is a test 
# Simple Trigger job that takes a JSON body and sends an email
$obj = Get-Content -Raw $req  | convertfrom-json
Write-Output ($obj.webhookdata | out-string)
$credname = $env:usr
$credpwd = ConvertTo-SecureString $env:pwd -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $credname, $credpwd
Send-MailMessage -To $($obj.webhookdata.to) -Subject $($obj.webhookdata.subject) -Body $($obj.webhookdata.body)  -UseSsl -Port 587 -SmtpServer 'smtp.office365.com' -From $env:usr -Credential $Cred -BodyAsHtml
