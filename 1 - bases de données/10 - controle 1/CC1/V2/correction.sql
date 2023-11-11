/*La base de données suivante sert à gérer les absences des stagiaires :
•	Stagiaire (idstagiaire, nom, prenom, #idFiliere, TotalAbsence)
•	Filiere (idFiliere, nomFiliere)
•	Module (idModule, nomModule, NbreHeure)
•	Fil_Module (#idFiliere, #idModule)
•	Absence (idAbsence, dateAbs, #idStagiaire, #idModule, TypeAbsence)
NB : les champs en gras sont des clés primaires, les champs précédés par # sont des clés étrangères.
On s’intéresse aux absences des stagiaires par module de formation. Un module est enseigné à plusieurs filières.
Une absence a un type (Type absence) qui peut prendre les valeurs « justifiée » ou « non justifiée ».
La table absence enregistre les absences à raison d’une ligne par séance. 
On suppose qu’une séance a une durée de 2h30mn (2,5 heures). Le champ TotalAbsence enregistre le nombre total d’absences EN SEANCES d’un stagiaire (absence justifiée et non justifiée).
*/
drop database if exists cc1v2;
create database if not exists cc1v2 collate utf8mb4_general_ci;
use cc1v2;


create table Stagiaire (idstagiaire int auto_increment primary key, 
nom varchar(50), 
prenom varchar(50), 
idFiliere int, 
TotalAbsence int);

create table Filiere (idFiliere int auto_increment primary key, 
nomFiliere varchar(50));

create table Module (idModule int auto_increment primary key, 
nomModule varchar(50), 
NbreHeure float);

create table Fil_Module (idFiliere int, 
idModule int,
constraint pk_filmodule primary key (idFiliere, idModule));

create table Absence (idAbsence int auto_increment primary key, 
dateAbs datetime, 
idStagiaire int, 
idModule int, 
TypeAbsence varchar(50));


alter table stagiaire add constraint fk_stagiaire_filiere foreign key (idFiliere) references filiere(idFiliere);

alter table Fil_Module add constraint fk_Fil_Module_filiere foreign key (idFiliere) references filiere(idFiliere);
alter table Fil_Module add constraint fk_Fil_Module_Module foreign key (idModule) references Module(idModule);

alter table Absence add constraint fk_absence_stagiaire foreign key (idStagiaire) references Stagiaire(idStagiaire);
alter table Absence add constraint f_absence_Module foreign key (idModule) references Module(idModule);


insert into filiere values 
(null,'DD'),
(null,'ID');

insert into stagiaire values 
(null,'st1','st1',1,0),
(null,'st2','st2',1,0),
(null,'st3','st3',1,0),
(null,'st4','st4',2,0),
(null,'st5','st5',2,0);

insert into module values 
(null,'mod1',0), 
(null,'mod2',0), 
(null,'mod3',0), 
(null,'mod4',0), 
(null,'mod5',0);

insert into fil_module values 
(1,1),
(1,2),
(1,4),
(2,1),
(2,3),
(2,5);

insert into absence  values 
(null,'2023-11-09',1,1,'justifiée'),
(null,'2023-11-09',2,1,'non justifiée'),
(null,'2023-11-09',3,2,'justifiée'),
(null,'2023-11-09',1,4,'non justifiée'),
(null,'2023-11-09',3,1,'justifiée'),
(null,'2023-11-09',4,1,'non justifiée'),
(null,'2023-10-10',1,1,'justifiée'),
(null,'2023-10-09',1,4,'justifiée'),
(null,'2023-10-08',1,4,'justifiée');
insert into absence values (null,'2023-10-08',2,1,'justifiée');
select * from absence;
#1) Ecrire une fonction Q1 qui retourne le nombre des stagiaires 
#de la base de données. (2 pts)
delimiter $$
create function q1()
returns int
reads sql data
begin 
	return (select count(*) from stagiaire );
end$$
delimiter  ;
select q1();


#2) Ecrire une fonction Q2 qui retourne le nom d’une filière dont l’identifiant est 
#passé comme paramètre. (2 pts)
drop function if exists q2;
delimiter $$
create function q2( idf int)
returns varchar(50)
reads sql data
begin 
	return (select nomFiliere from filiere
    where idFiliere=idf);
end$$
delimiter  ;
select q2(1);
#3) Ecrire une vue Q3 qui affiche pour chaque stagiaire la liste de ces 
#absences par module triés des plus récentes au plus anciennes 
#(idstagiaire, nom, prenom, nomModule, dateAbs, TypeAbsence) (2pts)
create view q3 as
	select s.idstagiaire, nom, prenom, nomModule, dateAbs, TypeAbsence from stagiaire s
    join absence a on s.idstagiaire=a.idstagiaire
    join module m on m.idmodule=a.idmodule
    order by dateabs desc;
select*from q3;

#4) Ecrire une fonction Q4 qui accepte comme paramètres une période 
#(date début et date fin) et le id  d'une filière et retourne le nombre des 
#absences totale de cette filière pendant cette période. (2 pts)
drop function if exists q4;
delimiter $$
create function q4(dd date, df date, idf int)
returns int
reads sql data
begin
	return (select count(*) 
	from stagiaire s 
	join absence a on s.idstagiaire=a.idstagiaire
	where dateabs between dd and df 
	and s.idFiliere = idf);
end $$
delimiter ;

select q4('2023-11-08','2023-11-11',2);

#5) Ecrire une procédure stockée Q5 qui accepte le id d’un stagiaire et qui retourne
# le nom du module pour lequel il a effectué le plus d’absences (si plusieurs modules
# existent prendre juste le premier). (2 pts)
drop procedure if exists q5;
delimiter $$
create procedure q5(in ids int,out nomM varchar(50))
begin
	select nomModule into nomM from absence a
    join module m on a.idModule=m.idModule
    where idStagiaire = ids
    group by a.idModule 
    order by count(*) desc
    limit 1;
end $$
delimiter ;

call q5(5,@nom);
select @nom;



#6) Ecrire un trigger  Q6 met à jour le champ TotalAbsence de la table Stagiaire 
# à chaque ajout d’une absence. (2 pts)

drop  trigger if exists q6;
delimiter &
create trigger q6 after insert on absence for each row
begin
	update stagiaire 
    set TotalAbsence = TotalAbsence + 1
    where idStagiaire = new.idStagiaire;
end &
delimiter ;

select * from stagiaire;

insert into absence values (null, "2023-11-10", 1, 1, "justifiée")

#7) Ecrire une procédure stockée qui affiche la liste des stagiaires qui ont dépassé
# la limite d’absences (justifiées ou non) de 30% de la masse horaire (NbreHeure)
# d’un module donné. (2 pts)

drop procedure if exists q7;
delimiter $$
create procedure q7(in idM int)
begin
	declare limite float;
    set limite = 0.3 * (select NbreHeure from Module where idModule = idM);
    
    select s.* from absence a
    join stagiaire s on a.idStagiaire = s.idStagiaire
    where idModule = idM
    group by a.idStagiaire
    having count(*) * 2.5 > limite;
end $$
delimiter ;


call q7(1);
