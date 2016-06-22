InModuleScope Task-Tree {
    Describe "the Start-Task function" {
        Mock Write-Host {$Script:HostOutput += $Object}
        It "runs a task" {
            $Script:HostOutput = ""
            $Task = @{
                Path = "Write.Hello"
                Action = {Write-Host "Hello"}
            }
            Start-Task $Task
            $Script:HostOutput | Should Be "Write.Hello`r`nHello"
        }
        It "shows a description" {
            $Script:HostOutput = ""
            $Task = @{
                Path = "Write.Hello"
                Description = "Write `"Hello`""
                Action = {Write-Host "Hello"}
            }
            Start-Task $Task
            $Script:HostOutput | Should Be "Write.Hello`r`nWrite `"Hello`"`r`nHello"
        }
        It "displays known error" {
            $Script:HostOutput = ""
            $Task = @{
                Path = "Throw.Known"
                Action = {
                    throw New-Object Exception("Known Error")
                }
                Errors = {
                    Param($Message)
                    return $Message -eq "Known Error"
                }
            }
            Start-Task $Task
            $Script:HostOutput | Should Be "Throw.Known`r`nKnown Error`r`n"
        }
        It "throws unknown error" {
            $Task = @{
                Path = "Throw.Unknown"
                Action = {
                    throw New-Object Exception("Unknown Error")
                }
                Errors = {
                    Param($Message)
                    return $Message -eq "Known Error"
                }
            }
            {Start-Task $Task} | Should Throw
        }
    }
}