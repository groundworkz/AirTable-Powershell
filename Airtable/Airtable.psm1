# This module is in beta and needs to be finished.

function Add-AirTableData {
    param (
        [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][String]$AirTableAPIKey,
        [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][String]$AirTableBase,
        [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][String]$AirTableTable,
        [Parameter(Mandatory = $true)][System.Management.Automation.PSCustomObject]$AirTableFields
    )
    $TableData = [pscustomobject]@{ 
        records = @( [pscustomobject]@{fields = $AirTableFields } )
    }
    $AirtableHeaders = @{
        Authorization = "Bearer $($AirtableAPI)"
    }
    try {
        $Response = Invoke-webrequest -uri "https://api.airtable.com/v0/$($BASE)/$($Table)" -Headers $AirtableHeaders -Method POST -Body ($TableData | ConvertTo-Json -Depth 5 -Compress) -ContentType application/json -ErrorAction Stop
    }
    catch [System.Net.WebException] { 
        Write-Host $_.Exception.Message -ForegroundColor Red
    }
    if ($Response.StatusCode -eq 200) {
        Return $Response.Content
    }
    elseif ($Response.StatusCode) {
        Write-Host "Error. HTTP Response code: [$($Response.StatusCode)]" -ForegroundColor Red
        Break
    }
}
