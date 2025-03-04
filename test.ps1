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

# Remove Task View from Taskbar
$CustomRegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$CustomValueName = "ShowTaskViewButton"
Set-RegistryValue -RegistryPath $CustomRegistryPath -ValueName $CustomValueName -ValueData 0