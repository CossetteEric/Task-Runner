$moduleRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

"$moduleRoot\Functions\*.ps1" | Resolve-Path |
    ? {!($_.ProviderPath.ToLower().Contains(".tests."))} |
    % {. $_.ProviderPath}

Export-ModuleMember -function "Start-Leaf"
Export-ModuleMember -function "Start-Tree"
Export-ModuleMember -function "Verify-Leaf"