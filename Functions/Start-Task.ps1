function Start-Task {
    Param(
        [ValidateScript({Is-Task $_})]
        [hashtable]$Task,
        [hashtable]$ResultTree = @{},
        [hashtable]$Colors = @{},
        [int]$SubtaskLevel = 0
    )

    $Path = $Task.Path
    $Alias = if ($Task.Alias) {$Task.Alias} else {$Task.Path}
    $Description = $Task.Description

    $TaskLevelName = "sub" * $SubtaskLevel + "task"
    $TaskLevelName = $TaskLevelName[0].ToString().ToUpper() + $TaskLevelName.SubString(1)

    $ColoredAlias = @(@{Value = "$TaskLevelName`: $Alias"; Color = $Colors.Alias}, "`r`n")

    $Message = @($ColoredAlias)
    if ($Description) {$Message += @($Description, "`r`n")}

    $Errors = $Task.Errors
    $Skip = if ($Task.Skip) {
        if ($Task.Arguments) {
            {& $Task.Skip $Task.Arguments $ResultTree}
        } else {
            {& $Task.Skip $ResultTree}
        }
    }
    $Verify = $Task.Verify
    $Action = 
    if ($Task.Arguments) {
        {& $Task.Action $Task.Arguments $ResultTree}
    } else {
        {& $Task.Action $ResultTree}
    }

    Write-Color $Message

    if (!$Skip -or !(& $Skip $ResultTree)) {
        try {
            $ActionResult = & $Action
        } catch [Exception] {
            if (!$Errors -or !(& $Errors $_.Exception.Message)) {
                throw $_
            } else {
                Write-Color @(@{Value = $_.Exception.Message; Color = $Colors.Error}, "`r`n")
            }
        }
    } else {
        Write-Color @(@{Value = "Skipped Action"; Color = $Colors.Skip}, "`r`n")
    }

    $VerifyResult =
    if ($Verify) {
        Start-TaskVerification $Verify $ResultTree $ActionResult $Task.Arguments $SubtaskLevel
    } else {
        @{}
    }

    return @{
        Action = $ActionResult
        Verify = $VerifyResult
    }
}

