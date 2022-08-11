# This is a script to get IP configuration using 'get-ciminstance win32_networkadapterconfiguration'.
# ---------------------------------------------------------------------------------------------------

get-ciminstance win32_networkadapterconfiguration | where-object {$_.IPEnabled -eq 'True'} | select Description,Index,IPAddress,IPSubnet,DNSDomain,DNSServerSearchOrder | format-table