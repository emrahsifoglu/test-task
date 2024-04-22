
#Requires -Version 7.4

param (
    [parameter(Mandatory=$True)]
    [string]$sourceFolder,
    [parameter(Mandatory=$True)]
    [string]$destinationFolder,
    [parameter(Mandatory=$False)]
    [string]$logFile = "operations.log"
)

function Write-Log {
    Param (
        [parameter(Mandatory=$True)]
        [string]$message
    )

    $dateTime = $(Get-Date).toString("dd.MM.yyyy HH:mm:ss")

    Add-Content $logFile -Value "$dateTime $message"
}

if (-not (Test-Path $sourceFolder -PathType Container)) {
    Write-Error "Source folder '$sourceFolder' does not exist!"
    exit
}

if (-not (Test-Path $destinationFolder -PathType Container)) {
    Write-Error "Destination folder '$destinationFolder' does not exist!"
    exit
}

$sourceFiles = Get-ChildItem -Path $sourceFolder -Recurse | Select-Object -Property @{n = 'RelativeName';e ={$_.FullName.Substring($SourcePath.Length)}}

$sourceFiles | % {
    $path = $_.RelativeName
    $destination = $path -replace $sourceFolder.Replace('\','\\'), $destinationFolder 

    if (!(Test-Path $destination)) {
        Copy-Item -Path $path -Destination $destination
        $msg = "$path is copied to $destination"
        Write-Output $msg
        Write-Log $msg
    } else {
        Write-Output "'$destination' already exists"
    } 
}
