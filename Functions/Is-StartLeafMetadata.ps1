function Is-StartLeafMetadata {
    Param(
        [hashtable]$Metadata
    )

    return @("Path", "Action") | % {$HasAll = $true} {$HasAll = $HasAll -and $Metadata.ContainsKey($_)} {$HasAll}
}