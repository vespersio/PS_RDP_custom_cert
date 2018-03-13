cls
$nsupdate_my = Get-ChildItem -Path Cert:\LocalMachine\My | where {$_.Subject -match 'rdp.contoso.com'}
$terminalservices = Get-WmiObject -class "Win32_TSGeneralSetting" -Namespace root\cimv2\terminalservices
if ($terminalservices.SSLCertificateSHA1Hash -ne $nsupdate_my.Thumbprint)
{
    'NeOK'
    $new_hash = $nsupdate_my.Thumbprint
    Set-WmiInstance -Path $terminalservices.__PATH -Arguments @{SSLCertificateSHA1Hash=$new_hash}
    Restart-Service -Name TermService -Force
}
else
{
    'OK'
}
