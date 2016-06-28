InModuleScope Task-Runner {
    Describe "the Start-TaskList function" {
        It "returns action and confirmation results" {
            Mock Write-Host {}
            Mock Read-Host {"John Doe"}
            $Task = @{
                Path = "Get.User.Name"
                Action = {Read-Host}
                Verify = @(@{
                    Path = "Is.Not.Blank"
                    Test = {
                        Param($Tree, $Result)
                        $Result.Length -gt 0
                    }
                }, @{
                    Path = "Is.Capitalized"
                    Test = {
                        Param($Tree, $Result)
                        $Result[0] -eq $Result[0].ToString().ToUpper()
                    }
                })
            }
            $Results = Start-TaskList @($Task)
            $Results.Action.Get.User.Name | Should Be "John Doe"
            $Results.Verify.Get.User.Name | % {
                $_.Is.Not.Blank | Should Be $true
                $_.Is.Capitalized | Should Be $true
            } 
        }
        It "fails on invalid ResultTree param" {
            {Start-TaskList @(@{Path = "Get.User.name"}) $null} | Should Throw
        }
    }
}