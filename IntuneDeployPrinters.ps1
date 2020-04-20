
<#

.SYNOPSIS
	This script is designed to automate the deployment of a printer to Windows 10 devices
	by using a blob storage to store the printer driver files. 
	The trigger for the creation was the deployment of a few printers over Intune. 

.DESCRIPTION
	Write by Spiros Karampinis, IT-Consultant
	https://www.linkedin.com/in/spikar
	Version 0.1 - 23.03.2020

.NOTES
	An Azure storage account, blob, will be needed to store the necessary files.
	Please upload the .INF .CAT and .CAB file of the driver. 
	Update the variables with your data. 

	This PowerShell script can be deployed over Intune as a Profile/Powershell Script.
	
	First of all, the script will download the driver files to a temp folder,
	thereafter will proceed by adding the printer driver and at the end the printer at itself.

	Please feel free to recommend any changes / improvements.
#>

# Azure blob storage folder
$azureBlob = "https://xxxxxx.blob.core.windows.net/yyyyy/"

# Printer configuration / variables
$printerInf = "CNP60MA64.INF"
$printerCab = "gppcl6.cab"
$printerCat = "cnp60m.cat"
$printerName = "Canon C5235"
$printerIP = "192.168.0.100"
$printerPort = ($printerIP + "-" + $printerName)

# You may find the name in INF file
$printerDriver = "Canon Generic Plus PCL6"

# Temp installation folder
$tempFolder = ("C:\Intune-" + $printerName)

### Execution - Action time
if (!(Get-Printer $printerName -ErrorAction SilentlyContinue)) {
Start-Transcript -OutputDirectory C:\
# Create Temp Folder
mkdir $tempFolder

# Download printer driver INF
Invoke-Webrequest ($azureBlob + "\" + $printerInf) -Outfile ($tempFolder + "\" + $printerInf)
Invoke-Webrequest ($azureBlob + "\" + $printerCab) -Outfile ($tempFolder + "\" + $printerCab)
Invoke-Webrequest ($azureBlob + "\" + $printerCat) -Outfile ($tempFolder + "\" + $printerCat)

# Add Driver to DriverStore
pnputil.exe /add-driver ($tempFolder + "\" + $printerInf)

# Install Printer Driver
Add-PrinterDriver $printerDriver

# Add Printer Port
Add-PrinterPort -Name $printerPort -PrinterHostAddress $printerIP -ErrorAction SilentlyContinue

# Install Printer
Add-Printer -Name $printerName -DriverName $printerDriver -PortName $printerPort

# Clean Up temp folder
del -R $tempFolder 
Stop-Transcript
} else {
Write-Host "$printerName already installed"
Stop-Transcript
 exit }
### Execution - Action time ended, no more fun