#Requires -Version 3

<#
.NOTES
    Version: 1.1.0
#>

Param(
  [Parameter(Mandatory=$false)][string]$DeployPath = ".\"
)

# Recupera Nome report e versione dal file Report.properties
$AppProps = convertfrom-stringdata (get-content ./Report.properties -raw -ErrorAction SilentlyContinue)
if ([string]::IsNullOrEmpty($AppProps.ReportName) -or [string]::IsNullOrEmpty($AppProps.ReportVersion)) {
    Write-Host "File ./Report.properties mancante o non valido."
    exit(-1)
}

$fullDeployPath = $((get-Item -Path $DeployPath).FullName)
$zipName = $AppProps.ReportName + " " + $appProps.ReportVersion + '.zip'
$fullDeployFileName = join-Path $fullDeployPath $zipName

# Crea una cartella temporanea
$parent = [System.IO.Path]::GetTempPath()
$name = [System.IO.Path]::GetRandomFileName()
$tempDirectory = New-Item -ItemType Directory -Path (Join-Path $parent $name) -ErrorAction stop
try {
    # Copia i file da mettere nello zip nella cartella temporanea
    $currentPath = $((get-Item -Path '.\').FullName)
    Get-ChildItem $currentPath -Include "*.jasper", "*.jrxml", "*.properties" -Recurse | Select -ExpandProperty FullName | Copy-Item -Destination $tempDirectory

    # Crea file zip temporaneo in una cartella temporanea con il contenuto della cartella creata prima
    $tempFile = [System.IO.Path]::GetTempPath() + [System.IO.Path]::GetRandomFileName()
    Add-Type -Assembly System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::CreateFromDirectory($tempDirectory, $tempFile)

    # Sposta il file zip nella cartella corrente
    Move-Item $tempFile $fullDeployFileName -ErrorAction stop
    write-host $zipName" creato in "$fullDeployPath
} catch {
    $ErrorMessage = $_.Exception.Message
    Write-Host -ForegroundColor Red 'Errore:' $ErrorMessage
}

# Cancella la cartella temporanea
Remove-Item -Recurse $tempDirectory
