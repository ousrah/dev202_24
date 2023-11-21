/*Objectif : Manipuler les curseurs/imbriquer les curseurs

Base de données ‘Gestion_vols’ :
*/

use vols_203;
select * from pilote;
alter table pilote add salaire float;

select ceiling(rand()*24);


#1)	Réalisez un curseur en lecture seule avec déplacement vers l’avant qui extrait la liste des pilotes avec pour informations l’identifiant, le nom et le salaire du pilote ;
#Affichez les informations à l’aide de l’instruction Select (print)

drop procedure if exists q1;
delimiter $$
create procedure q1()
begin
	declare idp int;
    declare flag boolean default false;
    begin
		declare c1 cursor for select numpilote from pilote;
        declare continue handler for not found set flag =True;
        open c1;
			b1:loop
				fetch c1 into idp;
                if flag then
					leave b1;
				end if;
				select numpilote,nom,salaire from pilote;
            end loop b1;
        close c1;
    end;
end $$
delimiter ;
call q1();
#2)	Complétez le script précédent en imbriquant un deuxième curseur qui va préciser pour chaque pilote, quels sont les vols effectués par celui-ci.

#Vous imprimerez alors, pour chaque pilote une liste sous la forme suivante :
#- Le pilote ‘ xxxxx xxxxxxxxxxxxxxxxx est affecté aux vols :
#       Départ : xxxx  Arrivée : xxxx
#       Départ : xxxx  Arrivée : xxxx
#       Départ : xxxx  Arrivée : xxxx
#-Le pilote ‘ YYY YYYYYYYY est affecté aux vols :
#       Départ : xxxx  Arrivée : xxxx
#       Départ : xxxx  Arrivée : xxxx
select * from pilote;
select * from vol;
drop procedure if exists q1;
delimiter $$
create procedure q1()
begin
	declare idp int;
    declare flag boolean default false;
    begin
		declare c1 cursor for select numpilote from pilote;
        declare continue handler for not found set flag =True;
        open c1;
			b1:loop
				fetch c1 into idp;
                if flag then
					leave b1;
				end if;
                select numpilote,nom,salaire from pilote where numpilote =idp;

				select concat('Le pilote ', nom, ' est affecte est vols ')  from pilote where numpilote =idp;
                begin
					declare vd varchar(50);
                    declare va varchar(50);
                    declare nbVols int default 0;
                    declare flag2 boolean default false;
                    declare ancienSalaire float;
                    declare c2 cursor for select villed,villea from vol where numpil =idp;
                    declare continue handler for not found set flag2 =true;
                    select salaire into ancienSalaire from pilote where numpilote =idp;
                    open c2;
						b2:loop
							fetch c2 into vd,va;
                            if flag2 then
								leave b2;
							end if;
							select concat("Ville depart : ",vd," Ville d'arrivée : ",vd);
                            set nbVols = nbVols+1;
                        end loop b2;
							
                        if nbVols=0 then
                        	update pilote set salaire  = 5000 where numpilote = idp;
                            select concat ('ancien salaire '  , ifnull(ancienSalaire,'') , ' nouveau salaire ', 5000);
                        elseif nbVols between 1 and 3 then
                        	update pilote set salaire  = 7000 where numpilote = idp;
                            select concat ('ancien salaire '  , ifnull(ancienSalaire,'') , ' nouveau salaire ', 7000);
                        else
							update pilote set salaire  = 8000 where numpilote = idp;
                            select concat ('ancien salaire '  , ifnull(ancienSalaire,'') , ' nouveau salaire ', 8000);
                        end if;
                    close c2;
                end;
            end loop b1;
        close c1;
        
      
    end;
end $$
delimiter ;
call q1();



#3)	Vous allez modifier le curseur précédent pour pouvoir mettre à jour le salaire du pilote. Vous afficherz une ligne supplémentaire à la suite de la liste des vols en précisant l’ancien et le nouveau salaire du pilote.
#Le salaire brut du pilote est fonction du nombre de vols auxquels il est affecté :

#1	Si 0 alors le salaire est 5 000
#	Si entre 1 et 3,  salaire de 7 000
#	Plus de 3, salaire de 8000

#voir script précedent

#Exercice 2
#Soit la base de données suivante

#Employé :

#Matricule	nom	prénom	état
#1453	Lemrani	Kamal	fatigué
#4532	Senhaji	sara	En forme
			#…
			#..

drop database if exists employes_203;
create database employes_203 collate utf8mb4_general_ci;
use employes_203;
create table employe(matricule int  primary key, nom varchar(50), prenom varchar(50), etat varchar(50));
create table groupe (matricule int , groupe varchar(50), constraint fk_employe foreign key (matricule) references employe(matricule));

insert into employe values (1453,'lemrani','kamal','fatigué'),(4532,'senhaji','sara','en forme');

#Groupe :
#Matricule	Groupe
#1453	Administrateur
#1453	Chef
#4532	Besoin vacances
#…	
#On désire ajouter les employés dont l’état est fatigué dans le groupe ‘besoin vacances’ dans la table Groupe;
#Utiliser un curseur ;

select * from employe;
select * from groupe;

drop procedure if exists ex2;
delimiter $$
	create procedure ex2()
		begin
			declare flag boolean default false;
            declare id int;
            declare c1 cursor for select matricule from employe where etat = 'fatigué';
            declare continue handler for not found set flag = true;
            open c1;
				nb : loop
					fetch c1 into id;
						if flag then 
							leave nb;
						else 
							insert into groupe values (id,'Besoin vacances');
						end if;
				end loop nb;
			close c1;
        end $$
delimiter ;
call ex2();
select * from groupe;