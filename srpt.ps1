#!/opt/homebrew/bin/pwsh-preview
# Cooper Maitoza
# Lab 7 - PowerShell Search and Report
# CS 3030 - Scripting Languages

if ($args.length -ne 1) {
  Write-Host "Usage: srpt.ps1 FOLDER"
  exit 1
}

$hostname = hostname
$todaysDate = & date

$directoryCount = 0
$fileCount = 0
$symLinkCount = 0
$oldFileCount = 0
$largeFileCount = 0
$graphicsFileCount = 0
$tempFileCount = 0
$exeFileCount = 0
$totalFileSize = 0

$startTime = get-date

$allObjects = Get-ChildItem -Recurse -Path $args[0]

foreach ($object in $allObjects) {
  if (Test-Path -Path $object -PathType Leaf) {
    #Write-Host "Leaf: $object"
    $fileCount++

    if ($object.CreationTime -lt (Get-Date).AddDays(-365)) {
      $oldFileCount++
    }

    if ($object.length -gt 500000) {
      $largeFileCount++
    }

    if ($object.name -match '\.jpg|\.gif|\.bmp') {
      # Write-Host "graphics: $object"
      $graphicsFileCount++
    }

    if ($object.name -match '\.o') {
      # Write-Host "temp: $object"
      $tempFileCount++
    }

    if ($object.name -match '\.bat|\.ps1|\.exe') {
      # Write-Host "exec: $objct"
      $exeFileCount++
    }

    $totalFileSize += $object.length

  }
  else {
    #Write-Host "Container: $object"
    $directoryCount++
  }
  if ($object.Attributes.ToString() -band [System.IO.FileAttributes]::ReparsePoint) {
    Write-Host "symlink: $object"
    $symLinkCount++
  }
}


Write-Host "SearchReport $hostname $($args[0]) $todaysDate" 
Write-Host "Directories $($directoryCount.ToString("N0"))"
Write-Host "Files $($fileCount.ToString("N0"))"
Write-Host "Sym links $($symLinkCount.ToString("N0"))"
Write-Host "Old files $($oldFileCount.ToString("N0"))"
Write-Host "Large files $($largeFileCount.ToString("N0"))"
Write-Host "Graphics files $($graphicsFileCount.ToString("N0"))"
Write-Host "Temporary files $($tempFileCount.ToString("N0"))"
Write-Host "Executable files $($exeFileCount.ToString("N0"))"
Write-Host "TotalFileSize $($totalFileSize.ToString("N0"))"

$endTime = get-date
$executionTime = [int]($endTime - $startTime).TotalSeconds
Write-Host "Execution Time: $executionTime"

exit 0
