
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

function Show-Progress {
    Param (
        [parameter(Mandatory=$True)]
        [int]$percentage,
        [parameter(Mandatory=$True)]
        [string]$status,
        [parameter(Mandatory=$False)]
        [int]$sleepTime = 0
    )

    Write-Progress -Activity "%$percentage" -Status $status -PercentComplete $percentage
    Start-Sleep -Milliseconds $sleepTime
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
$steps = $sourceFiles.Length
$step = 0

Show-Progress -percentage 0 -status " "

$sourceFiles | ForEach-Object {
    $path = $_.RelativeName
    $destination = $path -replace $sourceFolder.Replace('\','\\'), $destinationFolder 

    if (!(Test-Path $destination)) {
        Copy-Item -Path $path -Destination $destination
        $msg = "'$path' is copied to '$destination'"
    } else {
        $msg = "'$destination' already exists"
    }

    $step = $step + 1
    $percentage = ($step / $steps) * 100

    Write-Log $msg
    Show-Progress -percentage $percentage -status $msg -sleepTime 250
    
}

Show-Progress -percentage 100 -status "Done"
