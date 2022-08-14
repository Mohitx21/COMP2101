# 'welcome' function to print welcome message.
# --------------------------------------------
function welcome {
	write-output "Welcome to planet $env:computername Overlord $env:username"
	$now = get-date -format 'HH:MM tt on dddd'
	write-output "It is $now."
}


# 'get-cpuinfo' function to print out CPU information.
# ----------------------------------------------------
function get-cpuinfo {
	Get-CimInstance CIM_Processor | ft Caption,Manufacturer,CurrentClockSpeed,MaxClockSpeed,NumberOfCores
}


# 'get-mydisks' function to print disk information.
# -------------------------------------------------
function get-mydisks {
	WMIC DiskDrive Get Model,Manufacturer,SerialNumber,FirmwareRevision,Size | ft
}


# This function list computer system details.
# -------------------------------------------

write-output "----------| Section 1 |----------"
function get-computersystem {
	get-ciminstance win32_computersystem | select Description | fl
}


# This function list operating system details.
# --------------------------------------------

write-output "----------| Section 2 |----------"
function get-operatingsystem {
	get-ciminstance win32_operatingsystem | select Name,Version | fl
}


# This function list processor details.
# -------------------------------------

write-output "----------| Section 3 |----------"
function get-processor {
	get-ciminstance win32_processor | select Description,MaxClockSpeed,NumberOfCores,L2CacheSize,L3CacheSize | fl
}


# This function list physical memory details.
# -------------------------------------------

write-output "----------| Section 4 |----------"
function get-physicalmemmory {
	$memory = get-ciminstance win32_physicalmemory | select Description,Manufacturer,BankLabel,DeviceLocator,Capacity
	$totalmemory = 0

	foreach($mem in $memory) {
		$totalmemory = $totalmemory + $mem.capacity
	}
	$totalmemory = $totalmemory / 1gb
	
	$memory | ft
	Write-Output "Total RAM installed in device is : $totalmemory GB"
}


# This function list disk details.
# --------------------------------

write-output "----------| Section 5 |----------"
function get-physicaldisk {
	$diskdrives = Get-CIMInstance CIM_diskdrive
	foreach($disk in $diskdrives) {
		$partitions = $disk | get-cimassociatedinstance -resultclassname CIM_diskpartition
		foreach($partition in $partitions) {
			$logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
			foreach($logicaldisk in $logicaldisks) {
				new-object -typename psobject -property @{Vendor=$disk.Manufacturer
									Model=$disk.Model
									"Total logical disk size in (GB)"=$logicaldisk.Size / 1gb -as [int]
									"Total free space in (GB)"=$logicaldisk.FreeSpace / 1gb -as [int]
									"Total free percentage space in (GB)"=( $logicaldisk.FreeSpace / $logicaldisk.Size ) * 100 -as [float]
													}
			}
		}
	}
}


# This function list network adapter details.
# -------------------------------------------

write-output "----------| Section 6 |----------"
function get-networkadapterconfiguration {
	get-ciminstance win32_networkadapterconfiguration | where-object {$_.IPEnabled -eq 'True'} | select Description,Index,IPAddress,IPSubnet,DNSDomain,DNSServerSearchOrder | ft
}


# This function list video controller details.
# --------------------------------------------

write-output "----------| Section 7 |----------"
function get-videocontroller {
	$vcoutput = get-ciminstance win32_videocontroller | select Description,Caption,CurrentHorizontalResolution,CurrentVerticalResolution
	$hr = $vcoutput.CurrentHorizontalResolution
	$vr = $vcoutput.CurrentVerticalResolution
	$res = "$hr x $vr"
	New-Object -Typename psobject -Property @{Vendor=$vcoutput.Caption
						  Description=$vcoutput.Description
						  "Screen Resolution is "=$res
						}
}