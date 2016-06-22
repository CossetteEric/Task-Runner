function Start-TaskVerification {
    Param(
        [hashtable[]]$Subtasks,
        [hashtable]$ResultTree,
        [object]$Result
    )

    $Tasks = @($Subtasks | % {@{
        Path = $_.Path
        Arguments = @{
            ResultTree = $ResultTree
            Result = $Result
            Test = $_.Test
        }
        Action = [scriptblock]::Create(
@"
{
    Param(
        [hashtable]`$Arguments,
        [hashtable]`$ResultTree
    )
    & `$Arguments.Test `$Arguments.ResultTree `$Arguments.Result
}
"@
        )
    }})

    return (Start-TaskList $Tasks).Action
}