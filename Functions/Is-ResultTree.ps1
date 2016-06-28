function Is-ResultTree {
    Param(
        [hashtable]$ResultTree
    )

    if ($ResultTree -eq $null) {
        return $false
    }
    return $true
}