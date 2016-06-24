function Start-TaskList {
    Param(
        [hashtable[]]$Tasks,
        [hashtable]$ResultTree = @{},
        [hashtable]$Colors = @{},
        [int]$SubtaskLevel = 0
    )

    if (!$Colors.Alias) {$Colors.Alias = "Green"}
    if (!$Colors.Error) {$Colors.Error = "Yellow"}
    if (!$Colors.Skip) {$Colors.Skip = "Yellow"}

    $Tasks | % {
        $BuildAction = Get-HashtableBuilder "ResultTree" "Action.$($_.Path)"
        $BuildVerify = Get-HashtableBuilder "ResultTree" "Verify.$($_.Path)"
        $AssignAction = Get-HashtableAssigner "ResultTree" "Action.$($_.Path)"
        $AssignVerify = Get-HashtableAssigner "ResultTree" "Verify.$($_.Path)"

        & $BuildAction
        & $BuildVerify

        $Result = Start-Task $_ $ResultTree $Colors $SubtaskLevel

        if ($Result) {
            & $AssignAction $Result.Action
            & $AssignVerify $Result.Verify
        }
    }
    return $ResultTree
}