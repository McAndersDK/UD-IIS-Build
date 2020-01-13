param(
    [switch]$Nightly,
    [switch]$Enterprise
)
if (Test-Path .\temp -PathType Container) {

}
else {
    new-item .\temp -ItemType Directory -Force
}
if ($Enterprise) {
    $Modulename = 'UniversalDashboard'
}
else {
    $Modulename = 'UniversalDashboard.Community'
}

.\cleanUp.ps1 -ModuleName $Modulename


if ($Nightly) {
    .\nightly.ps1 -EnterPrise:$Enterprise
    Move-Item -Path .\temp\* -Exclude "web.config" -Destination .\ -Force -ErrorAction SilentlyContinue
}
else {
    import-module powershellget
    $NewUDmodule = Find-Module $Modulename
    $OldUDmodule = get-module $Modulename  -ListAvailable | Select-Object -First 1
    if ($OldUDmodule.Version -lt $NewUDmodule.Version) {
        "There is a new version of UD: " + $NewUDmodule.Version
        $prompt = Read-Host -Prompt 'Update? (yes or no)'
        if ($prompt -eq 'yes') {
            save-Module -InputObject $NewUDmodule -AcceptLicense  -Path .\temp\
            $UDModulepath = ".\temp\$Modulename\$($NewUDmodule.version)"
        }
        else {
            $UDModulepath = $OldUDmodule.moduleBase
        }
    }
    else {
        $UDModulepath = $OldUDmodule.moduleBase
    }

    Copy-Item -path "$UDModulepath\client" -Recurse -Force -ErrorAction SilentlyContinue -Destination .\
    Copy-Item -path "$UDModulepath\en-US" -Recurse -Force  -ErrorAction SilentlyContinue -Destination .\
    Copy-Item -path "$UDModulepath\Modules" -Recurse -Force -ErrorAction SilentlyContinue -Destination .\Modules
    Copy-Item -path "$UDModulepath\net472" -Recurse -Force -ErrorAction SilentlyContinue -Destination .\net472
    Copy-Item -path "$UDModulepath\netstandard2.0" -Recurse -Force -ErrorAction SilentlyContinue -Destination .\netstandard2.0
    Copy-Item -path "$UDModulepath\poshud" -Recurse -Force -ErrorAction SilentlyContinue -Destination .\poshud
    Copy-Item -path "$UDModulepath\$Modulename.psd1" -Recurse -Force -ErrorAction SilentlyContinue -Destination .\
    Copy-Item -path "$UDModulepath\UniversalDashboard.Controls.psm1" -Recurse -Force -ErrorAction SilentlyContinue -Destination .\
    Copy-Item -path "$UDModulepath\UniversalDashboard.psm1" -Recurse -Force -ErrorAction SilentlyContinue -Destination .\
    Copy-Item -path "$UDModulepath\UniversalDashboardServer.psm1" -Recurse -Force -ErrorAction SilentlyContinue -Destination .\
}