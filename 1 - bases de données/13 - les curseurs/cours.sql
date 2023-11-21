use vols_202;

select numpilote from pilote;
select * from avion;
select * from vol;
delete from vol;




drop procedure if exists insert_pilotes;
delimiter $$
create procedure insert_pilotes()
begin
	declare np int;
	declare flag boolean default false;
    declare c1 cursor for select numpilote from pilote;
    declare continue handler for not found set flag = true;
    open c1;
		b1: loop
			fetch c1 into np;
			if flag then
				leave b1;
			end if;
			insert into vol values (null,'tetouan','casablanca',current_date(),current_date(),np,1);       
        end loop b1;
	close c1;
end $$
delimiter ;


call insert_pilotes();

#Exercice 0
#Refaire la meme procedure de votre mémoire


#Exercice 1 
#videz la table vol
#On souhaite insérer pour chaque pilote des vols sur l'avion 1 avec 
#la ville de départ égale à sa ville de résidence.


select numpilote, villepilote from pilote;
select * from avion;
select * from vol;
delete from vol;


drop procedure if exists insert_pilotes;
delimiter $$
create procedure insert_pilotes()
begin
	declare np int;
    declare vp varchar(50);
	declare flag boolean default false;
    declare c1 cursor for select numpilote,villepilote from pilote;
    declare continue handler for not found set flag = true;
    open c1;
		b1: loop
			fetch c1 into np, vp;
			if flag then
				leave b1;
			end if;
			insert into vol values (null,vp,'casablanca',current_date(),current_date(),np,1);       
        end loop b1;
	close c1;
end $$
delimiter ;


call insert_pilotes();
select * from vol;


delete from vol;
#Exercice 2
#videz la table vol
#on souhaite insérer  pour chaque pilote des vols de sa ville de résidence a 
#casablanca sur chaqune des avions dans la date en cours
#utiliser les curseurs imbriqués

drop procedure if exists insert_Vols_Res;
delimiter $$
create procedure insert_Vols_Res()
begin 
	declare np int;
    declare villeP varchar(50);
    declare flag1 boolean default false;
    declare c1 cursor for select numpilote,villepilote from pilote;
    declare continue handler for not found set flag1 = true;
    open c1;
		b1: loop
			fetch c1 into np,villeP;
			if flag1 then
				leave b1;
			end if;
			begin
                declare nv int;
				declare flag2 boolean default false;
				declare c2 cursor for select numav from avion;
				declare continue handler for not found set flag2 = true;
                open c2;
					b2: loop
						fetch c2 into nv;
						if flag2 then
							leave b2;
						end if;
                        insert into vol values (null,villeP,'Casablanca',current_date(),current_date(),np,nv);
					end loop b2;
                close c2;
            end;
        end loop b1;
    close c1;
end $$
delimiter ;
call insert_Vols_Res();
select * from vol;