$moduleRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

"$moduleRoot\Functions\*.ps1" | Resolve-Path |
    ? {!($_.ProviderPath.ToLower().Contains(".tests."))} |
    % {. $_.ProviderPath}

Export-ModuleMember -function "Start-Task"
Export-ModuleMember -function "Start-TaskList"
Export-ModuleMember -function "Verify-Task"