#Exercice 1 :

#Soit le modèle relationnel suivant relatif à la gestion des notes annuelles d'une promotion d’étudiants :
#ETUDIANT (NEtudiant, Nom, Prénom)
#MATIERE (CodeMat, LibelleMat, CoeffMat)
#EVALUER (NEtudiant, CodeMat, DateExamen, Note)
#Questions :
#1.	Créer la base de données avec le nom « Ecole »;
create database Ecole_202 collate utf8mb4_general_ci;
use Ecole_202;



#2.	Créer les tables avec les clés primaires sans spécifier les clés étrangères ;

create table ETUDIANT (
	NEtudiant int auto_increment primary key, 
    Nom varchar(50),
    Prénom varchar(50));
    
create table MATIERE (
	CodeMat int auto_increment primary key, 
    LibelleMat varchar(50), 
    CoeffMat int);
    
create table EVALUER (
	NEtudiant int not null, 
    CodeMat int not null, 
    DateExamen datetime, 
    Note float,
    constraint pk_evaluer primary key (NEtudiant,CodeMat));
    



#3.	Ajouter les clés étrangères à la table EVALUER ; 
alter table evaluer
add constraint fk_evaluer_etudiant foreign key (NEtudiant)
references Etudiant(NEtudiant);

alter table evaluer
add constraint fk_evaluer_matiere foreign key (CodeMat)
references matiere(CodeMat);

#4.	Ajouter la colonne Groupe dans la table ETUDIANT: Groupe NOT NULL ; 
alter table etudiant
add column groupe varchar(45) not null;
#5.	Ajouter la contrainte unique pour l’attribut (LibelleMat) ; 
alter table matiere add constraint unique(LibelleMat);
#6.	Ajouter une colonne Age à la table ETUDIANT, avec la contrainte (age >16) ; 
alter table ETUDIANT
add column age int check(age > 16); 
#7.	Ajouter une contrainte sur la note pour qu’elle soit dans l’intervalle (0-20) ; 
alter table EVALUER ADD constraint NOTE_CHK CHECK (NOTE BETWEEN 0 AND 20);
#8.	Remplir les tables par les données ;





#Exercice 2 :

#Soit le schéma relationnel suivant :

#  AVION ( NumAv int not null, 
		TypeAv varchar(50),
		CapAv int,
		VilleAv  varchar(50));
#  PILOTE (NumPil, NomPil,titre, VillePil) 
#  VOL (NumVol, VilleD, VilleA, DateD, DateA, NumPil#,NumAv#)

#Travail à réaliser :

#  À l'aide de script SQL: 

#1.	Créer la base de données sans préciser les contraintes de clés.
drop database vols_202;
create database vols_202 collate utf8mb4_general_ci;
use vols_202;

create table AVION ( NumAv int not null, 
		TypeAv varchar(50),
		CapAv int,
		VilleAv  varchar(50));
        
create table   PILOTE (NumPil int not null, 
		NomPil varchar(50),
        titre varchar(50), 
        VillePil varchar(50)) ;
        
create table   VOL (NumVol int not null, 
		VilleD varchar(50), 
        VilleA varchar(50), 
        DateD datetime, 
        DateA datetime, 
        NumPil int not null,
        NumAv int not null);

#2.	Ajouter les contraintes de clés aux tables de la base.
alter table Avion modify column numav int auto_increment primary key ;
alter table PILOTE modify column numpil int auto_increment primary key;
alter table VOL  modify column numvol int auto_increment primary key;

alter table VOL add constraint FK_vol_pilote foreign key(NumPil) references Pilote(NumPil);
alter table VOL add constraint FK_vol_avion foreign key(NumAv) references Avion(NumAv);


#3.	Ajouter des contraintes qui correspondent aux règles de gestion suivantes

#	Le titre de courtoisie doit appartenir à la liste de constantes suivantes :
#M, Melle, Mme.

alter table pilote add constraint chk_titre check (titre in ('m','melle','mme') ); 


#	Les valeurs noms, ville doivent être renseignées.

alter table avion
modify VilleAv  varchar(50) not null;

alter table avion add constraint chk_villeAv check(villeav is not null);

alter table pilote
modify NomPil  varchar(50) not null,
modify VillePil  varchar(50) not null;

alter table pilote add constraint chk_nom check(nompil is not null);
alter table pilote add constraint chk_villePil check(VillePil is not null);

alter table vol
modify VilleD  varchar(50) not null,
modify VilleA  varchar(50) not null;

alter table vol add constraint chk_villeD check(villeD is not null);
alter table vol add constraint chk_villeA check(villeA is not null);

#	La capacité d’un avion doit être entre 50 et 100.

alter table Avion add constraint chk_capacite check(CapAv between 50 and 100);

#4.	Ajouter la  colonne ‘date de naissance’ du pilote : DateN 
alter table pilote add column dateN date;
#5.	Ajouter une contrainte qui vérifie que la date de départ d’un vol est toujours inférieure ou égale à sa date d’arrivée.
alter table vol
add constraint ch_vol check(dated<=datea);
#6.	Supprimer la colonne VilleAv
alter table AVION
drop column VilleAv;
#7.	Supprimer la table PILOTE
alter table vol drop constraint FK_vol_pilote;
drop table pilote;
#8.	Remplir la base de données pour vérifier les contraintes appliquées.

