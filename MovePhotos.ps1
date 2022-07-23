
function MoveFiles([string]$sourcePath, [string]$destinationPath, [string]$label)
{
    Write-Host "sourcePath: " $sourcePath
    Write-Host "destinationPath: " $destinationPath
    Write-Host "label: " $label

    $compareDate = (Get-Date)

    # list all of the files in descending creation date order
    Get-ChildItem $sourcePath -Recurse | sort CreationTime -descending | % `
    {
       $file = $_.FullName
       $fileCreated = $_.CreationTime
       #Write-Host $file " - " $fileCreated

       $fileYear = $fileCreated.ToString("yyyy")
       $fileMonth = $fileCreated.ToString("MM")

       $daysOld = ($compareDate - $fileCreated).Days
       if(($daysOld -gt 45) -and ($daysOld -lt 700))
       {
            #Write-Host $daysOld
            #Write-Host $fileYear " - " $fileMonth

            Write-Host $file " - " $fileCreated
        
            $destinationFolder = $destinationPath + $fileYear + "\" + $fileYear + "-" + $fileMonth
            if($label -eq "")
            {
                $destinationFolder += "\"
            }
            else
            {
                $destinationFolder += " " + $label + "\"
            }
            $newFile = $destinationFolder + $_.BaseName + $_.Extension
            Write-Host $newFile

            New-Item -Path $destinationFolder -ItemType "directory" -Force
            Copy-Item $file -Destination $destinationFolder -Force
            Remove-Item $file -Force

       } else {
            Write-Host $daysOld " | " $file " - " $fileCreated

       }
    }
}

$destinationPath = "F:\Sharing\My Pictures\"

$label = "Bill"
$sourcePath = "C:\Users\bill\iCloudPhotos\Photos\"
MoveFiles $sourcePath $destinationPath $label
