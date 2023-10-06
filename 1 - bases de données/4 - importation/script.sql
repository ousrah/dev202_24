#create database importation_202B collate utf8mb4_general_ci;
#use importation_202B;

#exportation des villes
create table ville
	select distinct ville as nom from tableau;

#ajout de la clé primaire à la table ville
alter table ville add column id int auto_increment primary key;

#exportation des matières
create table matiere
	select distinct Matière as nom from tableau;
alter table matiere add column id int auto_increment primary key;

#exportation des classes
create table classe
	select distinct classe as nom from tableau;
alter table classe add column id int auto_increment primary key;

#exportation des appréciations
create table appreciation
	select distinct appréciation as nom from tableau;
alter table appreciation add column id int auto_increment primary key;


#correction des dates de naissances
update  tableau set `Date Naissance`  = str_to_date(`Date Naissance`,'%d/%m/%Y');
alter table tableau modify `Date Naissance` date;

#exportation des stagiaires
create table stagiaire
select distinct `Nom stagiaire` nom,`prénom Stagiaire` prenom,`Date Naissance` daten,v.id as id_ville,c.id as id_classe
from tableau t join ville v on t.ville = v.nom
			   join classe c on t.classe = c.nom;
               
alter table stagiaire add column id int auto_increment primary key;  
alter table stagiaire add constraint fk_stagiaire_ville foreign key (id_ville) references ville(id);
alter table stagiaire add constraint fk_stagiaire_classe foreign key (id_classe) references classe(id);
             
#correction des notes             
update tableau set  note = replace(note,",",".");
alter table tableau modify note float;

#exportation des notes
create table examen
select distinct note,s.id id_stagiaire,m.id id_matiere,a.id id_appreciation
from tableau t
join stagiaire s on t.`Nom stagiaire` = s.nom and t.`prénom Stagiaire` = s.prenom
join matiere m on t.Matière=m.nom
join appreciation a on t.Appréciation=a.nom;

alter table examen add constraint pk_examen primary key (id_stagiaire, id_matiere);
alter table examen add constraint fk_examen_stagiaire foreign key (id_stagiaire) references stagiaire(id);
alter table examen add constraint fk_examen_matiere foreign key (id_matiere) references matiere(id);
alter table examen add constraint fk_examen_appreciation foreign key (id_appreciation) references appreciation(id);

#suppression des données initiaux
drop table tableau;