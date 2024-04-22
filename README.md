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
.\SyncFolders.ps1 -sourceFolder "from" -destinationFolder "to"
```

Default log file ```operations.log```, which you can override by setting the param: ```-logFile "new-operations.log"```

###### output
:warning: Both source and destination folders must exist!
![connect](/images/fromm.png)

```ps
/test-task/from/folder is copied to /test-task/to/folder
/test-task/from/file is copied to /test-task/to/file
```

:warning: Files that already exists in the destination folder wont be re-copied!
```ps 
'/test-task/to/folder' already exists
'/test-task/to/file' already exists
```

### Resources

- [Writing Output to Log Files in PowerShell Script](https://woshub.com/write-output-log-files-powershell/)
