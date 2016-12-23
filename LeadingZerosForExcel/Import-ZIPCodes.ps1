Set-Location C:\Users\andy\Documents\GitHub\BlogSnippets\LeadingZerosForExcel;
#https://www.aggdata.com/node/86
#$wr = Invoke-WebRequest -Uri https://www.aggdata.com/download_sample.php?file=us_postal_codes.zip
Expand-Archive -Path .\us_postal_codes.zip -DestinationPath .
$ZipCodeData = Import-Csv -Path .\us_postal_codes.csv;
$ZipCodeData |select -first 10 |Export-Excel -path "\\VBOXSVR\Share_to_VMWare\leadingzeroes.xlsx";
$ZipCodeData |Select-Object -first 10 -Property @{name="Postal Code";Expression={"'$($_.'Postal Code')"}},"Place Name",State,"State Abbreviation",County,Latitude,Longitude |Export-Excel -Path "\\VBOXSVR\Share_to_VMWare\leadingzeroesfixed.xlsx";
Remove-Variable ZipcodeData