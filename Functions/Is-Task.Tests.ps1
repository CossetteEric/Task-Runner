InModuleScope Task-Tree {
    Describe "the Is-Task function" {
        It "returns true on all mandatory keys existing" {
            Is-Task @{Path = "Print.Hello"; Action = {Write-Host "Hello"}}
        }
        It "returns false on not all mandatory keys existing" {
            Is-Task @{Path = "Print.Hello"}
            Is-Task @{Action = {Write-Host "Hello"}}
        }
    }
}