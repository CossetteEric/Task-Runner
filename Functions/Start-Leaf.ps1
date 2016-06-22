function Start-Leaf {
    Param(
        [ValidateScript({Is-StartLeafMetadata $_})]
        [hashtable]$Metadata,
        [hashtable]$ResultTree = @{}
    )

    if ($Metadata.Guard -and !(& $Metadata.Guard $ResultTree)) {
        return
    }

    $Path = $Metadata.Path
    $Alias = if ($Metadata.Alias) {$Metadata.Alias} else {$Metadata.Path}
    $Description = $Metadata.Description

    $ColoredAlias = @(@{Value = "$Alias"; Color = "Green"}, "`r`n")

    $Message = @($ColoredAlias)
    if ($Description) {$Message += @($Description, "`r`n")}

    $Verify = $Metadata.Verify
    $Action = 
    if ($Metadata.Arguments) {
        {& $Metadata.Action $Metadata.Arguments $ResultTree}
    } else {
        {& $Metadata.Action $ResultTree}
    }

    try {
        $ActionResult = & $Action
    } catch [Exception] {
        if (!$Metadata.Errors -or !(& $Metadata.Errors $_.Exception.Message)) {
            throw $_
        } else {
            Write-Color @(@{Value = $_.Exception.Message; Color = "Yellow"}, "`r`n")
        }
    }

    $VerifyResult =
    if ($Metadata.Verify) {
        Verify-Leaf $Metadata.Verify $ResultTree $ActionResult
    } else {
        @{}
    }

    return @{
        Action = $ActionResult
        Verify = $VerifyResult
    }
}

