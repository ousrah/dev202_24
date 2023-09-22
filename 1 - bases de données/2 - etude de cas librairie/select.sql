select ceiling(rand()*23);
USE LIBRAIRIE_201;
# 1.	Liste des noms des éditeurs situés à Paris triés 
#par ordre alphabétique. 

select NOMED from editeur
where VILLEED ='Paris'
order by NOMED;

#2.	Liste des écrivains de (tous les champs)  langue française, 
#triés par ordre alphabétique sur le prénom et le nom  .
select * from ecrivain
where languecr = "francais"
order by  prenomecr ,nomecr asc; 

#3.	Liste des titres des ouvrages (NOMOUVR) ayant été
# édités entre (ANNEEPARU) 1986 et 1987.

select NOMOUVR, anneeparu
from ouvrage 
where ANNEEPARU between 1986 and 1987;

#where anneeparu >=1986 
#		and anneeparu <=1987; 

#4.	Liste des éditeurs dont le n° de téléphone est inconnu
select nomed, teled
from editeur
where teled is null ;


#5.	Liste des auteurs (nom + prénom) dont le nom contient un ‘C’.

select nomecr , prenomecr
from ecrivain 
where nomecr like '%c%' ;

#6.	Liste des titres d’ouvrages contenant  le mot "banque"
# (éditer une liste triée par n° d'ouvrage croissant). 
select NOMOUVR ,NUMOUVR 
FROM ouvrage where NOMOUVR like '%banque%'
order by NUMOUVR ASC;




#7.	Liste des dépôts (nom) situés à Grenoble ou à Lyon. 

SELECT NOMDEP, villedep
FROM depot
where villedep in  ("Grenoble" ,"Lyon");

#8.	Liste des écrivains (nom + prénom) américains
# ou de langue française. 

select *from ecrivain
where PAYSeCR="USA" or LANGUECR="Francais";


#9.	Liste des auteurs (nom + prénom) de langue française dont le nom ou 
#le prénom commence par un ‘H’. 
select nomecr nom,prenomecr prenom, languecr
from ecrivain
where (prenomecr like 'H%' or nomecr like "H%") and  LANGUECR="Francais";

select 5 * 3 + 2;
select 2 + 5 * 3 ;


#10.	Titres des ouvrages en stock au dépôt n°2. 

select NOMOUVR
from OUVRAGE O
join STOCKER S ON O.NUMOUVR = S.NUMOUVR
where NUMDEP = 2;

#11.	Liste des auteurs (nom + prénom) ayant écrit des livres 
#coûtant au moins 30 € au 1/10/2002. 
select distinct NOMECR,PRENOMECR from ecrivain e
join ecrire ec on 	e.NUMECR=ec.NUMECR
join tarifer t on ec.NUMOUVR=t.NUMOUVR
WHERE PRIXVENTE>= 30 AND DATEDEB='2002/10/01';

create view R11 as 
select distinct NOMECR,PRENOMECR from ecrivain e
join ecrire ec on 	e.NUMECR=ec.NUMECR
join tarifer t on ec.NUMOUVR=t.NUMOUVR
WHERE PRIXVENTE>= 30 AND DATEDEB='2002/10/01';


#12.	Ecrivains (nom + prénom) ayant écrit des livres sur le thème 
#(LIBRUB) des « finances publiques ». 
select distinct e.NOMECR ,E.prenomecr
 from ecrivain e
join ecrire ecr on ecr.numecr=e.numecr
join ouvrage o on ecr.numouvr= o.numouvr
join classification c on o.numrub= c.numrub
where c.librub="finances publiques";


#13.	Idem R12 mais on veut seulement les auteurs dont le nom contient un ‘A’. 
create view R12 as 
select distinct e.NOMECR ,E.prenomecr
 from ecrivain e
join ecrire ecr on ecr.numecr=e.numecr
join ouvrage o on ecr.numouvr= o.numouvr
join classification c on o.numrub= c.numrub
where c.librub="finances publiques";

select * from R12 where NOMECR like '%A%';

#14.	En supposant l’attribut PRIXVENTE dans TARIFER comme un prix 
#TTC et un taux de TVA égal à 15,5% sur les ouvrages, donner le prix 
#HT de chaque ouvrage. 

select o.nomouvr,t.prixvente /1.155 prix_ht, t.prixvente as prix_ttc
from ouvrage o
join tarifer t on t.numouvr=o.numouvr;

#15.	Nombre d'écrivains dont la langue est l’anglais ou l’allemand. 
select count(numecr) as Nombre_Ecrivains from ecrivain
where languecr in ('Anglais','Allemand');

#16.	Nombre total d'exemplaires d’ouvrages sur la « gestion de portefeuilles »
# (LIBRUB) stockés dans les dépôts Grenoblois. 
select sum(qtestock)
from classification c
join ouvrage o on c.NUMRUB=o.NUMRUB
join stocker s on o.NUMOUVR=s.NUMOUVR
join depot d on s.NUMDEP=d.NUMDEP
where VILLEDEP='grenoble' 
and librub='gestion de portefeuilles';



#17.	Titre de l’ouvrage ayant le prix le plus élevé 
#- faire deux requêtes. (réponse: Le Contr ôle de gestion dans la banque.)


select NOMOUVR
from ouvrage o 
join tarifer t on 
t.numouvr=o.numouvr
where t.prixvente=(select max(prixvente)from tarifer);

#cette réponse est fausse
select  o.nomouvr, prixvente
from ouvrage o join tarifer t on o.numouvr = t.numouvr
order by prixvente desc limit 1
;






#18.	Liste des écrivains avec pour chacun le nombre d’ouvrages qu’il a écrits. 
select concat(NOMECR,PRENOMECR) AS AUTEUR , count(ec.NUMOUVR) AS NOMBREOUVRAGEECRITS
FROM ECRIVAIN E
JOIN Ecrire ec ON ec.NUMECR=e.NUMECR
group by auteur;
#having count(ec.NUMOUVR)>=3;


#19.	Liste des rubriques de classification avec, pour chacune, 
#le nombre d'exemplaires en stock dans les dépôts grenoblois. 

select cl.librub rubrique, sum(st.qtestock) nb_exemplaire from classification cl
join ouvrage o on o.numrub = cl.numrub
join stocker st on st.numouvr = o.numouvr
join depot dp on dp.numdep = st.numdep
where dp.villedep = 'grenoble'
group by rubrique;

#20.	Liste des rubriques de classification avec leur état de stock 
#dans les dépôts grenoblois: ‘élevé’ s’il y a plus de 1000 exemplaires
# dans cette rubrique, ‘faible’ sinon. (réutiliser la requête 19). 

select cl.librub rubrique, sum(st.qtestock) nb_exemplaire ,
case
	when sum(st.qtestock)>1000 then 'eleve'
    else 'faible'
end as Etat
from classification cl
join ouvrage o on o.numrub = cl.numrub
join stocker st on st.numouvr = o.numouvr
join depot dp on dp.numdep = st.numdep
where dp.villedep = 'grenoble'
group by rubrique;


case
	when condition then result1
    when condition then result2
    when condition then result3
    when condition then result4
    when condition then resultn
    else
		result_else
end

case variable
	when value1 then result1
    when value2 then result2
    when value3 then result3
    when value4 then result4
    when value_n then result_n
    else
		result_else
end



#21.	Liste des auteurs (nom + prénom) ayant écrit des livres sur 
#le thème (LIBRUB) des « finances publiques » ou bien ayant écrit des
#livres coûtant au moins 30 € au 1/10/2002 - réutiliser les requêtes 11 et 12. 
(select * from R12)
union #all
(select * from R11);

#22.	Liste des écrivains (nom et prénom) n’ayant écrit aucun des 
#ouvrages présents dans la base. 

select * from ecrivain where numecr not in(select numecr from ecrire);

select e.* from ecrivain e left join ecrire ec on e.numecr = ec.numecr
where ec.numecr is null;


#23.	Mettre à 0 le stock de l’ouvrage n°6 dans le dépôt Lyon2. 
update stocker
set qtestock=0
where numouvr = 6
and numdep in (select numdep from depot where nomdep = 'lyon2');


#24.	Supprimer tous les ouvrages de chez Vuibert de la table OUVRAGE.
#si on a pas de suppression on cascade sur les relations entre ouvrage, ecrire, stocker et tarfier
#il faut executer les trois premières requetes avant de supprimer les ouvrages.

delete from stocker where numouvr in (select numouvr from ouvrage where nomed = 'vuibert');
delete from ecrire where numouvr in (select numouvr from ouvrage where nomed = 'vuibert');
delete from tarifer where numouvr in (select numouvr from ouvrage where nomed = 'vuibert');

delete from ouvrage where numed = 'vuidert';


#25.	créer une table contenant les éditeurs situés à Paris et leur n° de tel. 

#sur mysql
create table EditeurDeParis 
		select nomed, teled 
        from editeur 
        where villeed = 'paris';

select * from EditeurDeParis;
#sur autre SGBDR
select nomed, teled into EditeursDeParis  from editeur where villeed = 'paris';

