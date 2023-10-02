# win 11 setup

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

    # Restart the explorer process to apply the changes
    Stop-Process -Name explorer -Force
    Start-Process explorer
}

function Install-Executable {
    param (
        [string]$InstallerUrl,
        [string]$ExecutableName,
        [switch]$RunNow
    )

    # Check if the application is already installed
    $appInstalled = Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name = '$ExecutableName'" -ErrorAction SilentlyContinue

    if ($appInstalled) {
        Write-Host "$ExecutableName is already installed."
    }
    else {
        Write-Host "Installing $ExecutableName..."
        # Define the path where you want to save the installer
        $InstallerPath = "$env:TEMP\$ExecutableName.exe"

        # Download the Brave installer
        Invoke-WebRequest -Uri $InstallerUrl -OutFile $InstallerPath

        # Install Brave silently
        Start-Process -FilePath $InstallerPath -ArgumentList "/silent /install" -Wait

        # Remove the installer after installation
        Remove-Item -Path $InstallerPath -Force
    }

    if ($RunNow -and $appInstalled -eq $null) {
        Start-Process "$env:ProgramFiles\BraveSoftware\$ExecutableName\Application\$ExecutableName.exe"
    }
}

function Unpin-AllTaskbarItems {
    # Define the path to the TaskBar folder
    $TaskBarFolder = [System.IO.Path]::Combine($env:APPDATA, "Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar")

    # Get a list of all shortcut files in the TaskBar folder
    $ShortcutFiles = Get-ChildItem -Path $TaskBarFolder -Filter *.lnk

    # Loop through the shortcut files and remove them
    foreach ($ShortcutFile in $ShortcutFiles) {
        Remove-Item -Path $ShortcutFile.FullName -Force
    }

    Write-Host "All pinned items have been removed from the taskbar."
}

# Call the function to unpin all taskbar items
Unpin-AllTaskbarItems

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

# Disable Cortana

$CustomRegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
$CustomValueName = "AllowCortana"
Set-RegistryValue -RegistryPath $CustomRegistryPath -ValueName $CustomValueName -ValueData 0

# Disable Feedback & Diagnostics

$CustomRegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
$CustomValueName = "DoNotUseDiagnosticData"
Set-RegistryValue -RegistryPath $CustomRegistryPath -ValueName $CustomValueName -ValueData 1

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

$CustomRegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Dsh\AllowNewsAndInterests"
$CustomValueName = "TaskbarMn"
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

# Install Brave without launching it immediately
# Install-Executable -InstallerUrl "https://laptop-updates.brave.com/latest/winx64" -ExecutableName "brave" -RunNow:$false

# Define the URL for the Firefox installer
$FirefoxInstallerUrl = "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US"

# Install Firefox without launching it immediately
# Install-Executable -InstallerUrl $FirefoxInstallerUrl -ExecutableName "firefox" -RunNow:$false

# Define the URL for the VSCode installer (adjust the URL as needed)
$VSCodeInstallerUrl = "https://vscode-update.azurewebsites.net/latest/win32-x64-user/stable"

# Specify the desired executable name
$VSCodeExecutableName = "Code"

# Install VSCode without launching it immediately
# Install-Executable -InstallerUrl $VSCodeInstallerUrl -ExecutableName $VSCodeExecutableName -RunNow:$false

