# Test Task
Write a PowerShell script that synchronizes two folders in one direction

### Prerequisite

- [VSCode](https://code.visualstudio.com/download)
- [PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.4)

### Setup

You must have PowerShell installed on your machine.

### How to run

You can run the ```SyncFolders.ps1``` in a PowerShell session as shown below.

###### run
```ps
.\SyncFolders.ps1
cmdlet Sync-Folders at command pipeline position 1
Supply values for the following parameters:
sourceFolder: from
destinationFolder: to
logFile: operations.log
```

###### output
![connect](/images/step-zero.png)
![connect](/images/step-half.png)

:warning: Both source and destination folders must exist!
![connect](/images/fromm.png)

:warning: Files that already exists in the destination folder wont be re-copied!
![connect](/images/step-almost.png)

### Resources

- [Writing Output to Log Files in PowerShell Script](https://woshub.com/write-output-log-files-powershell/)
- [Display the progress](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/write-progress?view=powershell-7.4)
- [PowerShell Basics: If -And & If -Or Statements](https://www.computerperformance.co.uk/powershell/if-and/)
- [Determine if a path is to a file or a folder?](https://devblogs.microsoft.com/scripting/powertip-using-powershell-to-determine-if-path-is-to-file-or-folder/)
- [Get the hash value for a file](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-filehash?view=powershell-7.4)
- [Relative path PowerShell](https://learn.microsoft.com/en-us/answers/questions/648868/relative-path-powershell)
- [Count items in a folder with PowerShell](https://stackoverflow.com/questions/14714284/powershell-count-items-in-a-folder-with-powershell)
- [Begin to Process to End](https://www.sapien.com/blog/2019/05/13/advanced-powershell-functions-begin-to-process-to-end/)
