/*Une application de gestion de stock des articles qui se trouvent dans des établissements de formation utilise une base de données appelée GestArticle contenant les tables suivantes:
Etablissement (codeEtab, nomEtab, ville)
Beneficiaire (codeBen, nomBen, #codeEtab, totalMontantConsommation)
Article (codeArt , nomArt, type , PU)
Etab_Art (#codeEtab , #codeArt , QteStock)
SortieArt (numBonSort, DateSortie , Qte , #codeArt , #CodeBen )
*/
drop database if exists cc1v1;
create database cc1v1 collate utf8mb4_general_ci;
use cc1v1;

create table Etablissement (codeEtab int auto_increment primary key, 
nomEtab varchar(50), 
ville varchar(50));

create table Beneficiaire (codeBen int auto_increment primary key, 
nomBen varchar(50) ,
codeEtab int, 
totalMontantConsommation float,
constraint fk_ben_etab foreign key (codeEtab) references Etablissement(codeEtab));

create table Article (codeArt  int auto_increment primary key, 
nomArt varchar(50), 
type  varchar(50), 
PU float);

create table Etab_Art (codeEtab  int, 
codeArt int , QteStock int, 
constraint pketab_art primary key (codeEtab,codeArt) ,
constraint fk_etab_art_etab foreign key (codeEtab) references Etablissement(codeEtab),
constraint fk_etab_art_art foreign key (codeArt) references Article(codeArt));

create table SortieArt (numBonSort int auto_increment primary key, 
DateSortie datetime , 
Qte int , 
codeArt int , 
CodeBen int,
constraint fk_sortieArt_art foreign key (codeArt) references Article(codeArt),
constraint fk_sortieArt_ben foreign key (CodeBen) references Beneficiaire(CodeBen)
);

insert into etablissement values (1,'ismo','martil'),(2,'ista rs','tetouan');
insert into beneficiaire values (1,'formateur1',1,0),(2,'foramteur 2',2,0);
insert into article values (1,'feutre','consomable',10),
(2,'souris','consomable',50),
(3,'projecteur','immobilier',3500),
(4,'pc','immobilier',7800);

insert into Etab_Art values (1,1,20),(1,2,50),(1,3,5),(1,4,30),(2,1,500),(2,2,100);

insert into SortieArt values (null,'2023-10-30',2,1,1),
(null,'2023-10-30',2,2,1),
(null,'2023-10-30',1,3,1),
(null,'2023-10-30',1,1,2),
(null,'2023-10-30',1,4,1);


#N.B : Les champs en gras et soulignés sont des clés primaires. les champs précédés par # sont des clés étrangères 
#Un article peut exister dans plusieurs établissements avec une quantité en stock qui diffère d'un établissement à un autre. 
#Un article peut subir une sortie vers un bénéficiaire qui peut être un formateur, un employé de l'administration ...etc. 
#La sortie article est enregistrée dans la table SortieArt qui enregistre la date de sortie, le code de l'article, le bénéficiaire et la quantité à sortir de l'article. 
#De même, un article peut être transféré d'un établissement à un autre établissement de destination avec une quantité donnée.

#1) Ecrire une fonction Q1 qui retourne le nombre des articles de la base de données. (2 pts)
drop function if exists q1;
delimiter $$
create function q1()
returns int
reads sql data
begin
	return (select count(*) from article);
end$$
delimiter ;

select q1();



#2) Ecrire une fonction Q2 qui retourne le prix unitaire d’un article dont le numéro est passé comme paramètre. (2 pts)

drop function if exists q2;
delimiter $$
create function q2( id int)
returns float
reads sql data
begin
	return (select PU from article where codeArt = id);
end$$
delimiter ;

select q2(3);

#3) Ecrire une vue Q3 qui affiche pour chaque établissement la liste des articles qu’il possède triès 
#par prix unitaire du plus chère au moins chère (CodeEtab, NomEtab, CodeArt, NomArt, PU, QteStock) (2pts)

create view q3 as 
	select distinct e.codeEtab,e.NomEtab,a.CodeArt,a.NomArt,a.PU,eta.QteStock from Etablissement e 
	join Etab_Art eta on e.codeEtab=eta.codeEtab
	join article a on eta.CodeArt=a.CodeArt
	order by a.pu desc;

select * from q3;


#4) Ecrire une fonction Q4 qui accepte comme paramètres une période (date début et date fin)
# et le code d'un établissement et retourne la valeur en Dirham de la consommation total des
# articles de cet établissement pendant cette période. (2 pts)

drop function if exists q4;

#methode1 
delimiter $$
create function q4(datedebut date , datefin date ,idetab int)
returns varchar(50)
reads sql data
begin
	declare valeur varchar(50);
    select  sum(PU*QTE) into valeur from beneficiaire b join sortieart s on b.codeben = s.codeben
    join article a on s.codeart = a.codeart
    where b.codeetab=idetab  and datesortie between datedebut and datefin;
	return valeur;
end$$
delimiter ;

select q4('2023-10-15','2023-10-31',1);

#methode2 suppose que le trigger existe
delimiter $$
create function q4(datedebut date , datefin date ,idetab int)
returns varchar(50)
reads sql data
begin
	declare valeur varchar(50);
    select sum(totalMontantConsommation) into valeur from beneficiaire 
    where codeetab=idetab  and codeben in(select codeben from sortieart 
											where datesortie between datedebut and datefin);
	return valeur;
end$$
delimiter ;
select q4('2023-10-15','2023-10-31',1);




#5) Ecrire une procédure stockée Q5 qui accepte le code d’un bénéficiaire et qui retourne 
#le nom et le prix de l’article plus chère qu’il a consommé 
#(si plusieurs articles existent prendre juste le premier). (2 pts)



drop procedure if exists q5; 
delimiter $$
create procedure q5(idben int, out nom varchar(100), out prix float)
begin
	select  nomart into nom  from  sortieart s  join article a on s.codeart = a.codeart
  where codeben = idben
  order by pu desc
  limit 1;
  	select  pu into prix  from  sortieart s  join article a on s.codeart = a.codeart
  where codeben = idben
  order by pu desc
  limit 1;
end $$
delimiter ;
  
  call q5(1,@n,@p);
  select @n,@p;
  
  
drop procedure if exists q5; 
delimiter $$
create procedure q5(idben int, out nom varchar(100))
begin
	select  concat(nomart, ' ', pu) into nom  from  sortieart s  join article a on s.codeart = a.codeart
  where codeben = idben
  order by pu desc
  limit 1;
end $$
delimiter ;
  
  call q5(1,@n);
  select @n;
  
  

#6) Ecrire un trigger  Q6 met à jour le champ totalMontantConsommation de la table 
#Beneficiaire a chaque sortie d'un article. (2 pts)
drop trigger q6;
delimiter &&
create trigger q6 after insert on SortieArt for each row
begin
	update beneficiaire set totalMontantConsommation=totalMontantConsommation+new.qte*
	(select pu from article where codeart=new.codeart)
    where codeben=new.codeben;

end&&
delimiter ;
insert into SortieArt values (null,'2023-10-30',2,4,1);
select * from beneficiaire;


7) Il existe des établissements qui ont un surplus dans certains articles ;
# il est alors possible de transférer (déplacer) une quantité d'un article donné 
#d'un établissement vers un autre établissement. 
#Ecrire une procédure stockée appelée Q7 qui permet de transférer une quantité 
#d'un article donné d'un établissement source vers un autre établissement destination. 
#La procédure possède les paramètres: 
#code de l'établissement source, code de l'établissement de destination, 
#code article à transférer et quantité à transférer. 
#La procédure doit 
#• Retourner un message d’erreur si la quantité de l'article à transférer est insuffisante dans l'établissement source;
#• Retourner un message d’erreur si le code établissement source est égal à celui de l'établissement de destination.
#• Si aucune des erreurs précédentes, ajouter la quantité à transférer à la quantité en stock de l'article concerné de l'établissement de destination et diminuer cette même quantité de l'établissement source; puis retourner un message qui indique l’operation est effectuée avec succès. (2 pts)
drop procedure if exists q7;
delimiter $$
create procedure q7 (idS int, idD int, art int, q int, out msg varchar(250))
begin
	declare stock int;
    select qtestock into stock from etab_art where  codeetab = idS and codeart = art;
    if q>stock then
		set msg = 'la quantité de l''article à transférer est insuffisante dans l''établissement source';
	elseif idS=idD then
		set msg = 'le code établissement source est égal à celui de l''établissement de destination';
    else    
		update etab_art set  qtestock = qtestock - q where  codeetab = idS and codeart = art;
		update etab_art set  qtestock = qtestock + q where  codeetab = idD and codeart = art;
		set msg = 'stock transféré avec succés';
    end if;
end $$
delimiter ;

select * from etab_art;
call Q7(2,1,1,100,@msg);
select @msg;