start-job -scriptblock {import-module C:\Users\andrewle\Documents\_GitHub\Invoke-SqlCmd2\invoke-sqlcmd2;
Invoke-Sqlcmd2 -ServerInstance .\sql2016 -Database worldwideimporters -Query "select c.CityName from application.cities c join application.stateprovinces s on c.StateProvinceID = s.stateprovinceid join application.countries ct on ct.CountryID = s.CountryID where ct.CountryName = 'United States'  and s.StateProvinceName = 'New York'; waitfor delay '00:00:15';" -appname "Testing invoke-sqlcmd2";
remove-module invoke-sqlcmd2;}

start-job -FilePath 'C:\Users\andrewle\documents\_github\blogsnippets\App Name in ConnectionString\test-newisc2.ps1';

start-job -scriptblock {import-module C:\Users\andrewle\Documents\_GitHub\Invoke-SqlCmd2\invoke-sqlcmd2;
Invoke-Sqlcmd2 -ServerInstance .\sql2016 -Database worldwideimporters -Query "select c.CityName from application.cities c join application.stateprovinces s on c.StateProvinceID = s.stateprovinceid join application.countries ct on ct.CountryID = s.CountryID where ct.CountryName = 'United States'  and s.StateProvinceName = 'New York'; waitfor delay '00:00:15';";
remove-module invoke-sqlcmd2;}

start-job -scriptblock {import-module invoke-sqlcmd2;
Invoke-Sqlcmd2 -ServerInstance .\sql2016 -Database worldwideimporters -Query "select c.CityName from application.cities c join application.stateprovinces s on c.StateProvinceID = s.stateprovinceid join application.countries ct on ct.CountryID = s.CountryID where ct.CountryName = 'United States'  and s.StateProvinceName = 'New York'; waitfor delay '00:00:15';"
remove-module invoke-sqlcmd2;}

Invoke-Sqlcmd -ServerInstance .\sql2016 -query "exec sp_whoisactive" | Select-Object -Property program_name,start_time,session_id,status|Format-Table;