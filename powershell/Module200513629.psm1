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

get-ciminstance win32_networkadapterconfiguration | where-object ipenabled | select-object Description, IPaddress, DNSServerSearchOrder, DNSDomainSuffixSearchOrder, Index, IPsubnet | Format-table -Autosize

#LAB 4

""
"1: SYSTEM REPORT"
function computerHardware {
    ""
   $compHardware = Get-WmiObject -Class Win32_ComputerSystem
    #the -match '\S' on the if condition determines whether manufaturer, model, and name information are whitespace. if the output is displayed in whitespace, the 'N/A' message will be displayed
    $manufacturer = if ($compHardware.Manufacturer -match '\S') {
        $compHardware.Manufacturer
    } else {
        "N/A"
    }
    
    $model = if ($compHardware.Model -match '\S') {
        $compHardware.Model
    } else {
        "N/A"
    }
    
    $name = if ($compHardware.Name -match '\S') {
        $compHardware.Name
    } else {
        "N/A"
    }

    "Manufacturer: $manufacturer"
    "Model: $model"
    "Name: $name"
}



computerHardware


function operatingSystem {
    ""
    "2: OPERATING SYSTEM REPORT"
    ""
    $os = Get-WmiObject -Class Win32_OperatingSystem
    #condition that outputs data unavailable if there is a empty information
    if ($os.Caption) {
        "Operating System: $($os.Caption)"
    } else {
        "Operating System: Data Unavailable"
    }
    
    if ($os.Version) {
        "Version: $($os.Version)"
    } else {
        "Version: Data Unavailable"
    }
}


operatingSystem



function processorReport {
    ""
    "3: PROCESSOR REPORT"
    ""
    $processors = Get-CimInstance -ClassName Win32_Processor | Select-Object Manufacturer, Name, CurrentClockSpeed, MaxClockSpeed, NumberOfCores | Select -Last 1

    if ($processors.Manufacturer) {
        "Manufacturer: $($processors.Manufacturer)"
    } else {
        "Manufacturer: Data Unavailable"
    }
    
    if ($processors.Name) {
        "Processor: $($processors.Name)"
    } else {
        "Processor: Data Unavailable"
    }
    
    if ($processors.CurrentClockSpeed) {
        "Current Clock Speed: $($processors.CurrentClockSpeed) MHz"
    } else {
        "Current Clock Speed: Data Unavailable"
    }
    
    if ($processors.MaxClockSpeed) {
        "Max Clock Speed: $($processors.MaxClockSpeed) MHz"
    } else {
        "Max Clock Speed: Data Unavailable"
    }
    
    if ($processors.NumberOfCores) {
        "Number of Cores: $($processors.NumberOfCores)"
    } else {
        "Number of Cores: Data Unavailable"
    }


}


processorReport

#created a separate processor cache function because the output form the caches wont be correct if I blend the following commands with the processors function
function cacheSize {
foreach ($processor in $processors) {
    $l1CacheSize = $processor.L1CacheSize
    $l2CacheSize = $processor.L2CacheSize
    $l3CacheSize = $processor.L3CacheSize

    if ($l1CacheSize -gt 0) {
        "Processor L1 Cache Size: $($l1CacheSize / 1KB) KB"
    } else {
        "Processor L1 Cache Size: N/A" 
    }

    if ($l2CacheSize -gt 0) {
        "Processor L2 Cache Size: $($l2CacheSize / 1KB) KB"
    } else {
        "Processor L2 Cache Size: N/A"
    }

    if ($l3CacheSize -gt 0) {
        "Processor L3 Cache Size: $($l3CacheSize / 1KB) KB"
    } else {
        "Processor L3 Cache Size: N/A"
    }
}

}


function ramReport {
""
"4: RAM REPORT"
$ramReport = Get-WmiObject -Class Win32_PhysicalMemory | Select-Object Manufacturer, Description, Capacity, BankLabel, DeviceLocator


#modified the capacity property to make the capacity size value human friendly readable, an "Expression parameter is used to make a calculation of the capacity, the capacity property is divided by 1gigabyte and then by using [math]::Round() rounding the value to 2 decimal places
if ($ramReport) {
    $ramReport | Format-Table -AutoSize Manufacturer, Description, @{Name="Capacity(GB)";Expression={[string]::Format("{0:N2} GB", $_.Capacity / 1GB)}}, BankLabel, DeviceLocator
} else {
    "N/A"
}

#total ram size created in separated variables, which are displayed in GB
$totalRamSize = (Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory
$totalRamGB = $totalRamSize / 1GB
#to calculate the total capacity in GB the variable totalRamGB is divided by 1

#the .ToString("N2") formats the value into 2 decimal places, giving an more human friendly readable of the total RAM

"Total RAM Capacity: $($totalRamGB.ToString("N2")) GB"


}

ramReport 





function diskreport {
""
"5: DISK REPORT"
""
$diskReport = Get-WmiObject -Class Win32_DiskDrive | Select-Object Manufacturer, Model, Size, Partitions
if ($diskReport) {
    $diskReport | Format-Table -AutoSize Manufacturer, Model, @{Name="Size(GB)";Expression={[string]::Format("{0:N2} GB", $_.Size / 1GB)}}, Partitions
} else {
    "N/A"
}

}
diskreport



function networkReport {
""
"6: NETWORK REPORT (ENABLED ADAPTERS)"
$networkReport = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object ipenabled
if ($networkReport) {
    $networkReport | Select-Object Description, IPAddress, DNSServerSearchOrder, DNSDomainSuffixSearchOrder, Index, IPSubnet | Format-Table -AutoSize
} else {
    "N/A"
}
}

networkReport



function VideoCardReport {
    "7: VIDEO CARD REPORT"
    ""
    
    $videoControllers = Get-WmiObject -Class Win32_VideoController

    
    foreach ($videoController in $videoControllers) {
        $name = $videoController.Name
        $description = $videoController.Description
        $videoProcessor = $videoController.VideoProcessor
        $verticalresolution = $videoController.CurrentHorizontalResolution
        $horizontalresolution = $videoController.CurrentVerticalResolution
        $currentScreenResolution = "$verticalresolution x $horizontalresolution Pixels" 
 

        if ($name) {
            "Name: $name"
        } else {
            "Name: N/A"
        }
        
        if ($description) {
            "Description: $description"
        } else {
            "Description: N/A"
        }
        
        
        if ($videoProcessor) {
            "Video Processor: $videoProcessor"
        } else {
            "Video Processor: N/A"
        }

        if ($currentScreenResolution) {
            "Current Screen Resolution: $currentScreenResolution"
        } else {
            "Current Screen Resolution: N/A"
            }

        ""
    }
}

VideoCardReport














