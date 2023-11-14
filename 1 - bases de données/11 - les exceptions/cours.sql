#La gestion des exceptions
drop database if exists dd_202;
create database dd_202 collate utf8mb4_general_ci;
use dd_202;

create table test (id int auto_increment primary key, nom varchar(50) not null unique);

insert into test(nom) values ('iam');
insert into test(nom) values ('orange');
insert into test(nom) values ('orange');
insert into test(nom) values (null);


drop procedure if exists insert_test;
delimiter $$
create procedure insert_test(name varchar(50))
begin
	declare exit handler for 1062 select "ce nom existe déjà" as msg;
	declare exit handler for 1048 select "le nom ne peut pas être null" as msg;
	insert into test(nom) values (name);
end $$
delimiter ;

select * from test;
call insert_test('iam');



drop procedure if exists insert_test;
delimiter $$
create procedure insert_test(name varchar(50))
begin
	declare flag boolean default false;
    begin
		declare exit handler for 1062 set flag = true;
        declare exit handler for 1048 set flag = true;
        insert into test(nom) values (name);
        select "insertion effectuée avec succes" as msg;
	end;
    if flag then
		select "erreur d'insertion" as msg;
    end if;
end $$
delimiter ;


call insert_test('ismontic');





drop procedure if exists insert_test;
delimiter $$
create procedure insert_test(name varchar(50))
begin
	declare n int default 0;
    begin
		declare exit handler for 1062 set n = 1062;
        declare exit handler for 1048 set n=  1048;
        insert into test(nom) values (name);
        select "insertion effectuée avec succes" as msg;
	end;
    if n!=0 then
		case n
			when 1048 then select "le nom ne peut pas être null" as msg;
			when 1062 then select "ce nom existe déjà" as msg;
			else select "erreur d'insertion";
		end case;
    end if;
end $$
delimiter ;

call insert_test(null);





drop procedure if exists insert_test;
delimiter $$
create procedure insert_test(name varchar(50))
begin
	declare flag boolean default false;
    begin
		declare exit handler for sqlexception set flag = true;
		insert into test(nom) values (name);
        select "insertion effectuée avec succes" msg;
    end;
    if flag then
		select "erreur d'insertion" msg;
    end if;
end $$
delimiter ;

call insert_test("hhhh");




drop procedure if exists insert_test;
delimiter $$
create procedure insert_test(name varchar(50))
begin
	declare flag boolean default false;
    declare v_errno int;
    declare v_sqlstate varchar(50);
    declare v_msg varchar(250);
    begin
		declare exit handler for sqlexception 
			begin
				get diagnostics condition 1 
                v_errno = mysql_errno, 
                v_sqlstate = returned_sqlstate, 
                v_msg = message_text;
				set flag = true;
			end;
		insert into test(nom) values (name);
        select "insertion effectuée avec succes" msg;
    end;
    if flag then
		case v_errno
			when 1062 then 	select "ce nom exist déjà" msg;
			when 1048 then 	select "le nom ne peut pas être null" msg;
			else 	select "erreur d'insertion" msg;
		end case;
    end if;
end $$
delimiter ;

call insert_test('lj');



drop procedure if exists get_name_by_id;
delimiter $$
create procedure get_name_by_id(i int, out name varchar(50))
begin
		declare flag boolean default false;
        declare v_errno int;
        declare v_sqlstate varchar(5);
        declare v_msg varchar(250);
        
        begin
			declare exit handler for not found 
            begin
				get diagnostics condition 1
                v_errno = mysql_errno,
                v_sqlstate = returned_sqlstate,
                v_msg = message_text;
                set flag = true;
            end;
			select nom into name  from test where id = i;
		end;
        if flag then
			select concat(v_errno,' - (', v_sqlstate , ')  --->  ' , v_msg) msg;
        end if;
end$$
delimiter ;

call get_name_by_id(3,@n);
select @n;

select * from test;




drop procedure if exists set_text;
delimiter $$
create procedure set_text(txt varchar(50)) 
begin
	declare flag boolean default false;
	declare v_errno int;
	declare v_sqlstate varchar(50);
	declare v_msg varchar(250);
    declare a int;
	begin
			declare exit handler for sqlstate "01000", sqlstate "HY000"
            begin
				get diagnostics condition 1
                v_errno = mysql_errno,
                v_sqlstate = returned_sqlstate,
                v_msg = message_text;
                set flag = true;
            end;
			set a = txt;
			select a;
	end;
	if flag then
		select concat(v_errno,' - (', v_sqlstate , ')  --->  ' , v_msg) msg;
	end if;
end$$
delimiter ;

call set_text(15);
call set_text("15");
call set_text("abcd");

drop procedure if exists division;
delimiter $$
create procedure division(a int,b int,out r float)
begin
	declare flag boolean default false;
	declare v_errno int;
	declare v_sqlstate varchar(50);
	declare v_msg varchar(250);
	begin
		declare exit handler for sqlexception
            begin
				get diagnostics condition 1
                v_errno = mysql_errno,
                v_sqlstate = returned_sqlstate,
                v_msg = message_text;
                set flag = true;
            end;
		if b =1 then
		 signal SQLSTATE '23000' set MESSAGE_TEXT = "Vous ne pouvez pas diviser par 1 au Maroc" , mysql_errno = 1111;
		end if;
		set r = a/b;
	end;
    if flag then
  		select concat(v_errno,' - (', v_sqlstate , ')  --->  ' , v_msg) msg;
    end if;
end$$
delimiter ;


call division(3,5,@r);
select @r;
call division(3,1,@r);
select @r;

drop procedure if exists divide;
delimiter $$
create procedure divide(a int, b int, out r float)
begin
	declare division_par_zero condition for sqlstate '22012';
    declare continue handler for division_par_zero
			resignal set MESSAGE_TEXT = 'Division par zero impossible' , mysql_errno = 1000;

   if b=0 then 
		select b;
		signal division_par_zero;
    else
		set r = a/b;
	end if;
end$$
delimiter ;

call divide(3,"a",@r);
select @r;

