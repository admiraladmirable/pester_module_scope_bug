### Pester bug information
Pester version     : 4.4.0 C:\Users\rmorrow\Documents\WindowsPowerShell\Modules\pester\4.4.0\Pester.psm1
PowerShell version : 5.1.15063.1209
OS version         : Microsoft Windows NT 10.0.15063.0

### Way to run this test: 
Call `Run-PesterTests.ps1` through Powershell.

### What this test is pointing out:
There seems to be a strange interaction when the following conditions are met:
1. You have a centralized Pester testing script for invoking tests.
1. You import the `Pester` and `PSScriptAnalyzer` modules through a function of another module.
1. You call `Invoke-Pester` through a wrapper function in this testing module
1. The tests you are running import two different modules, and you define the tests using `InModuleScope` for one of them.
1. When the tests are invoked this way, and the scope is set to Module1, the functions in Module2 will fail to be found with an error like:
```
CommandNotFoundException: The term 'function_name' is not recognized as the name of a cmdlet, function, script file, or operable program. Check the spelling of the name, or if a path was included, verify that the path is correct and try again.
```
The tests seem to work just fine when you define the same `Invoke-Pester` wrapper function locally in the scope of the main test script.
