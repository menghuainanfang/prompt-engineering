param(
    [Parameter(Mandatory = $true)]
    [string]$Inbox,
    [string]$OutputDirectory = (Join-Path $PSScriptRoot '..\exports\anki')
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $Inbox)) {
    throw "Anki card inbox was not found: $Inbox"
}

$rows = @(Import-Csv -LiteralPath $Inbox -Delimiter "`t" -Encoding utf8)
$requiredColumns = @('Status', 'Front', 'Back', 'Tags', 'Deck', 'Source')
$actualColumns = @($rows | Select-Object -First 1 | ForEach-Object { $_.PSObject.Properties.Name })
if ($rows.Count -eq 0) {
    $header = Get-Content -LiteralPath $Inbox -TotalCount 1
    $actualColumns = @($header -split "`t")
}
$missingColumns = @($requiredColumns | Where-Object { $_ -notin $actualColumns })
if ($missingColumns.Count -gt 0) {
    throw "The inbox is missing required columns: $($missingColumns -join ', ')"
}

$approved = @($rows | Where-Object { $_.Status.Trim() -eq '通过' })
if ($approved.Count -eq 0) {
    throw 'No cards are marked as 通过. Review candidates before exporting.'
}

$invalid = @($approved | Where-Object { [string]::IsNullOrWhiteSpace($_.Front) -or [string]::IsNullOrWhiteSpace($_.Back) })
if ($invalid.Count -gt 0) {
    throw "$($invalid.Count) approved card(s) have an empty Front or Back."
}

$duplicates = @($approved | Group-Object { $_.Front.Trim().ToLowerInvariant() } | Where-Object Count -gt 1)
if ($duplicates.Count -gt 0) {
    throw "Approved cards contain duplicate Front values: $((@($duplicates.Name)) -join '; ')"
}

$exportRows = foreach ($row in $approved) {
    $back = $row.Back.Trim()
    if (-not [string]::IsNullOrWhiteSpace($row.Source)) {
        $back = "$back；来源：$($row.Source.Trim())"
    }
    [pscustomobject]@{
        Front = $row.Front.Trim()
        Back  = $back
        Tags  = $row.Tags.Trim()
        Deck  = if ([string]::IsNullOrWhiteSpace($row.Deck)) { '学习闭环' } else { $row.Deck.Trim() }
    }
}

New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$destination = Join-Path $OutputDirectory "anki-import-$stamp.tsv"
$csvLines = @($exportRows | ConvertTo-Csv -Delimiter "`t" -NoTypeInformation)
$body = if ($csvLines.Count -gt 1) { $csvLines[1..($csvLines.Count - 1)] } else { @() }
$lines = @(
    '#separator:Tab'
    '#html:false'
    '#tags column:3'
    '#deck column:4'
    "#columns:Front`tBack`tTags`tDeck"
) + $body

[IO.File]::WriteAllLines($destination, $lines, [Text.UTF8Encoding]::new($false))
Write-Host "Prepared $($approved.Count) approved card(s): $destination"
Write-Host 'Inspect Anki import preview before confirming the import. The candidate inbox was not modified.'
