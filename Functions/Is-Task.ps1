function Is-Task {
    Param(
        [hashtable]$Task
    )

    return @("Path", "Action") | % {$HasAll = $true} {$HasAll = $HasAll -and $Task.ContainsKey($_)} {$HasAll}
}