$key = "5NZYMJoyyrQLoEwcxGBlgDBdLMrnWsCx4BEwfsSdkM33QzgsmuXadz5gr3j8PIeBfeg1E9XqD473j9Nk2QYsRg=="
$shareName = "workspace-file-storage-pri"
$symDirPath = "c:\server\workspace\client"
$stgAcctName = "stgfiles1wspri"
$fileShareName = "workspace-file-storage-pri"
$symDirFolderName = "files"
$filesMountDrive = "z"

$acctKey = ConvertTo-SecureString -String $key -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList "$Azure\$($stgAcctName)", $acctKey
New-PSDrive -Name $filesMountDrive -PSProvider FileSystem -Root "\\$($stgAcctName).file.core.windows.net\$($fileShareName)" -Credential $credential -Persist

New-Item $symDirPath -type directory -Force
New-Item -ItemType SymbolicLink -Path "$($symDirPath)\$($symDirFolderName)" -Value "$($filesMountDrive):\\"