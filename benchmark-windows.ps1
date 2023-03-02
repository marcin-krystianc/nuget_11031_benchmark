
$iterationCount = 1

$dir = (Get-Item .).FullName
$dotnet = "$dir\dotnet\dotnet.exe"
& $dotnet nuget locals -l all
& $dotnet restore -clp:summary --force /p:RestoreUseStaticGraphEvaluation=true LargeAppWithPrivatePackagesCentralisedNGBVRemoved\solution

$Env:MSBUILDDISABLENODEREUSE="1"
$Env:MSBUILDALWAYSDELETEBEFORECOPY = "1"
For ($i=0; $i -lt $iterationCount; $i++)
{
 Start-Sleep -Seconds 5
 $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
 & $dotnet build -clp:summary --no-restore /bl LargeAppWithPrivatePackagesCentralisedNGBVRemoved\solution
 $totalTime = $stopwatch.Elapsed.TotalSeconds
 Add-Content -Path results_windows_dotnet.txt -Value "async=$Env:NUGET_ASYNC_PACKAGE_EXTRACTION,mmap=$Env:NUGET_MMAP_PACKAGE_EXTRACTION,$totalTime"
}