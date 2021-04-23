<#
 .Synopsis
  !This module is in beta and needs to be finished!
  Provides a module to interact with airtables via powreshell

 .Description
  Also allows you to create, modify and delete airtable objects.
  (Create is the only function that is completed)

 .Parameter AirTableAPIKey
  Use your Airtable API Key, which can be found here: https://airtable.com/account

 .Parameter AirTableBase
  The base instance of your Airtable instance.
  Your airtablebase can be found in the API Help section of the Airtable website.
  (i.e. think of it like your excel workbook)

 .Parameter AirTableTable
  The table within the base of your Airtable instance
  Your airtabletable can be found in the API Help section of the Airtable website.
  (i.e. think of it like your tab in your excel workbook)

  .Parameter AirTableData
  The date within the table of your Airtable instance
  (i.e. think of it like your tab in your excel workbook)

  The pscustom object needs to be converted to a json object first before passing to the function.
  The format needs to be:
  $AirtableData = (([pscustomobject]@{ 
      records = @( [pscustomobject]@{
          fields = [pscustomobject]@{
              'Firstname'        = 'Chris'
              'Surname'          = 'Hill'
              'Job Title'        = 'Astronaut'
              'Status'           = 'In Space'
          }
      } )
  }) | convertto-json -Depth 5 -Compress)

 .Example
   # Create a new airtable row
   Add-AirTableData -AirtableAPIKey "xxxxxxxxx" -AirtableBase "Employees" -AirtableTable "Jobs" -AirtableData "{"records":[{"fields":{"Firstname":"Chris","Surname":"Hill","Job Title":"Astronaut","Status":"In Space"}}]}"

#>


function Add-AirTableData {
    param (
        [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][String]$AirTableAPIKey,
        [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][String]$AirTableBase,
        [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][String]$AirTableTable,
        [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][String]$AirTableData
    )
    Write-Host "Uploading data to Airtable"
    $AirtableHeaders = @{
        Authorization = "Bearer $($AirtableAPIKey)"
    }
    try {
        $Response = Invoke-webrequest -uri "https://api.airtable.com/v0/$($AirtableBase)/$($AirtableTable)" -Headers $AirtableHeaders -Method POST -Body $AirTableData -ContentType application/json -ErrorAction Stop
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
