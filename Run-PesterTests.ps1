using module .\PesterTests.psm1

function Install-DependencyLocal {
    try {
        Update-Module Pester
    }
    catch {
        Install-Module -Name Pester -Scope CurrentUser -Force -Confirm:$false -SkipPublisherCheck
    }

    if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
        Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force -Confirm:$false -SkipPublisherCheck
    }

    Import-Module Pester
    Import-Module PSScriptAnalyzer
}

function Invoke-TestScriptLocal {
    param (
        [Parameter(Mandatory = $true)]
        [array] $Scripts,
        [Parameter(Mandatory = $true)]
        [string] $LogDir
    )

    $results = Invoke-Pester -PassThru -OutputFile "$LogDir\PSResults.xml" -OutputFormat "NUnitXml" -Script $Scripts

    $FailedCount = $results.FailedCount

    if ($results.TotalCount -eq 0) {
        Write-Information -InformationAction Continue "Test script caused no tests to run?  Promoting this to a failure"
        $FailedCount = 1
    }

    return $FailedCount
}

Invoke-Command -ScriptBlock {
    Write-Host "Executing tests in local context"
    New-Item -ItemType Directory "$PSScriptRoot\localLogs" -Force > $null
    Install-DependencyLocal > $null
    Invoke-TestScriptLocal -Scripts @(".\Module.Tests.ps1") -LogDir "$PSScriptRoot\localLogs" > $null
}

Invoke-Command -ScriptBlock {
    Write-Host "Executing tests in module context [using module]"
    New-Item -ItemType Directory "$PSScriptRoot\moduleLogs" -Force > $null
    Install-Dependency > $null
    Invoke-TestScript -Scripts @(".\Module.Tests.ps1") -LogDir "$PSScriptRoot\moduleLogs" > $null
}

Invoke-Command -ScriptBlock {
    Remove-Module PesterTests
    Import-Module .\PesterTests.psm1
    Write-Host "Executing tests in module context [Import-Module]"
    New-Item -ItemType Directory "$PSScriptRoot\moduleLogs" -Force > $null
    Install-Dependency > $null
    Invoke-TestScript -Scripts @(".\Module.Tests.ps1") -LogDir "$PSScriptRoot\moduleLogs" > $null
}