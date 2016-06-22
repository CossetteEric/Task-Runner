function Start-TaskList {
    Param(
        [hashtable[]]$Tasks,
        [hashtable]$ResultTree = @{}
    )

    $Tasks | % {
        $BuildAction = Get-HashtableBuilder "ResultTree" "Action.$($_.Path)"
        $BuildVerify = Get-HashtableBuilder "ResultTree" "Verify.$($_.Path)"
        $AssignAction = Get-HashtableAssigner "ResultTree" "Action.$($_.Path)"
        $AssignVerify = Get-HashtableAssigner "ResultTree" "Verify.$($_.Path)"

        & $BuildAction
        & $BuildVerify

        $Result = Start-Task $_ $ResultTree

        if ($Result) {
            & $AssignAction $Result.Action
            & $AssignVerify $Result.Verify
        }
    }
    return $ResultTree
}