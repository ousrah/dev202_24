#Les procédures stockées

drop procedure if exists exemple1;
delimiter $$
create procedure exemple1()
begin
	select * from employe;
	select * from departement;
end $$
delimiter ;
call exemple1;




drop procedure if exists exemple2;
delimiter $$
create procedure exemple2()
begin
	select * from employe where id_dep = 1;
	select * from departement where id_dep=1;
end $$
delimiter ;
call exemple2;



drop procedure if exists exemple3;
delimiter $$
create procedure exemple3(id int)
begin
	select * from employe where id_dep = id;
	select * from departement where id_dep=id;
end $$
delimiter ;
call exemple3(3);





drop procedure if exists exemple4;
delimiter $$
create procedure exemple4(in id int)
begin
	select * from employe where id_dep = id;
	select * from departement where id_dep=id;
end $$
delimiter ;
call exemple4(3);



drop procedure if exists exemple5;
delimiter $$
create procedure exemple5(in id int, out nb int)
begin
	select count(*) into nb from employe where id_dep=id;
end $$
delimiter ;
call exemple5(3,@nombre);
select @nombre;




drop procedure if exists exemple5;
delimiter $$
create procedure exemple5(in id int, out nb int, out somme int)
begin
	select count(*) into nb from employe where id_dep=id;
    select sum(salaire) into somme from employe where id_dep=id;
    
end $$
delimiter ;
call exemple5(2,@nombre,@somme);
select @nombre;
select @somme;




drop procedure if exists exemple6;
delimiter $$
create procedure exemple6(in id int, out nb int)
begin
	select nb;
	select count(*) into nb from employe where id_dep=id;
end $$
delimiter ;
set @nombre = 6000;
call exemple6(2,@nombre);
select @nombre;



drop procedure if exists exemple7;
delimiter $$
create procedure exemple7(in id int, inout nb int)
begin
	select nb;
	select count(*) into nb from employe where id_dep=id;
end $$
delimiter ;
set @nombre = 6000;
call exemple7(2,@nombre);
select @nombre;
