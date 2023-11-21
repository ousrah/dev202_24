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



#Exercice 2
#videz la table vol
#on souhaite insérer  pour chaque pilote des vols de sa ville de résidence a 
#casablanca sur chaqune des avions dans la date en cours
#utiliser les curseurs imbriqués
