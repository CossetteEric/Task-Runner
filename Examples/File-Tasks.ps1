$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module "$here\..\Task-Runner"

$Tasks = @(@{
    Path = "Get.Filename"
    Action = {
        return Read-Host "Please enter a filename"
    }
}, @{
    Path = "Create.File"
    Skip = {
        Param([hashtable]$ResultTree)
        return Test-Path $ResultTree.Action.Get.Filename
    }
    Action = {
        Param([hashtable]$ResultTree)
        return New-Item $ResultTree.Action.Get.Filename -type file
    }
    Verify = @(@{
        Path = "FileExists"
        Test = {
            Param([hashtable]$ResultTree)
            return Test-Path $ResultTree.Action.Get.Filename
        }
    })
}, @{
    Path = "Add.Content"
    Action = {
        Param([hashtable]$ResultTree)
        $Content = "Hello world!"
        $Content | Out-File $ResultTree.Action.Get.Filename
        return $Content
    }
}, @{
    Path = "Print.Content"
    Action = {
        Param([hashtable]$ResultTree)
        $Content = Get-Content $ResultTree.Action.Get.Filename  | Out-String
        Write-Host $Content
    }
    Verify = @(@{
        Path = "UserCanSeeContent"
        Test = {
            Param([hashtable]$ResultTree)
            $Response = Read-Host "Do you see `"$($ResultTree.Action.Add.Content)`"?"
            return $Response.StartsWith("y")
        }
    })
})

$ResultTree = Start-TaskList $Tasks