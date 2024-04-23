
#Requires -Version 7.4

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

function Get-FileMD5 {
    Param(
        [string]$Path
    )

    $md5 = [System.Security.Cryptography.HashAlgorithm]::Create("MD5")
    $IO = New-Object System.IO.FileStream($Path, [System.IO.FileMode]::Open)
    $StringBuilder = New-Object System.Text.StringBuilder
    $md5.ComputeHash($IO) | ForEach-Object { [void] $StringBuilder.Append($_.ToString("x2")) }
    $hash = $StringBuilder.ToString() 
    $IO.Dispose()

    return $hash
}

function Sync-Folders
{
    [CmdletBinding()]
    Param (
        [parameter(Mandatory=$True)]
        [string]$sourceFolder,
        [parameter(Mandatory=$True)]
        [string]$destinationFolder,
        [parameter(Mandatory=$True)]
        [string]$logFile
    )
    Begin
    {
        if (-not (Test-Path $sourceFolder -PathType Container)) {
            Write-Error "Source folder '$sourceFolder' does not exist!"
            exit
        }
        
        if (-not (Test-Path $destinationFolder -PathType Container)) {
            Write-Error "Destination folder '$destinationFolder' does not exist!"
            exit
        }
        
        $sourceFiles = Get-ChildItem -Path $sourceFolder -Recurse | `
                        Select-Object -Property * `
                        ,@{name="Info";e={((Get-Item $_.FullName) -is [System.IO.DirectoryInfo]) ? 'Directory' : 'File'}} `
                        ,@{name="Hash";e={Get-FileMD5 $_.FullName}}
        
        $step = 0
        $steps = (Get-ChildItem $sourceFolder).Count

        if ($null -eq $sourceFiles) {
            $msg = "There are no files in '$sourceFolder' folder."
            Write-Log $msg
            Write-Output $msg
        
            Remove-Item "$destinationFolder/*" -Recurse -Force
        
            $msg = "All existing files in '$destinationFolder' folder are deleted."
            Write-Log $msg
            Write-Output $msg
        
            exit
        }
        
        Show-Progress -percentage 0 -status " "
    }
    Process
    {
        $sourceFiles | ForEach-Object {
            $path = $_.FullName
            $destination = $path -replace $sourceFolder.Replace('\','\\'), $destinationFolder
            $create = !(Test-Path $destination) -And "Directory" -eq $_.Info
            $copy = !(Test-Path $destination) -And "File" -eq $_.Info
        
            if ($true -eq (Test-Path $destination) -And "File" -eq $_.Info) {
                $destinationFileHash = Get-FileMD5 -Path $destination
        
                if ($destinationFileHash -eq $_.Hash) {
                    $copy = $false
                    Write-Log "File hashes match: '$destination' already exists in destination folder and will be skipped."
                } else {
                    $copy = $true
                    Write-Log "File hashes don't match: '$path' will be copied to destination folder."
                }
            }
        
            if ($true -eq $copy) {
                Copy-Item -Path $path -Destination $destination -Recurse -Force
                $msg = "'$path' is copied to '$destination'"
            } elseif ($true -eq $create) {
                New-Item -ItemType $_.Info -Path $destination -Force | Out-Null
                $msg = "'$path' is created in '$destination'"
            } else {
                $msg = "'$path' is skipped"
            }
        
            $step = $step + 1
            $percentage = ($step / $steps) * 100
        
            Write-Log $msg
            Show-Progress -percentage $percentage -status $msg -sleepTime 250   
        }
        
        Show-Progress -percentage 100 -status "Done"
    }
    End
    {
        Get-ChildItem -Path $destinationFolder -Recurse | ForEach-Object {
            $path = $_.FullName
            $source = $path -replace $destinationFolder.Replace('\','\\'), $sourceFolder
            $delete = !(Test-Path $source)
        
            if ($true -eq $delete) {
                $destination = $path -replace $sourceFolder.Replace('\','\\'), $destinationFolder
                if ($true -eq (Test-Path $destination)) {
                    Remove-Item $destination -Force -Recurse
                    Write-Log "'$path' is deleted to '$destination'"   
                }
            }
        }
    }
}

Sync-Folders
