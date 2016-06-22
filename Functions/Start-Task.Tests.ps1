InModuleScope Task-Tree {
    Describe "the Start-Leaf function" {
        Mock Write-Host {$Script:HostOutput += $Object}
        It "runs 1 task" {
            $Script:HostOutput = ""
            $Task = @{
                Path = "Write.Hello"
                Action = {Write-Host "Hello"}
            }
            Start-Task $Task
            $Script:HostOutput | Should Be "Write.Hello`r`nHello"
        }
    }
}