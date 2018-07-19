
$AppProps = convertfrom-stringdata (get-content ./ReportVersion.properties -raw)
$currentPath = $((get-Item -Path ".\").FullName)
$outputFileName = $currentPath + '\' + $AppProps.ReportN + " " + $appProps.ReportV + '.zip'

Write-Host $currentPath
Write-Host $outputFileName

$quotedPath = '"' + $currentPath + '"'

$tempFile = [System.IO.Path]::GetTempPath() + [System.IO.Path]::GetRandomFileName()

Add-Type -Assembly System.IO.Compression.FileSystem

[System.IO.Compression.ZipFile]::CreateFromDirectory($currentPath, $tempFile)

Move-Item $tempFile $outputFileName