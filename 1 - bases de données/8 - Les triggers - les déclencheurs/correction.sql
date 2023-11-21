/*EX 1 - Soit la base de données suivante :  (Utilisez celle de la série des fonctions):
Pilote(numpilote,nom,titre,villepilote,daten,datedebut)
Vol(numvol,villed,villea,dated,datea, #numpil,#numav)
Avion(numav,typeav ,capav)*/
#1 – Ajouter la table pilote le champ nb d’heures de vols ‘NBHV’ sous la forme  « 00:00:00 ».

use vols_202;
alter table pilote add nbhv time default '00:00:00';
select * from pilote;
select * from vol;
alter table vol modify dated datetime;
alter table vol modify datea datetime;

#2 – Ajouter un déclencheur qui calcule le nombre heures lorsqu’on ajoute 
#un nouveau vol et qui augmente automatiquement le nb d’heures de vols du pilote
# qui a effectué le vol.

drop trigger if exists e1q2;
delimiter &&
create trigger e1q2 after insert on vol for each row
begin
    update pilote
    set nbhv = nbhv+ timediff(new.datea, new.dated)
    where numpilote = new.numpil;
end &&
delimiter ;
update pilote set nbhv = "00:00:00";
delete from vol where 
insert into vol values (null, "marrakech", "rabat", "2023-06-21", "2023-06-22", 1, 1);

insert into vol values (null, "marrakech", "rabat", "2023-06-21", "2023-06-22", 1, 1);
insert into vol values (null, "marrakech", "rabat", "2023-06-21 13:00:00", "2023-06-21 13:30:00", 1, 1);
insert into vol values (null, "marrakech", "paris", "2023-06-22 13:00:00", "2023-06-22 17:00:00", 1, 1);


#3 – Si on supprime un vol le nombre d’heures de vols du pilote 
#qui a effectué ce vol doit être recalculé. Proposez une solution.

drop trigger if exists e1q3;
delimiter &&
create trigger e1q3 after delete on vol for each row
begin
    update pilote
    set nbhv = nbhv - timediff(old.datea, old.dated)
    where numpilote = old.numpil;
end &&
delimiter ;

delete from vol where numvol = 15;


#4 – Si on modifie la date de départ ou d’arrivée d’un vol le nombre d’heures de vols du pilote qui a effectué ce vol doit être recalculé. Proposez une solution.
drop trigger if exists e1q4;
delimiter &&
create trigger e1q4 after update on vol for each row
begin
	if old.datea!=new.datea or old.dated!=new.dated then
		update pilote
		set nbhv = nbhv - timediff(old.datea, old.dated) + timediff(new.datea, new.dated)
		where numpilote = new.numpil;
    end if
end &&
delimiter ;
update vol set datea='2023-06-21 13:45:00' where numvol=14;

/*EX 2 - Soit la base de données suivante :  (Utilisez celle de la série des PS):

DEPARTEMENT (ID_DEP, NOM_DEP, Ville)
EMPLOYE (ID_EMP, NOM_EMP, PRENOM_EMP, DATE_NAIS_EMP, SALAIRE, #ID_DEP)*/

use employes_202;

#1 – Ajouter le champs salaire moyen dans la table département.
alter table departement add salaire_moyen float default 0;
#2 – On souhaite que le salaire moyen soit recalculé automatiquement
# si on ajoute un nouvel employé,
# on supprime ou on modifie le salaire d’un ou plusieurs employés. 
#Proposez une solution.
drop trigger if exists q2_1;
delimiter $$
create trigger q2_1 after insert on employe for each row
begin
update departement set salaire_moyen = (select avg(salaire) from employe where id_dep=new.id_dep) where id_dep=new.id_dep;
end $$
delimiter ;
insert into employe values 
(10,"Ahmed","Ahmed","1990-06-06",8250,1);
use employes_202;
drop trigger if exists q2_2;
delimiter $$
create trigger q2_2 after delete on employe for each row
begin
update departement set salaire_moyen = (select avg(salaire) from employe where id_dep=old.id_dep) where id_dep=old.id_dep;
end $$
delimiter ;

delete from employe where id_emp=1;


use employes_202;
drop trigger if exists q2_3;
delimiter $$
create trigger q2_3 after update on employe for each row
begin
	if(old.salaire!=new.salaire) then
		update departement set salaire_moyen = (select avg(salaire) from employe where id_dep=old.id_dep) where id_dep=old.id_dep;
	end if;
end $$
delimiter ;

update employe set salaire = 19000 where id_emp=2;


select * from employe where id_dep=1;
select * from departement;


/*EX 2 - Soit la base de données suivante : (Utilisez celle de la série des PS):
Recettes (NumRec, NomRec, MethodePreparation, TempsPreparation)
Ingrédients (NumIng, NomIng, PUIng, UniteMesureIng, NumFou)
Composition_Recette (NumRec, NumIng, QteUtilisee)
Fournisseur (NumFou, RSFou, AdrFou)*/
#1 – Ajoutez le champ prix à la table recettes.

use cuisine_202;
alter table recettes add prix float default 0;

#2 – On souhaite que le prix de la recette soit calculé automatiquement si on ajoute un nouvel
# ingrédient, on supprime un ingrédient ou on modifie la quantité ou le prix d’un ou plusieurs
# ingrédients. Proposez une solution. 
drop trigger if exists EX3q2;
delimiter $$
create trigger EX3q2 after insert on Composition_Recette for each row
begin 
declare PU float;
	select puing into pu from ingredients where numing = new.numing;
	update recettes set prix = prix + (pu*new.qteutilisee) where numrec = new.numrec;
end$$
delimiter ;

select * from recettes;
select * from ingredients;

select * from Composition_Recette;
insert into Composition_Recette values (1,1,1);
insert into Composition_Recette values (1,2,1);
delete from Composition_Recette where numrec =1;


drop trigger if exists EX3q3;
delimiter $$
create trigger EX3q3 after delete on Composition_Recette for each row
begin 
	declare PU float;
	select puing into pu from ingredients where numing = old.numing;
	update recettes set prix = prix - (pu*old.qteutilisee) where numrec = old.numrec;

end$$
delimiter ;

delete from Composition_Recette where numrec = 1;
delete from Composition_Recette where numrec = 1 and numing = 2;
delete from Composition_Recette where numrec = 1 and numing = 1;

drop trigger if exists EX3q4;
delimiter $$
create trigger EX3q4 after update on Composition_Recette for each row
begin 
	declare PU float;
	if old.qteutilisee!=new.qteutilisee then
		select puing into pu from ingredients where numing = old.numing;
		update recettes set prix = prix - (pu*old.qteutilisee)+(pu*new.qteutilisee) where numrec = old.numrec;
	end if;
end$$
delimiter ;
update Composition_Recette set QteUtilisee = 1 where numrec = 1 and numing=2;


drop trigger if exists EX3q5;
delimiter $$
create trigger EX3q5 after update on ingredients for each row
begin 
	declare count int;
    declare i int;
	if old.PUing!=new.PUing then
		select f.x into count from (
        select count(*) x from composition_reccettes ci 
        where new.numing = ci.numing ) f;
        
        repeat
	end if;
end$$
delimiter ;

DROP FUNCTION IF EXISTS prixRecette;
delimiter $$
CREATE FUNCTION prixRecette(num INT)
RETURNS FLOAT
READS SQL DATA
BEGIN
  DECLARE prix FLOAT;
  SELECT SUM(c.QteUtilisee * i.PUIng) INTO prix
  FROM Composition_Recette c
  JOIN Ingredients i ON c.NumIng = i.NumIng
  WHERE c.NumRec = num;
  RETURN prix;
END$$
delimiter ;

DROP TRIGGER IF EXISTS ex3q5;
delimiter $$
CREATE TRIGGER ex3q5
  AFTER UPDATE
  ON Ingredients FOR EACH ROW
BEGIN
  IF NEW.PUIng != OLD.PUIng THEN
    UPDATE Recettes SET prix = prixRecette(NumRec)
    WHERE NumRec IN (
      SELECT NumRec FROM Composition_Recette WHERE NumIng = NEW.NumIng
    );
  END IF;
END$$
delimiter ;

update ingredients set puing = 40 where numing = 2;

#trigger avec curseur

DROP TRIGGER IF EXISTS ex3;
delimiter $$
CREATE TRIGGER ex3
  AFTER UPDATE
  ON Ingredients FOR EACH ROW
BEGIN
  IF NEW.PUIng != OLD.PUIng THEN
    BEGIN 
      DECLARE flag BOOLEAN default FALSE;
      DECLARE num, qte INT;
      declare price float;
      DECLARE cur1 CURSOR FOR   SELECT NumRec, QteUtilisee
								FROM Composition_Recette
								WHERE NumIng = NEW.NumIng;	
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET flag = TRUE;

      OPEN cur1;
        loop1: LOOP
          FETCH cur1 INTO num, qte;
          IF flag THEN
            LEAVE loop1;
          END IF;
		  select sum(cr.qteutilisee * i.puIng) into price from composition_recette cr join ingredients i on cr.numIng = i.numing where numrec = num;
          UPDATE Recettes SET prix = price	WHERE NumRec = num;
        END LOOP;
      CLOSE cur1;
    END;
  END IF;
END$$
delimiter ;



alter table recettes add prix float default 0;





