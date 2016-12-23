use cachedb;
go
CREATE OR ALTER PROCEDURE dbo.GetCounties
AS
	print 'GetCounties';
    select s.name,c.countyname
	from states s join counties c on s.StateId = c.StateId;
go
CREATE OR ALTER PROCEDURE dbo.GetCounties2
AS
	create table #StatesCounties (
		StateName nvarchar(100)
		,CountyName nvarchar(100)
	);
	print 'GetCounties2';
    insert into #StatesCounties
		select s.name as StateName,c.countyname
		from states s join counties c on s.StateId = c.StateId;
	select StateName,CountyName from #StatesCounties;
go
CREATE OR ALTER PROCEDURE dbo.GetCounties3
AS
	SET NOCOUNT ON
	create table #StatesCounties (
		StateName nvarchar(100)
		,CountyName nvarchar(100)
	);
	print 'GetCounties3';
    insert into #StatesCounties
		select s.name as StateName,c.countyname
		from states s join counties c on s.StateId = c.StateId;
	select StateName,CountyName from #StatesCounties;
