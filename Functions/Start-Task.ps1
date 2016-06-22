function Start-Task {
    Param(
        [ValidateScript({Is-Task $_})]
        [hashtable]$Task,
        [hashtable]$ResultTree = @{}
    )

    if ($Task.Guard -and !(& $Task.Guard $ResultTree)) {
        return
    }

    $Path = $Task.Path
    $Alias = if ($Task.Alias) {$Task.Alias} else {$Task.Path}
    $Description = $Task.Description

    $ColoredAlias = @(@{Value = "$Alias"; Color = "Green"}, "`r`n")

    $Message = @($ColoredAlias)
    if ($Description) {$Message += @($Description, "`r`n")}

    $Verify = $Task.Verify
    $Action = 
    if ($Task.Arguments) {
        {& $Task.Action $Task.Arguments $ResultTree}
    } else {
        {& $Task.Action $ResultTree}
    }

    Write-Color $Message

    try {
        $ActionResult = & $Action
    } catch [Exception] {
        if (!$Task.Errors -or !(& $Task.Errors $_.Exception.Message)) {
            throw $_
        } else {
            Write-Color @(@{Value = $_.Exception.Message; Color = "Yellow"}, "`r`n")
        }
    }

    $VerifyResult =
    if ($Task.Verify) {
        Start-TaskVerification $Task.Verify $ResultTree $ActionResult
    } else {
        @{}
    }

    return @{
        Action = $ActionResult
        Verify = $VerifyResult
    }
}

