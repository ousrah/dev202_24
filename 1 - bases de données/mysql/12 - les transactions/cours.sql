drop database if exists bank;
create database bank collate utf8mb4_general_ci;
use bank;
create table account(
noAccount varchar(50) primary key,
 funds decimal(8,2), 
 constraint chk_funds check ( funds between 0 and 50000));
 
 insert into account values ('ac1',30000),('ac2',40000);
 select * from account;
 
 update account set funds = funds-10000 where noAccount = 'ac1';
 update account set funds = funds+10000 where noAccount = 'ac2';
 
 select * from account;
 
 
 update account set funds = funds-10000 where noAccount = 'ac1';
 update account set funds = funds+10000 where noAccount = 'ac2';
 
  select * from account;
  
  
  drop procedure if exists virement;
  delimiter $$
  create procedure virement (a1 varchar(50),a2 varchar(50), amount decimal(8,2))
  begin
	declare flag boolean default false;
	begin
		declare exit handler for sqlexception 
		begin
			rollback;
			set flag = true;
		end;
		start transaction;
			update account set funds = funds-amount where noAccount = a1;
			update account set funds = funds+amount where noAccount = a2;
		commit;
        select "virement effectué avec succes";
    end;
    if flag then
		select "virement annulé";
    end if;
  end$$
  delimiter ;
  
  call virement('ac1','ac2',10000);
  select * from account;
 
 
 