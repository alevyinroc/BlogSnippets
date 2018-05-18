import-module dbatools,importexcel;
$DBServer = 'PLANEX\SQL2016';
$TableList = Get-Content TableList.txt;
$Tables = Get-DbaTable -serverinstance $DBServer -Database Satellites -Table $TableList;
foreach ($Table in $Tables) {
    $Columns = $Table.columns|select-object Name,DataType,Nullable,@{name='Length';expression={$_.Properties["Length"].value}};
    $Columns | Export-Excel -path C:\Users\andy\Documents\TableInfo.xlsx -WorkSheetname $Table.Name -FreezeTopRow -BoldTopRow;
}

Get-Content TableList.txt | Foreach-Object{ Get-DbaTable -ServerInstance $DBServer -database satellites -table $PSItem | ForEach-Object{ $PSItem.Columns | select-object Name,DataType,Nullable,@{name='Length';expression={$_.Properties["Length"].value}} | Export-Excel -path C:\Users\andy\Documents\TableInfo2.xlsx -WorkSheetname $PSItem.Name -FreezeTopRow -BoldTopRow}}