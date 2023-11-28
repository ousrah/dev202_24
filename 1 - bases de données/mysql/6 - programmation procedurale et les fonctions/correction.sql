/*Exercice 1 :
Écrire une fonction qui renvoie une chaine qui sera exprimée sous la forme Jour, Mois et Année à partir d’une date passée comme paramètre où :
­	Mois est exprimé en toutes lettres
exemple : décembre 
Exemple : 12/09/2011 -----> 12 septembre 2011*/



drop function if exists formatedate;
delimiter &&
create function formatedate(dateN varchar(50))
returns varchar(50)
deterministic
begin
    
   return date_format(str_to_date(dateN,"%d/%m/%Y"), "%d %M %Y");
    
end &&
delimiter ;
select formatedate("12/09/2011");


drop function if exists formatedate;
delimiter &&
create function formatedate(dateN varchar(50))
returns varchar(50)
deterministic
begin
	declare converted_date date;
    declare day,month,year int;
    declare monthName varchar(50);
    
    set converted_date = str_to_date(dateN,"%d/%m/%Y");
    set day = day(converted_date);
    set month = month(converted_date);
    set year = year(converted_date);
    set monthName = case month
    when 1 then "Janvier"
    when 2 then "Février"
    when 3 then "Mars"
    when 4 then "Avril"
    when 5 then "Mai"
    when 6 then "Juin"
    when 7 then "Juillet"
    when 8 then "Aout"
    when 9 then "Septembre"
    when 10 then "Octobre"
    when 11 then "Novembre"
    when 12 then "Décembre"
    end;
	return concat(day,' ', monthName, ' ' , year);
end &&
delimiter ;
select formatedate("12/09/2011");




/*Exercice 2:
Ecrire une fonction qui reçoit deux dates comme paramètre 
et calcule l’écart en fonction de l’unité de calcul passée 
à la fonction ;
L’unité de calcul peut être de type : jour, mois, année, 
heure, minute, seconde
*/

drop function if exists exercice2;
delimiter $$
create function exercice2(date1 date,date2 date,unite varchar(10))
returns varchar(30)
deterministic

begin
    declare diffrence varchar(30);
    set diffrence = case unite
		when 'jour' then datediff(date2,date1)
        when 'mois' then timestampdiff(month,date1,date2)
        when 'annee' then timestampdiff(year,date1,date2)
        when 'heure' then timestampdiff(hour,date1,date2)
        when 'minute' then timestampdiff(minute,date1,date2)
        when 'seconde' then timestampdiff(second,date1,date2)
        end;
	return diffrence;
end $$
delimiter ;
select exercice2('2022-06-01','2023-12-01','jour');
select exercice2('2022-06-01','2023-12-01','mois');
select exercice2('2022-06-01','2023-12-01','annee');
select exercice2('2022-06-01','2023-12-01','heure');
select exercice2('2022-06-01','2023-12-01','minute');
select exercice2('2022-06-01','2023-12-01','seconde');


/*Exercice 3 : application sur la bd ‘gestion_vols’
Gestion vol
Pilote(numpilote,nom,titre,villepilote,daten,datedebut)
Vol(numvol,villed,villea,dated,datea, #numpil,#numav)
Avion(numav,typeav ,capav)
*/


drop database if exists vols_202;

create database vols_202 collate utf8mb4_general_ci;
use vols_202;

create table Pilote(numpilote int auto_increment primary key,
nom varchar(50),
titre varchar(50),
villepilote varchar(50),
daten date,
datedebut date);

create table Avion(numav int auto_increment primary key,
typeav  varchar(50),
capav int);

create table Vol(numvol int auto_increment primary key,
villed varchar(50),
villea varchar(50),
dated date,
datea date, 
numpil int,
constraint fk_vols_pilote foreign key(numpil) references pilote(numpilote),
numav int,
constraint fk_vols_avion foreign key(numav) references avion(numav));

insert into pilote values (1,'khalid','M.','tetouan','1980-01-01','2000-01-01'),
(2,'souad','Mme.','casablanca','1990-01-01','2010-01-01'),
(3,'mohamed','M.','marrakech','2000-01-01','2022-01-01');


insert into pilote values (4,'qlq','M.','tetouan','1980-01-01','2000-01-01');


insert into avion values (1,'boeing',120),
(2,'caravel',30),
(3,'airbus',150);

insert into avion values (4,'test',120);

insert into vol values
(1,'tetouan','casablanca','2023-10-01','2023-10-01',1,1),
(2,'tetouan','casablanca','2023-10-01','2023-10-01',1,2),
(3,'casablanca','tetouan','2023-10-02','2023-10-02',1,3),
(4,'tanger','casablanca','2023-10-03','2023-10-03',2,1),
(5,'casablanca','tanger','2023-10-04','2023-10-04',2,2),
(6,'marrakech','casablanca','2023-10-05','2023-10-05',2,3),
(7,'casablanca','marrakech','2023-10-06','2023-10-06',3,1),
(8,'tanger','marrakech','2023-10-07','2023-10-07',3,2),
(9,'marrakech','tanger','2023-10-08','2023-10-08',3,3),
(10,'tetouan','casablanca','2023-10-12','2023-10-12',1,2),
(11,'casablanca','tetouan','2023-10-12','2023-10-12',1,2);


#1.	Ecrire une fonction qui retourne le nombre de pilotes 
# ayant effectué un nombre de vols supérieur
# à un nombre donné comme paramètre ;

drop function if exists ex3;
delimiter $$
create function ex3(numv int)
returns int
deterministic
begin
	declare countp int;
    select count(*) into countp 
    from(select numpil 
		from vol 
        group by numpil 
        having count(*)>numv) f;
    return countp;
end $$
delimiter ;
select ex3(0);
select ex3(1);
select ex3(3);
select ex3(8);










#2.	Ecrire une fonction qui retourne la durée de travail d’un 
#pilote dont l’identifiant est passé comme paramètre ;



drop function if exists EX2;
delimiter $$
create function EX2(id_pilote int)
returns varchar(150) 
deterministic
begin 
	declare duree, d, m, y int ;
	 select timestampdiff(day, datedebut,current_time) into duree from pilote 
	 where numpilote=id_pilote;
     set y = floor(duree/365);
     set m = floor((duree%365)/30);
     set d = (duree%365)%30;
	 return concat(y,' year(s) ', m,' month(s) ', d , ' day(s)');
end $$
 
 delimiter ;
 select EX2(1);



#3.	Ecrire une fonction qui renvoie le nombre des avions qui ne 
#sont pas affectés à des vols ;

#methode 1
drop function if exists e3q3;
delimiter $$
create function e3q3()
returns int
reads sql data
begin
	declare nbavions int;
    select count(*) into nbavions from avion
    where numav not in (select numav from vol) ;
    return nbavions;
end$$
delimiter ;

#methode 2
drop function if exists e3q3;
delimiter $$
create function e3q3()
returns int
reads sql data
begin
	declare nbavions int;
    select count(*) into nbavions  
from avion a left join vol v on a.numav = v.numav
where v.numvol is null ;
    return nbavions;
end$$
delimiter ;


select e3q3();

#4.	Ecrire une fonction qui retourne le numero du plus ancien 
#pilote qui a piloté l’avion dont le numero est passé en paramètre ;
drop function if exists qst4;
delimiter //
create function qst4(num int)
returns	int
deterministic
begin
	declare nump int;
    select numpilote into nump from pilote
    join vol on pilote.numpilote = vol.numpil
    where vol.numav = num
    order by vol.dated
    limit 1;
    return (nump);
end //
delimiter ;
select qst4(1);

select * from pilote where datedebut in (

select min(datedebut) from pilote p join vol v on p.numpilote = v.numpil
where numav = 1
)
and numpilote in (select numpil from vol where numav = 1)






#5.	Ecrire une fonction table qui retourne le nombre des pilotes dont le salaire est inférieur à une valeur passée comme paramètre ;


/*Exercice 4:
Considérant la base de données suivante :
DEPARTEMENT (ID_DEP, NOM_DEP, Ville)
EMPLOYE (ID_EMP, NOM_EMP, PRENOM_EMP, DATE_NAIS_EMP, SALAIRE,#ID_DEP)
*/



drop database if exists employes_202;

create database employes_202 COLLATE "utf8_general_ci";
use employes_202;


create table DEPARTEMENT (
ID_DEP int auto_increment primary key, 
NOM_DEP varchar(50), 
Ville varchar(50));

create table EMPLOYE (
ID_EMP int auto_increment primary key, 
NOM_EMP varchar(50), 
PRENOM_EMP varchar(50), 
DATE_NAIS_EMP date, 
SALAIRE float,
ID_DEP int ,
constraint fkEmployeDepartement foreign key (ID_DEP) references DEPARTEMENT(ID_DEP));

insert into DEPARTEMENT (nom_dep, ville) values 
		('FINANCIER','Tanger'),
		('Informatique','Tétouan'),
		('Marketing','Martil'),
		('GRH','Mdiq');

insert into EMPLOYE (NOM_EMP , PRENOM_EMP , DATE_NAIS_EMP , SALAIRE ,ID_DEP ) values 
('said','said','1990/1/1',8000,1),
('hassan','hassan','1990/1/1',8500,1),
('khalid','khalid','1990/1/1',7000,2),
('souad','souad','1990/1/1',6500,2),
('Farida','Farida','1990/1/1',5000,3),
('Amal','Amal','1990/1/1',6000,4),
('Mohamed','Mohamed','1990/1/1',7000,4);

#1.	Créer une fonction qui retourne le nombre d’employés
drop function  IF EXISTS e4q1;
delimiter $$
create function e4q1()
returns int
deterministic
begin
    return (select count(*) from Employe);
end$$
delimiter ;
select e4q1();



#2.	Créer une fonction qui retourne la somme des salaires de tous les employés

drop function IF EXISTS  e4q2;
delimiter $$
create function e4q2()
returns int
deterministic
begin
    return (select sum(salaire) from Employe);
end$$
delimiter ;
select e4q2();




#3.	Créer une fonction pour retourner le salaire minimum de tous les employés


drop function IF EXISTS e4q3;
delimiter $$
create function e4q3()
returns int
deterministic
begin
    return (select min(salaire) from Employe);
end$$
delimiter ;
select e4q3();

#4.	Créer une fonction pour retourner le salaire maximum de tous les employés


drop function IF EXISTS e4q4;
delimiter $$
create function e4q4()
returns int
deterministic
begin
    return (select mAX(salaire) from Employe);
end$$
delimiter ;
select e4q4();

#5.	En utilisant les fonctions créées précédemment, Créer une requête pour afficher le nombre des employés, la somme des salaires, le salaire minimum et le salaire maximum

select e4q1() as nbEmployes,e4q2() as sommeSalaires,e4q3() as salaireMinimal,e4q4() as salaireMaximal;




#6.	Créer une fonction pour retourner le nombre d’employés d’un département donné.
drop function if exists e4q6;
delimiter $$
create function e4q6( id int)
returns int 
deterministic
begin
   return( select count(*) nb from employe where id_dep= id);
end $$
delimiter ;
select e4q6(2);

#7.	Créer une fonction la somme des salaires des employés d’un département donné
drop function if exists e4q7;
delimiter $$
create function e4q7( id int)
returns int 
deterministic
begin
   return( select sum(salaire) nb from employe where id_dep= id);
end $$
delimiter ;
select e4q7(2);

#8.	Créer une fonction pour retourner le salaire minimum des employés d’un département donné
drop function if exists e4q8;
delimiter $$
create function e4q8( id int)
returns int 
deterministic
begin
   return( select min(salaire) nb from employe where id_dep= id);
end $$
delimiter ;
select e4q8(2);
#9.	Créer une fonction pour retourner le salaire maximum des employés d’un département.

drop function if exists e4q9;
delimiter $$
create function e4q9( id int)
returns int 
deterministic
begin
   return( select max(salaire) nb from employe where id_dep= id);
end $$
delimiter ;
select e4q9(2);
#10.	En utilisant les fonctions créées précédemment, 
#Créer une requête pour afficher pour chaque departement les éléments suivants : 
#a.	Le nom de département en majuscule. 
#b.	La somme des salaires du département
#c.	Le salaire minimum
#d.	Le salaire maximum

select upper(nom_dep) as nomDepartement,e4q6(id_dep) as nbEmploye,e4q7(id_dep) as sommeSalaires,e4q8(id_dep) as salaireMinimal,e4q9(id_dep) as salaireMaximal from departement;

#11.	Créer une fonction qui accepte comme paramètres 
#2 chaines de caractères et elle retourne les deux chaines 
#en majuscules concaténé avec un espace entre eux.#

drop function if exists q11;
delimiter $$
create function q11( a varchar(30), b varchar(30))
returns varchar(30)
deterministic
begin
	declare res varchar (50);
	set a= upper(a);
	set b= upper(b);
	set res= concat(a, " ", b);
	return res;
end $$
delimiter ;
select q11("dev","202");

