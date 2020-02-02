create database testing;

use testing;
drop table if exists sequenceholder;
create table SequenceHolder (id int identity (1,1),BecauseINeedSomething bit default 0);
alter table SequenceHolder add constraint PK_SequenceHolder primary key nonclustered (id);
create clustered index IX_SeqHolder on SequenceHolder(id);

set statistics time, io on;
set nocount on;

declare @newid int;
insert into SequenceHolder(BecauseINeedSomething) values (0);
set @newid = SCOPE_IDENTITY();
delete from SequenceHolder where id = @newid;
go
create sequence ABetterWay start with 1 increment by 1;
declare @newid int;
--set @newid = next value for ABetterWay;
select next value for ABetterWay;

dbathings.dbo.sp_blitzindex @tablename = 'sequenceholder',@databasename='testing';