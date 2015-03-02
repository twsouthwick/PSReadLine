if (-not(Get-Command -Name nuget -ErrorAction Ignore))
{
    Write-Warning "Cannot find nuget"
	exit
}

if (-not(Get-Command -Name msbuild -ErrorAction Ignore))
{
	Write-Warning "Cannot find msbuild"
	exit
}

msbuild $PSScriptRoot\PSReadline\PSReadLine.sln /t:Rebuild /p:Configuration=Release

$targetDir = "${env:Temp}\PSReadline-vim"

if (Test-Path -Path $targetDir)
{
    rmdir -Recurse $targetDir
}

$null = mkdir $targetDir
$null = mkdir $targetDir\en-US

$files = @('PSReadline\Changes.txt',
           'PSReadline\License.txt',
           'PSReadline\SamplePSReadlineProfile.ps1',
           'PSReadline\PSReadline-vim.psd1',
           'PSReadline\PSReadline-vim.psm1',
           'PSReadline\PSReadline.format.ps1xml',
           'PSReadline\bin\Release\PSReadline.dll')

foreach ($file in $files)
{
    copy $PSScriptRoot\$file $targetDir
}

$files = @('PSReadline\en-US\about_PSReadline.help.txt',
           'PSReadline\en-US\PSReadline.dll-help.xml')

foreach ($file in $files)
{
    copy $PSScriptRoot\$file $targetDir\en-us
}

#make sure chocolatey is installed and in the path
#if ($BuildChocolatey -and (Get-Command -Name cpack -ErrorAction Ignore))

copy $PSScriptRoot\PSReadline-vim.nuspec $targetDir

nuget pack "$targetDir\PSReadline-vim.nuspec" -NonInteractive -NoPackageAnalysis

