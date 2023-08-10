
function get-cpuinfo {
    Get-CimInstance -ClassName Win32_Processor |
    Select-Object Manufacturer, Name, CurrentClockSpeed, MaxClockSpeed, NumberOfCores | select -last 1 #my output is duplicated on my VM so I type -last 1 for only last output
}
get-cpuinfo