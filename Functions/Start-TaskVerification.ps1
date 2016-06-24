function Start-TaskVerification {
    Param(
        [hashtable[]]$Subtasks,
        [hashtable]$ResultTree,
        [object]$Result,
        [hashtable]$Arguments,
        [int]$SubtaskLevel = 0
    )

    $Tasks = @($Subtasks | % {@{
        Path = $_.Path
        Alias = "Verification Step: $($_.Path)"
        Arguments = @{
            ResultTree = $ResultTree
            Result = $Result
            Arguments = $Arguments
            Test = $_.Test
        }
        Action = {
            Param(
                [hashtable]$Arguments
            )
            $TestResult = & $Arguments.Test $Arguments.ResultTree $Arguments.Result $Arguments.Arguments
            Write-Color "Status -> "
            if ($TestResult) {
                Write-Color @(@{Value = "Passed"; Color = "Green"}, "`r`n")
            } else {
                Write-Color @( @{Value = "Failed"; Color = "Red"}, "`r`n")
            }
            return $TestResult
        }
    }})

    return (Start-TaskList $Tasks -Colors @{Alias = "Cyan"} -SubtaskLevel ($SubtaskLevel + 1)).Action
}