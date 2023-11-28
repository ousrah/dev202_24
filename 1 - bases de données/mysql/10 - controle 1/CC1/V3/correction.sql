/*Pour gérer les élections des représentants des employés d’une entreprise, une application utilise une base de données composée des tables Electeurs, Candidats et Votes :
Electeurs (idElecteur , nomElecteur, prenomElecteur, aVoté)
Le champ aVoté prend la valeur 0 quand l’électeur n’a pas encore voté et 1 quand il a voté.

Candidat(idCandida,nomCandidat,prenomCandidat,dateNaissance, nombreVoix)
nombreVoix est le nombre de voix obtenus par le candidat.

 Votes (#idElecteur , #idCandidat)
Cette table enregistre les votes des électeurs.
*/

drop database if exists cc1v3;
create database cc1v3 collate utf8mb4_general_ci;
use cc1v3;

create table Electeur(idElecteur int auto_increment primary key , 
nomElecteur varchar(50), 
prenomElecteur varchar(50), 
aVote boolean default 0);

create table Candidat(idCandidat int auto_increment primary key ,
nomCandidat varchar(50),
prenomCandidat varchar(50),
dateNaissance date, 
nombreVoix int);

create table Votes (
idElecteur int , 
idCandidat int,
constraint pk_votes primary key (idElecteur, idCandidat),
constraint fk_votes_electeur foreign key (idElecteur) references electeur(idElecteur),
constraint fk_votes_Candidat foreign key (idCandidat) references Candidat(idCandidat)
);

insert into electeur values (null,'e1','e1',0),
(null,'e2','e2',0),
(null,'e3','e3',0),
(null,'e4','e4',0),
(null,'e5','e5',0),
(null,'e6','e6',0);

insert into Candidat values (null,'e1','e1','1980-11-01',0),
(null,'e2','e2','1980-11-01',0),
(null,'e3','e3','1999-10-01',0),
(null,'e4','e4','1966-12-01',0),
(null,'e5','e5','2000-03-01',0),
(null,'e6','e6','2002-04-01',0);

insert into votes values (1,1),(2,1),(3,1),(4,3),(5,1),(6,3);


#1) Ecrire une fonction Q1 qui retourne le nombre des candidats de la base de données. (2 pts)
drop function if exists q1;
delimiter $$
create function q1()
returns int
reads sql data
begin
	return (select count(*) from candidat);
end $$
delimiter ;
select q1();


#2) Ecrire une fonction Q2 qui retourne le nom complet (concatenation du nom et du prénom) d’un électeur dont l’identifiant est passé comme paramètre. (2 pts)

drop function if exists q2;
delimiter $$
create function q2(id int)
returns varchar(100)
reads sql data
begin
	return (select concat(prenomelecteur, ' ', nomelecteur) as nomComplet from electeur where idElecteur =id);
end $$
delimiter ;
select q2(2);


#3) Ecrire une vue Q3 qui affiche pour chaque candidat la liste de ces électeurs qui ont voté 
#pour lui triés par nom et par âge de candidat des plus vieux au plus jeunes (idCandidat, nomCandidat, prenomCandidat, idElecteur nomElecteur, prenomElecteur) (2pts)
create view q3 as select
c.idCandidat , c.nomCandidat , c.prenomCandidat , e.idElecteur , e.nomElecteur , e.prenomElecteur 
  from candidat c 
  join votes v  on c.idCandidat = v.idCandidat 
  join electeur e on  e.idElecteur = v.idElecteur
  order by c.dateNaissance  ASC;


#4) Ecrire une fonction Q4 qui accepte comme paramètres le nombre des votes  et qui 
#retourne le nombre des candidats qui ont obtenus plus que ce nombre. (2 pts)


drop function if exists q4;
delimiter $$
create function q4(nb int)
returns int
deterministic
begin
	return (select count(*) from (
select idCandidat, count(idElecteur) from votes group by idCandidat having count(idElecteur) > nb) f);
end $$
delimiter ;

select q4(4);












drop function if exists q4;
delimiter $$
create function q4(nb int)
returns int
deterministic
begin
	return (select count(*) from candidat where nombreVoix > nb );
end $$
delimiter ;
select q4(1);




#5) Ecrire une procédure stockée Q5 qui accepte le id d’un candidat et qui affiche la liste
# des candidats qui ont obtenus le même nombre de votes que lui (le candidat dont l’id est passé comme 
# paramètre ne doit pas exister dans cette liste). (2 pts)


drop procedure if exists q5;
delimiter $$
create procedure q5(idC int)
reads sql data
begin
	declare nbV int;
    select  count(idElecteur) into nbV from votes where idCandidat = idC group by idCandidat ;
	select * from candidat where idCandidat in (
					select idCandidat from votes  
					where idCandidat!=idC 
					group by idCandidat  
					having count(idElecteur) = nbV
        );
end $$
delimiter ;
select * from votes;
call q5(2);


select * from candidat where id in 


;





call q5(2);

drop procedure if exists q5;
delimiter $$
create procedure q5(idC int)
reads sql data
begin
	select * from candidat
    where nombreVoix = (select nombreVoix from candidat
						where idCandidat = idC)
	and idCandidat <> idC;
end $$
delimiter ;

call q5(2);


#6) Ecrire un trigger Q6 qui permet d’incrémenter de 1,
# le champ nombreVoix d’un candidat à chaque ajout d’une ligne à la table Votes
# qui concerne ce candidat.
# Le trigger doit également mettre le champ aVoté à 1 pour l’électeur qui vient de voter. (2 pts)

drop trigger if exists q6;
delimiter $$
create trigger q6 after insert on votes for each row
	begin
		update candidat set nombreVoix = nombreVoix + 1 where idCandidat = new.idCandidat;
        update electeur set aVote = 1 where idElecteur = new.idElecteur;
    end $$
delimiter ;

select * from votes;
insert into votes value (4,2);
select * from candidat;
select * from electeur;
#7) Ecrire une procédure stockée Q7 qui permet d’enregistrer le vote 
#d’un électeur ; 


#Cette procédure sera appelée comme suit :   call Q7 (130,120,300,null)
#elle a les paramètres : 
#•	idElect : identifiant de l’électeur. (130 dans notre exemple)
#•	idCandidat1 (120), idCandidat2(300) et idCandidat3(null) : 
#identifiants des 3 candidats choisis par l’électeur.
#La procédure ajoute 1 à 3 lignes à la table Votes selon les valeurs 
#non NULL des paramètres idCandidat1, idCandidat2 et idCandidat3.
#Si ces paramètres sont tous NULL, la procédure affiche un message d’erreur. (2 pts)
drop procedure if exists q7 ;
Delimiter //
create procedure q7(ide int ,idc1 int ,idc2 int ,idc3 int)
begin
	if (idc1 is null and idc2 is  null and idc3 is  null  ) then
		select "Erreur" ;
	else 
			if idc1 is not null then
				insert into votes values (ide,idc1);
			end if;
			if idc2 is not null then
				insert into votes values (ide,idc2);
            end if;    
			if idc3 is not null then
				insert into votes values (ide,idc3);
			end if; 
	end if ;
								
end //
delimiter ;

select * from electeur;

call q7(6,1,2,null);

select * from votes where idelecteur = 5;
