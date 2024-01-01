$sourcePath = "C:\Users\Piyush.Pandita\Downloads\Temp1"
$destinationPath = "C:\Users\Piyush.Pandita\Downloads\Temp2"

# Get all files and folders from the source directory
$sourceItems = Get-ChildItem -Path $sourcePath -Recurse

foreach ($item in $sourceItems) {
    $destinationItem = Join-Path -Path $destinationPath -ChildPath $item.FullName.Substring($sourcePath.Length + 1)
    
    # If the item exists in the destination folder
    if (Test-Path -Path $destinationItem -PathType Container) {
        # If it's a directory, remove it before copying the new one
        if ($item.PSIsContainer) {
            Remove-Item -Path $destinationItem -Recurse -Force
        } else {
            # If it's a file, replace it
            Copy-Item -Path $item.FullName -Destination $destinationItem -Force
        }
    } elseif ($item.PSIsContainer) {
        # If the item does not exist in the destination and it's a directory,
        # copy the entire directory to the destination
        Copy-Item -Path $item.FullName -Destination $destinationItem -Recurse -Force
    } else {
        # If it's a file and the destination folder doesn't exist, create it and then copy the file
        $parentFolder = Split-Path -Path $destinationItem -Parent
        if (-not (Test-Path -Path $parentFolder)) {
            New-Item -ItemType Directory -Path $parentFolder | Out-Null
        }
        Copy-Item -Path $item.FullName -Destination $destinationItem -Force
    }
}
