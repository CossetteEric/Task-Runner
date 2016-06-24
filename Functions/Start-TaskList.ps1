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
        $BuildAction = Get-TreeBuilder "ResultTree" "Action.$($_.Path)"
        $BuildVerify = Get-TreeBuilder "ResultTree" "Verify.$($_.Path)"
        $AssignAction = Get-TreeAssigner "ResultTree" "Action.$($_.Path)"
        $AssignVerify = Get-TreeAssigner "ResultTree" "Verify.$($_.Path)"

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