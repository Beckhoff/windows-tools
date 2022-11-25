############################
## Install RTE Driver
############################

$adapter_name = "Ethernet"

# Install driver for adapter
Start-Process -Wait C:\TwinCAT\3.1\System\TcRteInstall.exe -ArgumentList "-installnic $adapter_name /S" -PassThru

############################