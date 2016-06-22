function Start-TaskList {
    Param(
        [hashtable[]]$Tasks,
        [hashtable]$ResultTree = @{}
    )

    $Tasks | % {
        $BuildPath = [scriptblock]::Create((Get-BuildHashtableString "ResultTree" $_.Path))
        $AssignResult = [scriptblock]::Create((Get-AssignToHashtableString "ResultTree" $_.Path))

        & $BuildPath

        $Result = Start-Task $_ $ResultTree

        if ($Result) {
            & $AssignResult $Result
        }
    }
    return $ResultTree
}