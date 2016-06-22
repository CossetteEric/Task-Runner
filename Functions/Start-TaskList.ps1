function Start-TaskList {
    Param(
        [hashtable[]]$Tasks,
        [hashtable]$ResultTree = @{},
        [hashtable]$Colors = @{}
    )

    if (!$Colors.Alias) {$Colors.Alias = "Green"}
    if (!$Colors.Error) {$Colors.Error = "Yellow"}

    $Tasks | % {
        $BuildAction = Get-HashtableBuilder "ResultTree" "Action.$($_.Path)"
        $BuildVerify = Get-HashtableBuilder "ResultTree" "Verify.$($_.Path)"
        $AssignAction = Get-HashtableAssigner "ResultTree" "Action.$($_.Path)"
        $AssignVerify = Get-HashtableAssigner "ResultTree" "Verify.$($_.Path)"

        & $BuildAction
        & $BuildVerify

        $Result = Start-Task $_ $ResultTree $Colors

        if ($Result) {
            & $AssignAction $Result.Action
            & $AssignVerify $Result.Verify
        }
    }
    return $ResultTree
}