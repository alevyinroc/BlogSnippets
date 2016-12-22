DECLARE @asOf DATETIMEOFFSET = GETDATE() at time zone 'Eastern Standard Time'
select c.CityName from application.cities c join application.stateprovinces s on c.StateProvinceID = s.stateprovinceid join application.countries ct on ct.CountryID = s.CountryID where ct.CountryName = 'United States'  and s.StateProvinceName = 'New York';
for system_time as of @asof;

sp_whoisactive