function get-mydisks {"                             Disk Info"
    Get-WmiObject -Class Win32_DiskDrive | Select-Object Manufacturer, Model, FirmwareRevision, Size, SerialNumber
    
}
get-mydisks