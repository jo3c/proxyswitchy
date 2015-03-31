
function SetDefault{
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -name ProxyServer -value "proxy.google.com:8080"
    SetPac
    echoServer
    echoPac
    ChooseProxy
}

function echoServer {
    Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" | select-object ProxyServer 
}
function SetPac {
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -name AutoConfigURL -value "http://pac.acml.com/"
    echoPac
}
function echoPac {
    Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" | select-object AutoConfigURL 
}
function DelPac {
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -name AutoConfigURL -value ""
    echoPac
}


function InputProxy {
    $inputProxy = read-host "[PROXY:PORT]"
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -name ProxyServer -value $inputProxy
    DelPac
    ChooseProxy
}


function Clear-IECachedData{
	[CmdletBinding(ConfirmImpact = 'None')]
	param(
		[Parameter(Mandatory = $false,
				   HelpMessage = ' Delete Temporary Internet Files')]
		[switch]
		$TempIEFiles,
		[Parameter(HelpMessage = 'Delete Cookies')]
		[switch]
		$Cookies,
		[Parameter(HelpMessage = 'Delete History')]
		[switch]
		$History,
		[Parameter(HelpMessage = 'Delete Form Data')]
		[switch]
		$FormData,
		[Parameter(HelpMessage = 'Delete Passwords')]
		[switch]
		$Passwords,
		[Parameter(HelpMessage = 'Delete All')]
		[switch]
		$All,
		[Parameter(HelpMessage = 'Delete Files and Settings Stored by Add-Ons')]
		[switch]
		$AddOnSettings
	)
	if ($TempIEFiles) { RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 8}
	if ($Cookies) { RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 2}
	if ($History) { RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 1}
	if ($FormData) { RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 16}
	if ($Passwords) { RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 32 }
	if ($All) { RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 255}
	if ($AddOnSettings) { RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 4351 }

    ChooseProxy
}

function IEOption {
    inetcpl.cpl
    ChooseProxy
}


function Cya {
    Write-Output "@joephchiang"
    pause
    exit
}

function ChooseProxy{
Write-Output "[PROXY]"
Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" | select-object ProxyServer, @{Name="[PAC FILE URL]";Expression={$_.AutoConfigURL}}
Write-Output "                                     "
Write-Output "              [CHOOSE A PROXY SERVER]"
Write-Output "                                     "
write-output "              [1]  INSERT PROXY SERVER CODE HERE"
write-output "              [2]  INPUT[PROXY:PORT]"
write-output "              [3]  IE CLEAR ALL HISTORY"
write-output "              [4]  INTERNET OPTIONS"
Write-Output "---------------------------------------------------------"

$proxy = read-host "[1-4]"

switch ($proxy) 
    { 
        1 {SetDefault}
        2 {InputProxy}
        3 {Clear-IECachedData -all}
        4 {IEOption}
        default {Cya}
    }
}

ChooseProxy