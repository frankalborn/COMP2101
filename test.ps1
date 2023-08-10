""
"SYSTEM REPORT"
""
"SYSTEM HARDWARE DESCRIPTION"
""
$compHardware = Get-WmiObject -Class Win32_ComputerSystem
"Manufacturer: $($compHardware.Manufacturer)"
"Model: $($compHardware.Model)"
"Name: $($compHardware.Name)"
If ($compHardware.Manufacturer) { $compHardware.Manufacturer } else { "Data Unavailable" }
If ($compHardware.Model) { $compHardware.Model } else { "Data Unavailable" }
If ($compHardware.Name) { $compHardware.Name } else { "Data Unavailable" }


""
"OPERATING SYSTEM REPORT"
""
$os = Get-CimInstance -ClassName Win32_OperatingSystem

"Operating System: $($os.Caption)"
"Version: $($os.Version)"
 If ($os.Caption) { $os.Caption } else { "Data Unavailable" }
 If ($os.Version) { $os.Version } else { "Data Unavailable" }


""
"PROCESSOR DESCRIPTION"


Get-CimInstance -ClassName Win32_Processor | Select-Object Manufacturer, Name, CurrentClockSpeed, MaxClockSpeed, NumberOfCores | select -last 1 
$processors = Get-CimInstance -ClassName Win32_Processor | select -last 1
If ($processors.Manufacturer) { $processors.Manufacturer } else { "Data Unavailable" }
If ($processors.Name) { $processors.Name } else { "Data Unavailable" }
If ($processors.CurrentClockSpeed) { $processors.CurrentClockSpeed } else { "Data Unavailable" }
If ($processors.MaxClockSpeed) { $processors.MaxClockSpeed } else { "Data Unavailable" }
If ($processors.NumberOfCores) { $processors.NumberOfCores } else { "Data Unavailable" }

foreach ($processor in $processors) {
    $l1CacheSize = $processor.L1CacheSize
    $l2CacheSize = $processor.L2CacheSize
    $l3CacheSize = $processor.L3CacheSize

    "Processor L1 Cache Size: $($l1CacheSize / 1KB) KB"
    "Processor L2 Cache Size: $($l2CacheSize / 1KB) KB"
    "Processor L3 Cache Size: $($l3CacheSize / 1KB) KB"
    
}

""
"NETWORK REPORT"
get-ciminstance win32_networkadapterconfiguration | where-object ipenabled | select-object Description, IPaddress, DNSServerSearchOrder, DNSDomainSuffixSearchOrder, Index, IPsubnet | Format-table -Autosize


""
"VIDEO REPORT"

Get-WmiObject -Class Win32_VideoController | Format-List Name, Description,VideoModeDescription,VideoProcessor
