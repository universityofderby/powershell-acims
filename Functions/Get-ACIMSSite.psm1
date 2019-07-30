function Get-ACIMSSite {
  <#
  .SYNOPSIS
  Get Cisco ACI Multi-Site sites.

  .DESCRIPTION
  Get Cisco ACI Multi-Site sites.

  .PARAMETER MSOHost
  [String] Cisco ACI Multi-Site host FQDN or IP address to connect to.

  .PARAMETER SkipCertificateCheck
  [Switch] Skip certifcate check with Invoke-RestMethod.

  .PARAMETER Token
  [SecureString] Cisco ACI Multi-Site API bearer token.

  .OUTPUTS
  [PSObject] Cisco ACI Multi-Site sites.

  .EXAMPLE
  PS> $sites = Get-ACIMSSite -MSOHost $ACI_MSO_host_FQDN_or_IP_address -Token $token

  .EXAMPLE
  PS> Connect-ACIMSAPI -MSOHost aci-mso-01.fqdn | Get-ACIMSSite -MSOHost aci-mso-01.fqdn
  
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

        [Parameter()]
        [Switch]
        $SkipCertificateCheck = $true,

        [Parameter(ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [SecureString]
        $Token
    )
    
    begin {
        # Define variables
        $method = 'Get'
        $uri = "https://$MSOHost/api/v1/sites"
    }

    process {
        try {
            # Login to Cisco ACI MSO API and save response
            $response = Invoke-RestMethod -Uri $uri -Method $method -Authentication Bearer -Token $Token -SkipCertificateCheck:$SkipCertificateCheck
            # Return sites from response
            return ($response.sites)
        }
        catch {
            Write-Host $_.Exception
        }
    }
}