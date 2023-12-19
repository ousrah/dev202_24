drop database if exists cc2v3;
create database cc2v3 collate utf8mb4_general_ci;
use cc2v3;

create table universite(
code int auto_increment primary key,
 nom varchar(50),
 adresse varchar(100),
 ville varchar(50),
 codp varchar(5));
 

create table etablissement(
code int auto_increment primary key,
 nom varchar(50),
 adresse varchar(100),
 ville varchar(50),
 codp varchar(5),
 code_universite int,
 constraint fk_etab_univ foreign key (code_universite) references universite(code));
 
create table departement(
code int auto_increment primary key,
 nom varchar(50),
 code_etablissement int,
 constraint fk_depert_etab foreign key (code_etablissement) references etablissement(code));

create table professeur(
id int auto_increment primary key,
 nom varchar(50),
 prenom varchar(50),
 cin varchar(50),
 adresse varchar(100),
 ville varchar(50),
 codp varchar(5),
 datnais date,
 lieunaiss varchar(50),
 email varchar(50),
 siteweb varchar(50),
 tel varchar(20),
 fax varchar(20));


create table filiere(
code int auto_increment primary key,
 intitule varchar(50),
 code_etablissement int,
 id_professeur int,
 constraint fk_fil_etab foreign key (code_etablissement) references etablissement(code),
constraint fk_fil_prof foreign key (id_professeur) references professeur(id));


create table module(
code int auto_increment primary key,
 intitule varchar(50),
 volh int,
 dureap int,
 code_departement int,
 id_professeur int,
 constraint fk_mod_dep foreign key (code_departement) references departement(code),
constraint fk_mod_prof foreign key (id_professeur) references professeur(id));

create table comprend(
niv int,
typm varchar(50),
code_filiere int,
code_module int,
constraint fk_comp_fil foreign key (code_filiere) references filiere(code),
constraint fk_comp_mod foreign key (code_module) references module(code));



insert into universite(code,nom) values (null,'abdel malek essaadi');
insert into universite(code,nom) values (null,'el kadi ayad');
insert into universite(code,nom) values (null,'mohamed V');


insert into etablissement (code,nom,code_universite) values (null,'fac sc',1),(null,'fac lt',1),(null,'fac eco',1);

insert into professeur (id,nom) values (1,'prof1'),(2,'prof2'),(3,'prof3');

insert into departement (code,nom,code_etablissement) values (1,'informatique',1),(2,'securite',1),(3,'ia',1);

insert into filiere(code,intitule,code_etablissement,id_professeur) values (1,'developpement',1,1),(2,'reseau',1,2),(3,'ia',1,3);

insert into module(code,intitule,code_departement,id_professeur) values (1,'bases de données',1,1),(2,'système reseaux',2,2),(3,'reseaux neuronales',3,3);

insert into comprend (niv, typm,code_filiere, code_module) values (1,'pratique',1,1),(2,'pratique',2,2),(3,'theorique',3,3);