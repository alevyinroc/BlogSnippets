use testing;
/*
Area code data from https://nationalnanpa.com/enas/geoAreaCodeNumberReport.do
Download: $nums = import-excel .\NpasInSvcByNumRpt.xlsx
Import into table: $nums | ConvertTo-DbaDataTable |Write-DbaDataTable -SqlInstance localhost\sql17 -database testing -schema dbo -Table AreaCodes -AutoCreateTable -UseDynamicStringLength
*/

select * from areacodes;
alter table areacodes alter column NPA int not null;
alter table areacodes alter column Location varchar(100) not null;
alter table areacodes add constraint PK_Areacodes primary key clustered (npa);
alter table areacodes rebuild


SELECT 
    t.NAME AS TableName,
    p.rows AS RowCounts,
    SUM(a.total_pages) AS TotalPages, 
    SUM(a.used_pages) AS UsedPages, 
    (SUM(a.total_pages) - SUM(a.used_pages)) AS UnusedPages
FROM 
    sys.tables t
INNER JOIN      
    sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN 
    sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN 
    sys.allocation_units a ON p.partition_id = a.container_id
WHERE 
    t.NAME NOT LIKE 'dt%' 
    AND t.is_ms_shipped = 0
    AND i.OBJECT_ID > 255 
GROUP BY 
    t.Name, p.Rows
ORDER BY 
    t.Name

set statistics io on;

SELECT DISTINCT location
	,stuff((
			SELECT ',' + cast(a2.npa AS CHAR(3))
			FROM areacodes a2
			WHERE a2.location = a.location
			FOR XML PATH('')
			), 1, 1, N'') AS areacodes
FROM areacodes a
ORDER BY location;

SELECT location
	,string_agg(npa, ',')  AS AreaCodes
FROM areacodes
GROUP BY Location
ORDER BY location;


-- Original version
SELECT DISTINCT location
	,stuff((
			SELECT ',' + cast(a2.npa AS CHAR(3))
			FROM areacodes a2
			WHERE a2.location = a.location
			order by a2.npa
			FOR XML PATH('')
			), 1, 1, N'') AS areacodes
FROM areacodes a
ORDER BY location;

-- SQL Server 2017 version
SELECT location
	,string_agg(npa, ',') within group (order by npa) AS AreaCodes
FROM areacodes
GROUP BY location
ORDER BY location;
