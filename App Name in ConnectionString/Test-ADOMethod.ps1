﻿$DBConnection = New-Object System.Data.SqlClient.SqlConnection;
$DBCSBuilder = New-Object System.Data.SqlClient.SqlConnectionStringBuilder;
$DBCSBuilder['Data Source'] = ".\sql2016";
$DBCSBuilder['Initial Catalog'] = "WideWorldImporters";
$DBCSBuilder['Application Name'] = "Andy's Awesome Application";
$DBCSBuilder['Integrated Security'] = "true";
$DBConnection.ConnectionString = $DBCSBuilder.ToString();

#alternative method:
#$DBConnection.ConnectionString = "Data Source=.\sql2016;Initial Catalog=WideWorldImporters;Integrated Security=true;Application name=Andy's Awesome Application;"

$DBConnection.Open();
$QueryCmd = $DBConnection.CreateCommand();
$QueryCmd.CommandText = "select c.CityName from application.cities c join application.stateprovinces s on c.StateProvinceID = s.stateprovinceid join application.countries ct on ct.CountryID = s.CountryID where ct.CountryName = 'United States'  and s.StateProvinceName = 'New York'; waitfor delay '00:00:15';";
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter;
$QueryCmd.Connection = $DBConnection;
$SqlAdapter.SelectCommand = $QueryCmd;
$DataSet = New-Object System.Data.DataSet;
$SqlAdapter.Fill($DataSet);
$DataSet.Tables[0];