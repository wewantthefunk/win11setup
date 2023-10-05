# win 11 setup

#Define function to disable windows service

function Disable-WindowsService {
    param (
        [string]$ServiceName
    )

    # Check if the service exists
    if (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue) {
        # Disable the service
        Set-Service -Name $ServiceName -StartupType Disabled

        Write-Host "The '$ServiceName' service has been disabled."
    } else {
        Write-Host "The '$ServiceName' service was not found."
    }
}


# Define a function to set a registry value
function Set-RegistryValue {
    param (
        [string]$RegistryPath,
        [string]$ValueName,
        [int]$ValueData
    )
    
    # Check if the registry key exists; if not, create it
    if (-not (Test-Path -Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force
    }
    
    # Set the specified DWORD value in the registry
    Set-ItemProperty -Path $RegistryPath -Name $ValueName -Value $ValueData

    # Inform the user that the change has been made
    Write-Host "Registry value '$ValueName' set to $ValueData at '$RegistryPath'."
}

function Set-RegistryValueString {
    param (
        [string]$RegistryPath,
        [string]$ValueName,
        [string]$ValueData
    )
    
    # Check if the registry key exists; if not, create it
    if (-not (Test-Path -Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force
    }
    
    # Set the specified DWORD value in the registry
    Set-ItemProperty -Path $RegistryPath -Name $ValueName -Value $ValueData

    # Inform the user that the change has been made
    Write-Host "Registry value '$ValueName' set to $ValueData at '$RegistryPath'."
}

function Remove-DesktopIcons {
    # Define the path to the Desktop folder
    $desktopPath = [System.Environment]::GetFolderPath("Desktop")

    # Get all items (files and shortcuts) in the Desktop folder
    $desktopItems = Get-ChildItem -Path $desktopPath

    # Loop through each item and remove it
    foreach ($item in $desktopItems) {
        if ($item.PSIsContainer) {
            # Skip directories (subfolders) on the desktop
            continue
        }

        # Remove the item (file or shortcut)
        Remove-Item -Path $item.FullName -Force
    }

    Write-Host "All icons have been removed from the desktop."
}

function Unpin-AllTaskbarItems {
    Remove-Item -Path "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\Taskbar\*" -Force -Recurse
    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\TaskBand" -Name '*' -Force

    Write-Host "All pinned items have been removed from the taskbar."
}

function Make-Updates {
    # Move the start menu to the left
    $CustomRegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    $CustomValueName = "TaskbarAl"
    Set-RegistryValue -RegistryPath $CustomRegistryPath -ValueName $CustomValueName -ValueData 0

    # Show all file extensions
    $CustomValueName = "HideFileExt"
    Set-RegistryValue -RegistryPath $CustomRegistryPath -ValueName $CustomValueName -ValueData 0

    # Disable diagnostic

    $CustomRegistryPath = "HKLM:\Software\Policies\Microsoft\Windows\DataCollection"
    $CustomValueName = "AllowTelemetry"
    Set-RegistryValue -RegistryPath $CustomRegistryPath -ValueName $CustomValueName -ValueData 0

    # Disable Feedback & Diagnostics

    $CustomRegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    $CustomValueName = "DoNotUseDiagnosticData"
    Set-RegistryValue -RegistryPath $CustomRegistryPath -ValueName $CustomValueName -ValueData 1

    # Disable Cortana

    $CustomRegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
    $CustomValueName = "AllowCortana"
    Set-RegistryValue -RegistryPath $CustomRegistryPath -ValueName $CustomValueName -ValueData 0

    # Disable Advertising ID

    $CustomRegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
    $CustomValueName = "DisabledByGroupPolicy"
    Set-RegistryValue -RegistryPath $CustomRegistryPath -ValueName $CustomValueName -ValueData 1

    # Hide Search Box

    $CustomRegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
    $CustomValueName = "SearchboxTaskbarMode"
    Set-RegistryValue -RegistryPath $CustomRegistryPath -ValueName $CustomValueName -ValueData 0

    # Change to Dark Mode

    $CustomRegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    $CustomValueName = "SystemUsesLightTheme"
    Set-RegistryValue -RegistryPath $CustomRegistryPath -ValueName $CustomValueName -ValueData 0

    # Change Apps to Dark Mode

    $CustomRegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    $CustomValueName = "AppsUseLightTheme"
    Set-RegistryValue -RegistryPath $CustomRegistryPath -ValueName $CustomValueName -ValueData 0

    # Remove chat Icon

    $CustomRegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    $CustomValueName = "TaskbarMn"
    Set-RegistryValue -RegistryPath $CustomRegistryPath -ValueName $CustomValueName -ValueData 0

    # Remove weather Icon

    $CustomRegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Dsh"
    $CustomValueName = "AllowNewsAndInterests"
    Set-RegistryValue -RegistryPath $CustomRegistryPath -ValueName $CustomValueName -ValueData 0

    # Remove widgets

    $CustomRegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    $CustomValueName = "TaskbarDa"
    Set-RegistryValue -RegistryPath $CustomRegistryPath -ValueName $CustomValueName -ValueData 0

    # Turn off notification center

    $CustomRegistryPath = "HKCU:\Software\Policies\Microsoft\Windows\Explorer"
    $CustomValueName = "DisableNotificationCenter"
    Set-RegistryValue -RegistryPath $CustomRegistryPath -ValueName $CustomValueName -ValueData 1

    # Turn off search highlights

    $CustomRegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings"
    $CustomValueName = "IsDynamicSearchBoxEnabled"
    Set-RegistryValue -RegistryPath $CustomRegistryPath -ValueName $CustomValueName -ValueData 0

    # Turn off Powershell 2.0

    $CustomRegistryPath = "HKLM:\SOFTWARE\Microsoft\PowerShell\1\PowerShellEngine"
    $CustomValueName = "PowerShellVersion"
    Set-RegistryValueString -RegistryPath $CustomRegistryPath -ValueName $CustomValueName -ValueData "2.0"

    # Set Sound Scheme to "No Sound"

    # Define the registry path for the sound scheme settings
    $soundSchemeRegistryPath = "HKCU:\AppEvents\Schemes\Apps\.Default"

    # Disable all system sounds by setting "(None)" for all events
    $eventSounds = Get-Item -Path "$soundSchemeRegistryPath\*"
    $eventSounds | ForEach-Object {
        $eventPath = $_.PSChildName
        Set-ItemProperty -Path "$soundSchemeRegistryPath\$eventPath" -Name "(Default)" -Value ".None"
        Set-ItemProperty -Path "$soundSchemeRegistryPath\$eventPath\.Current" -Name "(Default)" -Value ""
    }

    $CustomRegistryPath = "HKCU:\AppEvents\Schemes"
    $CustomValueName = "(Default)"
    Set-RegistryValueString -RegistryPath $CustomRegistryPath -ValueName $CustomValueName -ValueData ".None"

    #Disable Services

    Disable-WindowsService -ServiceName "AJRouter"
    Disable-WindowsService -ServiceName "AssignedAccessManagerSvc"
    Disable-WindowsService -ServiceName "BDESVC"
    Disable-WindowsService -ServiceName "DiagTrack"
    Disable-WindowsService -ServiceName "DoSvc"
    Disable-WindowsService -ServiceName "diagsvc"
    Disable-WindowsService -ServiceName "DPS"
    Disable-WindowsService -ServiceName "WdiServiceHost"
    Disable-WindowsService -ServiceName "WdiSystemHost"
    Disable-WindowsService -ServiceName "lfsvc"
    Disable-WindowsService -ServiceName "Netlogon"
    Disable-WindowsService -ServiceName "defragsvc"
    Disable-WindowsService -ServiceName "WpcMonSvc"
    Disable-WindowsService -ServiceName "PhoneSvc"
    Disable-WindowsService -ServiceName "SessionEnv"
    Disable-WindowsService -ServiceName "TermService"
    Disable-WindowsService -ServiceName "UmRdpService"
    Disable-WindowsService -ServiceName "SensorService"
    Disable-WindowsService -ServiceName "SCardSvr"
    Disable-WindowsService -ServiceName "ScDeviceEnum"
    Disable-WindowsService -ServiceName "SCPolicySvc"
    Disable-WindowsService -ServiceName "WbioSrvc"
    Disable-WindowsService -ServiceName "WerSvc"
    Disable-WindowsService -ServiceName "workfolderssvc"
    Disable-WindowsService -ServiceName "XboxGipSvc"
    Disable-WindowsService -ServiceName "XblAuthManager"
    Disable-WindowsService -ServiceName "XblGameSave"
    Disable-WindowsService -ServiceName "XboxNetApiSvc"
    Disable-WindowsService -ServiceName "SQLWriter"
    Disable-WindowsService -ServiceName "WSearch"
    Disable-WindowsService -ServiceName "WinRM"

    # Remove all Desktop Icons
    Remove-DesktopIcons

    # Remove all pinned items from taskbar
    Unpin-AllTaskbarItems
}

Make-Updates

