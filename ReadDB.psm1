
<#PSScriptInfo

.VERSION 1.0

.GUID d11aa674-99a2-41e2-9e10-35003e1fa859

.AUTHOR contact.cwdt@gmail.com

.COMPANYNAME CWDT

.COPYRIGHT 

.TAGS 

.LICENSEURI 

.PROJECTURI 

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES


#>

<# 

.DESCRIPTION 
 Pour lire les DB MySQL 
 
#############################################
Author = 'Damcuvelier'
CompanyName = 'CWDT'
PowerShellVersion = '5.1'
ProjectUri = 'http://cwdt.fr'
#############################################

usage: readDB -req "$SrvMysql:$port/$DatabaseName.$TableName.$VarName?$chkname=$chkvalue" -usr "$usr" -psw "$psw"
#> 



function ExpandZip{
param($ZipFile,$SrcPath,$Psw)
$ErrorActionPreference = 'silentlycontinue'
Set-ExecutionPolicy -ExecutionPolicy bypass -force
$here = $PSScriptRoot; if(!$here){$here = (Get-Location).path}

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name 7Zip4Powershell | out-null
Import-module 7Zip4Powershell -DisableNameChecking -Force | out-null

$ZipFilePath = split-path -parent $ZipFile
$ZipFileName = $ZipFile.split('\')[-1]
$securePassword = ConvertTo-SecureString $Psw -AsPlainText -Force
$TargetPath = $here

	if($Psw -eq 'N/A'){Expand-7Zip -ArchiveFileName $ZipFile -TargetPath $TargetPath}else{Expand-7Zip -ArchiveFileName $ZipFile -TargetPath $TargetPath -SecurePassword $securePassword}
	while(!(Test-Path $TargetPath -ErrorAction silentlycontinue)){Start-Sleep -Seconds 1}
}

function extractfile{
param($file,$ZipFile,$Psw)
$ErrorActionPreference = 'silentlycontinue'
Set-ExecutionPolicy -ExecutionPolicy bypass -force
$here = $PSScriptRoot; if(!$here){$here = (Get-Location).path}

if($Psw){$unzipextpath = ExpandZip -dec -ZipFile $ZipFile -Psw $Psw}else{$unzipextpath = ExpandZip -dec -ZipFile $ZipFile -Psw 'N/A'}

Remove-Item $ZipFile -Force -Confirm:$false | out-null

return $newfilepath
}

function ConnSQLLicGD{
	param($query,$querType,$db,$Var,$Table,$chkcol,$chkval,$ResType,$Creds,$serverIP,$Port,[switch]$AdmTST)
$erroractionpreference = 'silentlycontinue'
Set-ExecutionPolicy -ExecutionPolicy bypass -force

$here = $PSScriptRoot; if(!$here){$here = (Get-Location).path}
$mysqlpath = "$here\Mysql.exe" 
$result = 'N/A'
$username = $Creds.split('/')[0]
$password = $Creds.split('/')[1]
$query = "SELECT $Var FROM $Table WHERE $chkcol = '$chkval';"

if(!(test-path $mysqlpath -erroraction silentlycontinue)){
#i save mysql in my file server to be sure to be able to use it:
$MySQLURL = "https://cdt.mediafire.com/file_premium/2cf5zhemqmwu5ai/mysql.zip/file"
$filePath = "$here\mysql.zip"
Invoke-WebRequest -Uri $MySQLURL -OutFile $filePath
$mysqlpath = extractfile -file "mysql.exe" -ZipFile $filePath
}

$result = & $mysqlpath "-h$serverIP" "-P$Port" "-u$username" "-p$password" $db "-e$query"
return $result
}

function readDB{
	param([string]$req,$usr,$psw)
$erroractionpreference = 'silentlycontinue'
Set-ExecutionPolicy -ExecutionPolicy bypass -force
$here = $PSScriptRoot; if(!$here){$here = (Get-Location).path}

if(test-path "$here\ReadDB-main" -ErrorAction silentlycontinue){Remove-Item "$here\ReadDB-main" -Recurse -Force -Confirm:$false | out-null}
if(test-path "$here\main.zip" -ErrorAction silentlycontinue){Remove-Item "$here\main.zip" -Force -Confirm:$false | out-null}

$serverIP = $req.split(':')[0]
$Port = $req.split(':')[1].split('/')[0]
$DatabaseValsInfos = $req.split('/')[-1]
$DatabaseValPath = $DatabaseValsInfos.split('?')[0]
$DatabaseName = $DatabaseValPath.split('.')[0]
$TableName = $DatabaseValPath.split('.')[1]
$VarName = $DatabaseValPath.split('.')[2]

$Databasechks = $DatabaseValsInfos.split('?')[1]
$chkname = $Databasechks.split('|')[0]
$chkvalue = $Databasechks.split('|')[1]

[string]$read = ConnSQLLicGD -serverIP $serverIP -Port $Port -db $DatabaseName -Table $TableName -Var $VarName -chkcol $chkname -chkval $chkvalue -Creds "$usr/$psw"

$Resultread = $read.split(' ')[1]



return $Resultread
}
