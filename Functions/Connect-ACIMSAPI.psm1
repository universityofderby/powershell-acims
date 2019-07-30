function Connect-ACIMSAPI {
  <#
  .SYNOPSIS
  Login to Cisco ACI Multi-Site API and return bearer token.

  .DESCRIPTION
  Login to Cisco ACI Multi-Site API and return bearer token.

  .PARAMETER Credential
  [PSCredential] Credential to connect to Cisco ACI Multi-Site API.

  .PARAMETER MSOHost
  [String] Cisco ACI Multi-Site host FQDN or IP address to connect to.

  .PARAMETER SkipCertificateCheck
  [Switch] Skip certifcate check with Invoke-RestMethod.

  .OUTPUTS
  [SecureString] If the login is successful, a bearer token is returned as a secure string to use with future API calls.

  .EXAMPLE
  PS> $token = Connect-ACIMSAPI -MSOHost $ACI_MSO_host_FQDN_or_IP_address -Credential $credential

  .EXAMPLE
  PS> $token = Connect-ACIMSAPI -MSOHost aci-mso-01.fqdn

  .EXAMPLE
  PS> $token = Connect-ACIMSAPI -MSOHost 1.2.3.4

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
        [PSCredential]
        $Credential = (Get-Credential),

        [Parameter()]
        [Switch]
        $SkipCertificateCheck = $true
    )
    
    begin {
        # Define variables
        $body = @"
{
  "username": "$($Credential.GetNetworkCredential().UserName)",
  "password": "$($Credential.GetNetworkCredential().Password)"
}
"@
        $contentType = 'application/json'
        $method = 'Post'
        $uri = "https://$MSOHost/api/v1/auth/login"
    }

    process {
        try {
            # Login to Cisco ACI MSO API and save response
            $response = Invoke-RestMethod -Uri $uri -Method $method -Body $body -ContentType $contentType -SkipCertificateCheck:$SkipCertificateCheck
            # Return bearer token as secure string
            return (ConvertTo-SecureString -String $response.token -AsPlainText -Force)
        }
        catch {
            Write-Host $_.Exception
        }
    }
}