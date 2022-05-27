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

foreach($sampleArtifactCollection in $sampleCodeIndex)
{
  Write-Host "Deploying Sample Artifact Collection: $($sampleArtifactCollection.template)"
  Write-Host "-----------------------------------------------------------------------"

  #Create SQL Script artifacts.
  Write-Host "Deploying SQL Scripts:"
  Write-Host "-----------------------------------------------------------------------"
    foreach($sqlScript in $sampleArtifactCollection.artifacts.sqlScripts)
    {
      $fileContent = Invoke-WebRequest $sqlScript.definitionFilePath

      if ($sqlScript.tokens.length -gt 0) {
          foreach($token in $sqlScript.tokens)
          {
              $fileContent = $fileContent -replace $token, $synapseTokens.Get_Item($token)
          }
      }

      $definitionFilePath = [guid]::NewGuid()
      Set-Content -Path $definitionFilePath $fileContent
      Set-AzSynapseSqlScript -WorkspaceName $SynapseWorkspaceName -Name $sqlScript.name -DefinitionFile $definitionFilePath -FolderPath $sqlScript.workspaceFolderPath
      Remove-Item -Path $definitionFilePath
    }
}
