# powershell-acims
Cisco ACI Multi-Site PowerShell modules

Usage
-----

```powershell
$msoHost = 'aci-mso-01.fqdn'
$schema = 'schema1'
$templateName = 'template1'

Import-Module .\ACIMS.psd1 -Force

$credential = Get-Credential
$token = Connect-ACIMSAPI -MSOHost $msoHost -Credential $credential
$schemaId = (Get-ACIMSSchema -MSOHost $msoHost -Token $token | Where-Object { $_.displayName -eq $schema }).id

Get-ACIMSTenant -MSOHost $msoHost -Token $token

Get-ACIMSTemplate -MSOHost $msoHost -SchemaId $schemaId -Token $token

Get-ACIMSBridgeDomain -MSOHost $msoHost -SchemaId $schemaId -TemplateName $templateName -Token $token
```
