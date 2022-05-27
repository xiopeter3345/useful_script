$SynapseWorkspaceName = "lazhusynapse"
$synapseTokens = @{"`#`#azsynapsewks`#`#" = $SynapseWorkspaceName; }
$indexFileUrl = "https://raw.githubusercontent.com/Azure/azure-synapse-analytics-end2end/main/Sample/index.json"
$sampleCodeIndex = Invoke-WebRequest $indexFileUrl | ConvertFrom-Json
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted


Uninstall-Module -Name Az.Synapse -RequiredVersion 1.4.0 -Force

Install-Module -Name Az.Synapse -RequiredVersion 1.3.0 -Force
$accountsVersion = Get-Module -ListAvailable -Name "Az.Accounts"
Write-Host $accountsVersion.Version
Get-Module -ListAvailable -Name "Az.Synapse"

