#LAB 1

"Hello World"

#LAB 2

function welcome {
    "Welcome to PowerShell!"
}
welcome


function get-cpuinfo {
    Get-CimInstance -ClassName Win32_Processor |
    Select-Object Manufacturer, Name, CurrentClockSpeed, MaxClockSpeed, NumberOfCores | select -last 1
}
get-cpuinfo




function get-mydisks {"                             Disk Info"
    Get-WmiObject -Class Win32_DiskDrive | Select-Object Manufacturer, Model, FirmwareRevision, Size, SerialNumber
    
}
get-mydisks


#LAB 3

function networkReport {                             
    get-ciminstance win32_networkadapterconfiguration | where-object ipenabled | select-object Description, IPaddress, DNSServerSearchOrder, DNSDomainSuffixSearchOrder, Index, IPsubnet | Format-table -Autosize
    
}
networkReport

get-ciminstance win32_networkadapterconfiguration | where-object ipenabled | select-object Description, IPaddress, DNSServerSearchOrder, DNSDomainSuffixSearchOrder, Index, IPsubnet | Format-table -Autosize

