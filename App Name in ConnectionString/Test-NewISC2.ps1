﻿import-module C:\Users\andy\Documents\GitHub\Invoke-SqlCmd2\invoke-sqlcmd2;
Invoke-Sqlcmd2 -ServerInstance .\sql2016 -Database wideworldimporters -Query "select c.CityName from application.cities c join application.stateprovinces s on c.StateProvinceID = s.stateprovinceid join application.countries ct on ct.CountryID = s.CountryID where ct.CountryName = 'United States'  and s.StateProvinceName = 'New York'; waitfor delay '00:00:15';" -appname "Testing invoke-sqlcmd2";
remove-module invoke-sqlcmd2;