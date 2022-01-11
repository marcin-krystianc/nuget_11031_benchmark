$Env:MSBUILDDISABLENODEREUSE="1"

$iterationCount = 20

#$PROCESSORS = 1,2,4,8,16,32,64,128
$dir = (Get-Item .).FullName
$dotnet = "$dir\dotnet\dotnet.exe"

For ($m=0; $m -lt 2; $m++) {
#Foreach ($p in $PROCESSORS) {
For ($k=0; $k -lt 2; $k++) {
For ($j=0; $j -lt 2; $j++) {
For ($i=0; $i -lt $iterationCount; $i++)
{
# $Env:DOTNET_PROCESSOR_COUNT = "$p"	
 $Env:NUGET_MMAP_PACKAGE_EXTRACTION = "$j"	
 $Env:NUGET_ASYNC_PACKAGE_EXTRACTION = "$k"	
 & $dotnet nuget locals all --clear
 Start-Sleep -Seconds 5
 $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
 & .\NuGet.CommandLine\bin\Release\net472\NuGet.exe restore -force orleans\Orleans.sln
 $totalTime = $stopwatch.Elapsed.TotalSeconds
 Add-Content -Path results_windows_nuget.txt -Value "async=$Env:NUGET_ASYNC_PACKAGE_EXTRACTION,mmap=$Env:NUGET_MMAP_PACKAGE_EXTRACTION,$totalTime"
}}}}