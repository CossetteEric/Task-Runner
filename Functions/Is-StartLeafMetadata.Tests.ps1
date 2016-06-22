InModuleScope Task-Tree {
    Describe "the Is-StartLeafMetadata function" {
        It "returns true on all mandatory keys existing" {
            Is-StartLeafMetadata @{Path = "Print.Hello"; Action = {Write-Host "Hello"}}
        }
        It "returns false on not all mandatory keys existing" {
            Is-StartLeafMetadata @{Path = "Print.Hello"}
            Is-StartLeafMetadata @{Action = {Write-Host "Hello"}}
        }
    }
}