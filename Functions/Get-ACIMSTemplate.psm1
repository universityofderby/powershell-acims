function Get-ACIMSTemplate {
  <#
  .SYNOPSIS
  Get Cisco ACI Multi-Site templates for a schema.

  .DESCRIPTION
  Get Cisco ACI Multi-Site templates for a schema.

  .PARAMETER MSOHost
  [String] Cisco ACI Multi-Site host FQDN or IP address to connect to.

  .PARAMETER SchemaId
  [String] Cisco ACI Multi-Site schema ID.

  .PARAMETER SkipCertificateCheck
  [Switch] Skip certifcate check with Invoke-RestMethod.

  .PARAMETER Token
  [SecureString] Cisco ACI Multi-Site API bearer token.

  .OUTPUTS
  [PSObject] Cisco ACI Multi-Site schemas.

  .EXAMPLE
  PS> $templates = Get-ACIMSTemplate -MSOHost $ACI_MSO_host_FQDN_or_IP_address -SchemaId $schemaId -Token $token

  .EXAMPLE
  PS> Connect-ACIMSAPI -MSOHost aci-mso-01.fqdn | Get-ACIMSTemplate -MSOHost aci-mso-01.fqdn -SchemaId $schemaId
  
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
            # Return templates from response
            return ($response.templates)
        }
        catch {
            Write-Host $_.Exception
        }
    }
}