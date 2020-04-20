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
