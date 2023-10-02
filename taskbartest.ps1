function Unpin-AllTaskbarItems {
    # Define the path to the TaskBar folder
    $TaskBarFolder = [System.IO.Path]::Combine($env:APPDATA, "Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar")

    # Get a list of all shortcut files in the TaskBar folder
    $ShortcutFiles = Get-ChildItem -Path $TaskBarFolder -Filter *.lnk

    # Loop through the shortcut files and remove them
    foreach ($ShortcutFile in $ShortcutFiles) {
        $appname = $ShortcutFile.FullName
        Write-Host $appname
        ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'Unpin from taskbar'} | %{$_.DoIt(); $exec = $true}
    }

    Write-Host "All pinned items have been removed from the taskbar."
}

Unpin-AllTaskbarItems