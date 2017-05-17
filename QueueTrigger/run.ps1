# Get the item out of the queue
$in = Get-Content $triggerInput
$obj = $in | convertfrom-json

#do something with the message from the queue
$guid = $([guid]::NewGuid())


#now trigger an email from the message

$uri = "https://wakafunctions.azurewebsites.net/api/SendEmail"
$webhookdata = @"
{
"webhookdata": {
"to":"$($obj.email)",
"subject":"Hooray! order# $guid was just processed",
"Body":"$($obj.name.first), your order was just processed and should arrive at $($obj.company) shortly!"
}
}
"@
$response = Invoke-WebRequest -Method Post -Uri $uri -Body $webhookdata -usebasicparsing
write-output $response
