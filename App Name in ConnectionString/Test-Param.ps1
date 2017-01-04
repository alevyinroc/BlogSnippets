function Test-Param
{
[cmdletBinding()]
param(
[Parameter(Mandatory=$false )]
        [Alias( 'Application', 'AppName' )]
        [String]
        $ApplicationName ={if ((Get-PSCallStack)[-1].Command.ToString() -ne "<ScriptBlock>") {
                        $CSBuilder["Application Name"] = (Get-PSCallStack)[-1].Command.ToString()}}
                    
)
Begin{}
Process{
    Write-Verbose "In Test-Param";
    Write-Output $ApplicationName;
}
End{}
}
Test-Param -Verbose;
Test-Param -verbose -ApplicationName "Testing";