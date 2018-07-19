
$AppProps = convertfrom-stringdata (get-content ./ReportVersion.properties -raw)
$currentPath = $((get-Item -Path ".\").FullName)
$outputFileName = $currentPath + '\' + $AppProps.ReportN + " " + $appProps.ReportV + '.zip'

Write-Host $currentPath
Write-Host $outputFileName

$quotedPath = '"' + $currentPath + '"'

Add-Type -Assembly System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($currentPath, $outputFileName)
