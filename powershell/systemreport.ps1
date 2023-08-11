param (
    [switch]$System,
    [switch]$Disks,
    [switch]$Network
)



function systemreport {
    ""
    "CPU Report"
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

    
    ""
    "PROCESSORS"
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



""
"RAM REPORT"
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
    ""
    "VIDEO CARD REPORT"
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

    systemreport

function diskreport {
""
"DISK REPORT"
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
"NETWORK REPORT (ENABLED ADAPTERS)"
$networkReport = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object ipenabled
if ($networkReport) {
    $networkReport | Select-Object Description, IPAddress, DNSServerSearchOrder, DNSDomainSuffixSearchOrder, Index, IPSubnet | Format-Table -AutoSize
} else {
    "N/A"
}
}

networkReport



if ($System) {
    systemReport
} else {
    systemReport
    diskreport
    networkReport
}
