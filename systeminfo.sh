#!/bin/bash
#condition that is only the script is exceutable by root permission
if [ "$(id -u)" != "0" ]; then
	echo "You need to be root for this script";
	exit 1
fi


#CPU REPORT

#Defining function of CPU Report
		 
 cpureport () {

#Variables that will be used for the CPU report function	

#Variable that describes the CPU Model and Manufacturer
cpumodel="$(lscpu | grep  'Model name' | awk '{print $3,$4,$5,$6}')" 

# Variable that describes the CPU Architecture
cpuarchitecture="$(lscpu | grep 'Architecture:'|sed 's/.*Architecture: *//')"

#Variable in which describes CPU core count
corecount="$(lscpu | grep 'Core(s) per socket:'|sed 's/.*Core(s) per socket: *//')"

#Variable that describes core maximum speed 
#coremaxspeed="$(lscpu | grep  'Intel(R) Core(TM) i7-6700HQ' | awk '{print $8}' )"

#sum of cache sizes stored in each variable: L1,L2 and L3
levelonecache="$(lscpu | grep  'L1i' | awk '{print $3}')"
leveltwocache="$(lscpu | grep  'L2' | awk '{print $3}')"
levelthreecache="$(lscpu | grep  'L3' | awk '{print $3}')"

   echo ""
   echo '                  CPU Report' # Title labeled "CPU Report"
   echo ""
   echo "CPU Manufacturer and Model: $cpumodel"
   echo "CPU Architecture: $cpuarchitecture"
   echo "Core Count: $corecount Socket "
   #echo "Core Max Speed: $coremaxspeed (Gigahertz)"
   echo "Sum of cache size"
   echo " Level 1: $levelonecache Kibibytes"
   echo " Level 2: $leveltwocache Kibibytes"
   echo " Level 3: $levelthreecache Kibibytes"
   echo ""  


     
}

cpureport





#COMPUTER REPORT
#Defining function of Computer Report

computerreport () {

#Variables describing computer manufacturer and serial number
compmanufacturer="$(dmidecode -s system-manufacturer)"
serial="$(dmidecode -s system-serial-number)"


   echo ""
   echo '                  Computer Report' # Title labeled "Computer Report"
   echo ""
   echo "Computer Manufacturer: $compmanufacturer"
   echo "Serial Number: $serial"
   
	   
     
}

computerreport


#OS REPORT

#Defining function of OS report
osreport () {

echo ""
#OS report tile
echo "OS Report"
echo"" 
#variable describing the Operating System
os=$(hostnamectl | grep 'Kernel:' | awk '{$1=""; print $0}')
if [ -z "$os" ]; then #if the os data cannot be found, it will prompt a message "data is unavailable, it is also applied to the next variable, distro and distro version
			os='Data is unavailable'
else os=$(hostnamectl | grep 'Kernel:' | awk '{$1=""; print $0}')
fi

echo "Operating System:$os"

#variable describing the type of distro
distro=$(hostnamectl | awk  'FNR == 7 {print $3}')
if [ -z "$distro" ]; then
			distro='Data is unavailable'
else distro=$(hostnamectl | awk  'FNR == 7 {print $3}')

fi

echo "Distro:$distro"


#variable describing the type of distro version
distroVersion=$(hostnamectl | awk  'FNR == 7 {print $4}')
if [ -z "$distroVersion" ]; then
			distroVersion='Data is unavailable'
else distroVersion=$(hostnamectl | awk  'FNR == 7 {print $4}')

fi

echo "Distro Version:$distroVersion"

   
     
}

osreport


#RAM Report

#Defining function of RAM report
componentReport() {
	#Variables that describe outputs for RAM information; will be used in the next variables
	demidecodeOutput=$(dmidecode)
	lshwOutput=$(lshw)

	#Variables the describe RAM manufacturer, RAM produc, RAM Serial number, RAM SIce, RAM Speed, RAM Location and Total RAM size in a human friendly format
	componentManufacturer=$(echo "$demidecodeOutput" | grep -m1 -i "manufacturer" | awk '{$1=""; print $0}')

	componentProduct=$(echo "$demidecodeOutput" | grep -m1 -i "Product name" | awk '{$1=""; $2=""; print $0}')

	componentSerialNum=$(echo "$demidecodeOutput" | grep -m1 -i "serial number" | awk '{$1=""; $2=""; print $0}')

	ramSize=$(echo "$lshwOutput" | grep -A10 "\-memory" | grep 'size:' | awk 'FNR == 2 {$1=""; print $0}')

	ramSpeed=$(echo "$demidecodeOutput" --type 17 | grep -m1 Speed | awk '{ $1=""; print $0 }')

	ramLocation=$(echo "$lshwOutput" | grep -m1 'slot: RAM' | awk '{$1=""; $2=""; print $0}')

	totalRamSize=$(echo "$lshwOutput" | grep -A5 "\-memory" | grep -m1 'size:' | awk '{$1=""; print $0}')

#Table that labels all the RAM information mentioned above
	componentTable=$(paste -d ';' <(echo "$componentManufacturer") <(echo "$componentProduct") <(echo "$componentSerialNum") <(echo "$ramSize") <(echo "$ramSpeed") <(echo "$ramLocation") <(echo "$totalRamSize") | column -N " Manufacturer","  Model",'  Serial Num'," Size"," Speed"," Location",' Total Size' -s ';' -o ' | ' -t)
	echo "              						Component Report"
	echo ""
	echo "$componentTable"   
   
	   
     
}

componentReport





#VIDEO REPORT



#defining function for video report
videoreport () {

videocardmanufacturer="$(lspci | grep 'VGA' | awk '{print$5}')"
videocardmodel="$(sudo lshw -short | grep 'display' | awk '{print $4,$5,$6}')"

   echo ""
   echo '                  Video Report' # Title labeled "Video Report"
   echo ""
   echo "Video Card Manufacturer: $videocardmanufacturer"
   echo "Video Card Model: $videocardmodel" 
   
   
    

   
     
}

videoreport

driveReport () {
echo ""
echo "Drive Report"
echo ""
diskManufacturer=$(lshw | grep -A10 "\-disk" | grep "vendor:" | awk '{print $2}')
driveModel=$(lshw | grep -A10 "\-disk" | grep "product:" | awk '{print $2,$3,$4}')
driveSize=$(lshw | grep -A10 "\-disk" | grep "size:" | awk '{print $3}')

echo "Disk Manufacturer:$diskManufacturer"

        
}

#DRIVE REPORT

#Defining Function for Drive report
driveReport () {

echo ""
echo "Drive Report"
echo ""
lshwOutput=$(lshw)
lsblkOutput=$(lsblk)
 
 #Variables that describes Drive componenents: Manufacturer,Vendor,Size,Partition, File System
 
driveManufacturer=$(echo "$lshwOutput" | grep -A10 '\*\-disk' | grep 'vendor:' | awk '{$1=""; print $0}')
driveVendorOne=$(echo "$lshwOutput"  | grep -m1 -A10 "\-volume:0" | grep "vendor:" | awk '{print $2}')
driveVendorTwo=$(echo "$lshwOutput"  | grep -m1 -A10 "\-volume:1" | grep "vendor:" | awk '{print $2}')
driveVendorThree=$(echo "$lshwOutput"  | grep -m1 -A10 "\-volume:2" | grep "vendor:" | awk '{print $2}')
driveModel=$(echo "$lshwOutput"  | grep -A10 "\-disk" | grep "product:" | awk '{print $2}')


driveSize0=$(echo "$lsblkOutput" | grep 'sda' | awk 'FNR==1 {print $4"B"}')
driveSize1=$(echo "$lsblkOutput" | grep 'sda' | awk 'FNR==2 {print $4"B"}')
driveSize2=$(echo "$lsblkOutput" | grep 'sda' | awk 'FNR==3 {print $4"B"}')
driveSize3=$(echo "$lsblkOutput" | grep 'sda' | awk 'FNR==4 {print $4"B"}')


partition0=$(echo "$lsblkOutput" | grep 'sda' | awk 'FNR==1 {print $1}')=
partition1=$(echo "$lsblkOutput" | grep 'sda1' | awk 'FNR==1 {print $1}' | tail -c 5)
partition2=$(echo "$lsblkOutput" | grep 'sda2' | awk 'FNR==1 {print $1}' | tail -c 5)
partition3=$(echo "$lsblkOutput" | grep 'sda3' | awk 'FNR==1 {print $1}' | tail -c 5)


driveFileSystem=$(echo "$lsblkOutput" | grep 'sda2' | awk 'FNR==1 {print $2"B"}')	
fileSystemFree=$(echo "$lsblkOutput" | grep 'sda2' | awk 'FNR==1 {print $4"B"}')	

			
echo "Drive Manufacturer: $driveManufacturer"
echo "Drive Vendor 1: $driveVendorOne"
echo "Drive Vendor 2: $driveVendorTwo"
echo "Drive Vendor 3: $driveVendorThree"
echo "Drive Size 0: $driveSize0"
echo "Drive Size 1: $driveSize1"
echo "Drive Size 2: $driveSize2"
echo "Drive Size 3: $driveSize3"

echo "Partition 0: $partition0"
echo "Partition 1: $partition1"
echo "Partition 2: $partition2"
echo "Partition 3: $partition3"


echo "Drive FIle System Size: $driveFileSystem"
echo "Drive File System Free: $fileSystemFree"

}

driveReport







#defining network report function
networkReport () {

#variables that describe, Interface manufacturer, interface model, description, internet speed, ip address, dns server, domain assosiated with the interface, link state
	interfaceManufacturer=$(lshw -class network | grep 'vendor' | awk '{print$2,$3}')
	interfaceModel=$(lshw -class network | grep 'product:' | awk '{print$2,$3}')
	interfaceDescription=$(lshw -class network | grep 'description:' | awk '{print$2,$3}')
	networkSpeed=$(ethtool ens33 | grep 'Speed:' | awk '{print$2}')
	ipAddress=$(ip a s ens33 | grep -w 'inet' | awk '{print$2}')
	dnsServer=$(resolvectl status | grep "DNS Servers:" | awk '{print$3}')
	dnsDomain=$(resolvectl status | grep "DNS Domain:" | awk '{print$3}')
	linkStateInterface=$(tcpdump --list-interfaces | grep '1.'|sed 's/.*1. *//'
)

#table that label the network data mentioned in the previous comment	
networkTable=$(paste -d ';' <(echo "$interfaceManufacturer") <(echo "$interfaceModel") <(echo "$interfaceDescription") <(echo "$networkSpeed") <(echo "$ipAddress") <(echo "$dnsServer") <(echo "$dnsDomain") <(echo "$linkStateInterface") | column -N Manufacturer,"Model","Description","Speed","IP Address","DNS Server","DNS Local Domain","Link State Interface" -s ';' -o ' | ' -t)
echo ""
echo "                                                                    Network Report"
echo ""
echo "$networkTable"
        
}

networkReport




	
	





