function Start-TaskVerification {
    Param(
        [hashtable[]]$Subtasks,
        [hashtable]$ResultTree,
        [object]$Result
    )

    $Tasks = @($Subtasks | % {@{
        Path = $_.Path
        Alias = "Verification Step: $($_.Path)"
        Arguments = @{
            ResultTree = $ResultTree
            Result = $Result
            Test = $_.Test
        }
        Action = {
            Param(
                [hashtable]$Arguments
            )
            Write-Color "Start -> "
            $TestResult = & $Arguments.Test $Arguments.ResultTree $Arguments.Result
            if ($TestResult) {
                Write-Color @(@{Value = "Passed"; Color = "Green"}, "`r`n")
            } else {
                Write-Color @( @{Value = "Failed"; Color = "Red"}, "`r`n")
            }
            return $TestResult
        }
    }})

    return (Start-TaskList $Tasks -Colors @{Alias = "Cyan"}).Action
}