#Requires -Version 3

Param(
  [Parameter(Mandatory=$false)][string]$deployPath = ".\"
)

# Recupera Nome report e versione dal file Report.properties
$AppProps = convertfrom-stringdata (get-content ./Report.properties -raw)
if ([string]::IsNullOrEmpty($AppProps.ReportName) -or [string]::IsNullOrEmpty($AppProps.ReportVersion)) {
    Write-Host "File ./Report.properties mancante o non valido."
    exit(-1)
}
$outputPath = $((get-Item -Path $deployPath).FullName)
$zipName = $AppProps.ReportName + " " + $appProps.ReportVersion + '.zip'
$outputFileName = $outputPath + '\' + $zipName

# Crea una cartella temporanea
$parent = [System.IO.Path]::GetTempPath()
$name = [System.IO.Path]::GetRandomFileName()
$tempDirectory = New-Item -ItemType Directory -Path (Join-Path $parent $name) -ErrorAction stop
# Copia i file da mettere nello zip nella cartella temporanea
Get-ChildItem $currentPath -Include "*.jasper", "*.jrxml", "*.properties" -Recurse | Select -ExpandProperty FullName | Copy-Item -Destination $tempDirectory

# Crea zip con il contenuto della cartella (in una cartella temporanea)
$tempFile = [System.IO.Path]::GetTempPath() + [System.IO.Path]::GetRandomFileName()
Add-Type -Assembly System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($tempDirectory, $tempFile)

# Sposta il file zip nella cartella corrente
Move-Item $tempFile $outputFileName -ErrorAction stop

write-host $zipName" creato in "$outputPath

# Cancella la cartella temporanea
Remove-Item -Recurse $tempDirectory
