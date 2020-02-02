use testing;
go
create or alter procedure GetNextSequenceTable as
begin
declare @newid int;
insert into SequenceHolder(BecauseINeedSomething) values (0);
set @newid = SCOPE_IDENTITY();
delete from SequenceHolder where id = @newid;
select @newid;
end

go

create or alter procedure GetNextSequenceSeq as
begin
select next value for ABetterWay;
end
go