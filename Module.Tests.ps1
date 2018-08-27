# ---------------------------------------------------------------------- #
Import-Module .\Module1.psm1
Import-Module .\Module2.psm1
Describe "Get-FunctionModule1 Normal Scope" {
    It "Should Exist" {
        Get-Command "Get-FunctionModule1" | Should Be $true
    }

    It "Should Return 'Get-FunctionModule1'" {
        Get-FunctionModule1 | Should Be "Get-FunctionModule1"
    }
}

Describe "Get-FunctionModule2 Normal Scope" {
    It "Should Exist" {
        Get-Command "Get-FunctionModule2" | Should Be $true
    }

    It "Should Return 'Get-FunctionModule2'" {
        Get-FunctionModule2 | Should Be "Get-FunctionModule2"
    }
}
Remove-Module Module1
Remove-Module Module2
# ---------------------------------------------------------------------- #
Import-Module .\Module1.psm1
Import-Module .\Module2.psm1
InModuleScope Module1 {
    Describe "Get-FunctionModule1 InModuleScope Module1" {
        It "Should Exist" {
            Get-Command "Get-FunctionModule1" | Should Be $true
        }

        It "Should Return 'Get-FunctionModule1'" {
            Get-FunctionModule1 | Should Be "Get-FunctionModule1"
        }
    }

    Describe "Get-FunctionModule2 InModuleScope Module1" {
        It "Should Exist" {
            Get-Command "Get-FunctionModule2" | Should Be $true
        }

        It "Should Return 'Get-FunctionModule2'" {
            Get-FunctionModule2 | Should Be "Get-FunctionModule2"
        }
    }
}
Remove-Module Module1
Remove-Module Module2
# ---------------------------------------------------------------------- #
Import-Module .\Module1.psm1
Import-Module .\Module2.psm1
InModuleScope Module2 {
    Describe "Get-FunctionModule1 InModuleScope Module2" {
        It "Should Exist" {
            Get-Command "Get-FunctionModule1" | Should Be $true
        }

        It "Should Return 'Get-FunctionModule1'" {
            Get-FunctionModule1 | Should Be "Get-FunctionModule1"
        }
    }

    Describe "Get-FunctionModule2 InModuleScope Module2" {
        It "Should Exist" {
            Get-Command "Get-FunctionModule2" | Should Be $true
        }

        It "Should Return 'Get-FunctionModule2'" {
            Get-FunctionModule2 | Should Be "Get-FunctionModule2"
        }
    }
}
Remove-Module Module1
Remove-Module Module2