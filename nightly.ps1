param ([switch]$EnterPrise)

if ($EnterPrise) {
    $repo = 'ironmansoftware/universal-dashboard-enterprise'
}
else {
    $repo = "ironmansoftware/universal-dashboard"
}


$releases = "https://api.github.com/repos/$repo/releases"
$response = Invoke-WebRequest $releases
Write-Host Determining latest release
$download = ($response.Content | ConvertFrom-Json)[0].assets.browser_download_url[0]
$zip = $download -split "/" | Select-Object -Last 1
if (Test-Path .\temp) {
    Remove-Item .\temp -Recurse -Force
}
mkdir .\temp\ -ErrorAction SilentlyContinue
Write-Host Dowloading latest release
Invoke-WebRequest $download -Out .\temp\$zip

Write-Host Extracting release files
Expand-Archive .\temp\$zip -Force -DestinationPath .\temp\

# Cleaning up target dir
Remove-Item .\temp\$zip  -Force -ErrorAction SilentlyContinue
Remove-Item .\temp\web.config  -Force -ErrorAction SilentlyContinue
