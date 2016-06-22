InModuleScope Task-Runner {
    Describe "the Start-TaskVerification function" {
        It "returns tree" {
            $Subtasks = @(@{
                Path = "Is.NotBlank"
                Test = {
                    Param([hashtable]$Tree, $Value)
                    return $Value.Length -gt 0
                }
            }, @{
                Path = "Is.UpperCase"
                Test = {
                    Param([hashtable]$Tree, $Value)
                    return [string]::Compare($Value.ToUpper(), $Value) -eq 0
                }
            })
            $TestResults = Start-TaskVerification $Subtasks @{} "Hello"
            $TestResults | % {
                $_.Is.NotBlank | Should Be $true
                $_.Is.UpperCase | Should Be $false
            }
        }
    }
}