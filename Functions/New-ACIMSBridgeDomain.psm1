function New-ACIMSBridgeDomain {
  <#
  .SYNOPSIS
  Create Cisco ACI Multi-Site bridge domain in an existing schema.

  .DESCRIPTION
  Create Cisco ACI Multi-Site bridge domain in an existing schema.

  .PARAMETER BridgeDomainDisplayName
  [String] Cisco ACI Multi-Site bridge domain display name.

  .PARAMETER BridgeDomainName
  [String] Cisco ACI Multi-Site bridge domain name.

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

  .PARAMETER VrfName
  [String] Cisco ACI Multi-Site VRF name.

  .OUTPUTS
  [PSObject] Cisco ACI Multi-Site schemas.

  .EXAMPLE
  PS> New-ACIMSBridgeDomain -BridgeDomainName bd1 -BridgeDomainDisplayName 'BD 1' -MSOHost $ACI_MSO_host_FQDN_or_IP_address -SchemaId $schemaId -TemplateName $templateName -Token $token

  
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
        $BridgeDomainDisplayName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $BridgeDomainName,

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
        $Token,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $VrfName
    )
    
    begin {
        # Define variables
        # Define variables
        $body = @"
[{
   "op": "add",
   "path": "/templates/$TemplateName/bds/-",
   "value": {
     "name": "$BridgeDomainName",
     "displayName": "$BridgeDomainDisplayName",
     "l3UnknownMulticastFlooding": "opt-flood",
     "intersiteBumTrafficAllow": true,
     "multiDestinationFlooding": "encap-flood",
     "l2UnknownUnicast": "proxy",
     "l2Stretch": true,
     "vrfRef": "/schemas/$SchemaId/templates/$TemplateName/vrfs/$VrfName"
   }
}]
"@
        $contentType = 'application/json'
        $method = 'Patch'
        $uri = "https://$MSOHost/api/v1/schemas/$SchemaId"
    }

    process {
        try {
            # Login to Cisco ACI MSO API and save response
            $response = Invoke-RestMethod -Uri $uri -Method $method -Body $body -ContentType $contentType -Authentication Bearer -Token $Token -SkipCertificateCheck:$SkipCertificateCheck
            # Return response
            return ($response)
        }
        catch {
            Write-Host $_.Exception
        }
    }
}