# MultiModules (PWSH 7)

This repository contains like the name says multiple custom modules for the daily usage building automations (principally with Microsoft ecosystem) using PowerShel Core (PWSH 7+).

I mainly created them because i needed a simple way to obtain a Graph JWT token and make various calls without using the original Graph modules, as they are not very "versatile". 

## How to install
There are different methods for installing the modules, the most common one requires just to copy the contents of modules folder to your local modules path

### Manual installation
The manual installation for local user without admin rights consists on:

1. Download the latest artifact from the repo release tab
2. Extract the content
3. Copy the folders inside `Modules` to your local PWSH modules path (`C:\Users\USERNAME\Documents\PowerShell\Modules`)


## Local development instructions
To load all modules in VS Code, just launch the file `Modules.LocalDevelop\Load-Modules.ps1` and it will load all modules regarding current parent directory.



## ToDo
- [ ] Generate a complete readme with more options for install modules
- [ ] Improve modules documentation and error handling
- [ ] Implement pester unit test