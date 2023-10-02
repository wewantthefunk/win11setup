DEL /F /S /Q /A "%AppData\Microsoft\Internet Explorer\Quick Launch\User Pinned\Taskbar\*"

REG DELETE HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\TaskBand /F

taskkill /f /im explorer.exe

start explorer.exe