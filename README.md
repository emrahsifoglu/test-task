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

###### output
:warning: Both source and destination folders must exist!
![connect](/images/fromm.png)

```ps
/test-task/to/empty-folder
/test-task/to/file
```

:warning: Files that already exists in the destination folder wont be re-copied!
```ps 
'/test-task/to/empty-folder' already exists
'/test-task/to/file' already exists
```
