# Simple Trigger job that takes a JSON body and sends an email
$obj = Get-Content -Raw $req  | convertfrom-json

# Get the SAS Token from SAS Token Function
$uri = "https://wakafunctions.azurewebsites.net/api/SasTokenCSharp1"
$webhookdata = @"
{"ContainerName": "$($obj.ContainerName)","BlobName": "$($obj.BlobName)","Permission": "$($obj.Permission)"}
"@
$response = Invoke-WebRequest -Method Post -Uri $uri -Body $webhookdata -Headers @{"Content-Type"="application/json"} -usebasicparsing
$link = "https://wakastorageforfunctions.blob.core.windows.net/$($obj.ContainerName)/$($obj.BlobName)$($response.content)"

# Get the SAS Token from SAS Token Function
$uri = "https://wakafunctions.azurewebsites.net/api/SasTokenCSharp1"
$webhookdata = @"
{"ContainerName": "$($obj.ContainerName + "-md")","BlobName": "$($obj.BlobName)","Permission": "$($obj.Permission)"}
"@
$response = Invoke-WebRequest -Method Post -Uri $uri -Body $webhookdata -Headers @{"Content-Type"="application/json"} -usebasicparsing
$link1 = "https://wakastorageforfunctions.blob.core.windows.net/$($obj.ContainerName + "-md")/$($obj.BlobName)$($response.content)"

# Get the SAS Token from SAS Token Function
$uri = "https://wakafunctions.azurewebsites.net/api/SasTokenCSharp1"
$webhookdata = @"
{"ContainerName": "$($obj.ContainerName + "-sm")","BlobName": "$($obj.BlobName)","Permission": "$($obj.Permission)"}
"@
$response = Invoke-WebRequest -Method Post -Uri $uri -Body $webhookdata -Headers @{"Content-Type"="application/json"} -usebasicparsing
$link2 = "https://wakastorageforfunctions.blob.core.windows.net/$($obj.ContainerName + "-sm")/$($obj.BlobName)$($response.content)"


Out-File -Encoding Ascii -FilePath $res -inputObject "$link" 

# Send an email with links
$uri = "https://wakafunctions.azurewebsites.net/api/SendEmail"
$webhookdata1 = @"
{
"webhookdata": {"to":"$($obj.email)","subject":"Access to Resized Images","Body":"You recently uploaded image $($obj.BlobName) and here are the links: <br> <br>  <a href=$($link)>Original Image</a> <br> <br> <a href=$($link1)>Medium Image</a> <br> <br> <a href=$($link2)>Small Image</a>"}}
"@

Invoke-WebRequest -Method Post -Uri $uri -Body $webhookdata1 -usebasicparsing
