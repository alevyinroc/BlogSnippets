use demo;
drop table if exists triggertest;
create table triggertest (id int identity (1,1),dtentered datetime default getdate(),dtmodified datetime, val uniqueidentifier not null);
go
create or alter trigger tr_triggertest on[triggertest] after insert,update as 

    update triggertest set dtmodified = getdate() where [id] in (select [id] from inserted);

    go

set statistics IO on;
insert into triggertest(val) values (newid());
go 10
select * from triggertest;
set statistics io off;
alter table triggertest disable trigger tr_triggertest;
alter table triggertest add constraint df_dtmodified default getdate() for dtmodified;
set statistics io on;
go
insert into triggertest(val) values (newid());
go 10
select * from triggertest;