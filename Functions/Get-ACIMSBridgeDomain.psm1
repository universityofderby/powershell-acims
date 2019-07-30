function Get-ACIMSBridgeDomain {
  <#
  .SYNOPSIS
  Get Cisco ACI Multi-Site bridge domains for a schema template.

  .DESCRIPTION
  Get Cisco ACI Multi-Site bridge domain for a schema template.

  .PARAMETER MSOHost
  [String] Cisco ACI Multi-Site host FQDN or IP address to connect to.

  .PARAMETER SchemaId
  [String] Cisco ACI Multi-Site schema ID.

  .PARAMETER SkipCertificateCheck
  [Switch] Skip certifcate check with Invoke-RestMethod.

  .PARAMETER TemplateName
  [String] Cisco ACI Multi-Site template name.

  .PARAMETER Token
  [SecureString] Cisco ACI Multi-Site API bearer token.

  .OUTPUTS
  [PSObject] Cisco ACI Multi-Site schemas.

  .EXAMPLE
  PS> $bds = Get-ACIMSBridgeDomain -MSOHost $ACI_MSO_host_FQDN_or_IP_address -SchemaId $schemaId -TemplateName $templateName -Token $token

  .EXAMPLE
  PS> Connect-ACIMSAPI -MSOHost aci-mso-01.fqdn | Get-ACIMSBridgeDomain -MSOHost aci-mso-01.fqdn -SchemaId $schemaId -TemplateName $templateName
  
  .NOTES
    Version: 0.1.0 - Initial version
    Date: 2019-07-25
    
    Author: Richard Lock
  
    Dependencies: PowerShell 6+
  #>
      
    # Cmdlet parameters
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $MSOHost,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SchemaId,

        [Parameter()]
        [Switch]
        $SkipCertificateCheck = $true,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TemplateName,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [SecureString]
        $Token
    )
    
    begin {
        # Define variables
        $method = 'Get'
        $uri = "https://$MSOHost/api/v1/schemas/$SchemaId"
    }

    process {
        try {
            # Login to Cisco ACI MSO API and save response
            $response = Invoke-RestMethod -Uri $uri -Method $method -Authentication Bearer -Token $Token -SkipCertificateCheck:$SkipCertificateCheck
            # Return bridge domains from response
            return ($response.templates | Where-object { $_.name -eq $TemplateName } | Select bds -ExpandProperty bds)
        }
        catch {
            Write-Host $_.Exception
        }
    }
}