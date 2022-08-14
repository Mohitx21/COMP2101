Param ([Parameter (Mandatory=$false)][switch]$System,
       [Parameter (Mandatory=$false)][switch]$Disk,
       [Parameter (Mandatory=$false)][switch]$Network )

if($System) {
	get-processor
	get-operatingsystem
	get-physicalmemmory
	get-videocontroller
}

if($Disk) {
	get-physicaldisk
}

if($Network) {
	get-networkadapterconfiguration
}

if((!$System) -and (!$Disk) -and (!$Network)) {
	get-processor
	get-operatingsystem
	get-physicalmemmory
	get-videocontroller
	get-networkadapterconfiguration
	get-physicaldisk
}
