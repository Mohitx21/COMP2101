write-output "----------| Section 1 |----------"
function get-computersystem {
	get-ciminstance win32_computersystem | select Description | fl
}
get-computersystem


write-output "----------| Section 2 |----------"
function get-operatingsystem {
	get-ciminstance win32_operatingsystem | select Version,Name | fl
}
get-operatingsystem


write-output "----------| Section 3 |----------"
function get-processor {
	get-ciminstance win32_processor | select Description,NumberOfCores,L2CacheSize,L3CacheSize,MaxClockSpeed | fl
}
get-processor


write-output "----------| Section 4 |----------"
function get-physicalmemmory {
	$memory = get-ciminstance win32_physicalmemory | select Manufacturer,Description,BankLabel,DeviceLocator,Capacity
	$totalmemory = 0

	foreach($mem in $memory) {
		$totalmemory = $totalmemory + $mem.capacity
	}
	$totalmemory = $totalmemory / 1gb
	
	$memory | ft
	Write-Output "Total RAM installed in device is : $totalmemory GB"
}
get-physicalmemmory


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
$output1 = get-physicaldisk
$output1 | ft


write-output "----------| Section 6 |----------"
function get-networkadapterconfiguration {
	get-ciminstance win32_networkadapterconfiguration | where-object {$_.IPEnabled -eq 'True'} | select Description,Index,IPAddress,IPSubnet,DNSDomain,DNSServerSearchOrder | ft
}
get-networkadapterconfiguration


write-output "----------| Section 7 |----------"
function get-videocontroller {
	$vcoutput = get-ciminstance win32_videocontroller | select Caption,Description,CurrentHorizontalResolution,CurrentVerticalResolution
	$horizontalresolution = $vcoutput.CurrentHorizontalResolution
	$verticalresolution = $vcoutput.CurrentVerticalResolution
	$result = "$horizontalresolution x $verticalresolution"
	New-Object -Typename psobject -Property @{Vendor=$vcoutput.Caption
						  Description=$vcoutput.Description
						  "Screen Resolution is "=$result
						}
}
$output2 = get-videocontroller
$output2 | fl
