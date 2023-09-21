drop database location_203;
#create database location_203 collate utf8mb4_bin;
create database location_203 collate utf8mb4_general_ci;
use location_203;

create table bien(
	reference varchar(20) primary key,
    superficie float not null,
    nb_pieces smallint ,
    loyer float not null,
    id_client bigint not null,
    id_type bigint not null,
    id_quartier bigint not null
    ) engine=innodb;    
    
  
    
create table contrat (
	date_creation datetime not null,
	date_entree datetime,    
	date_sortie datetime,
    charges float,
    loyer float,
    reference varchar(20) not null,
    id_client bigint not null,
    constraint pk_contrat primary key (date_creation, reference, id_client)

    ) engine=innodb;
    
    

create table client(
	id bigint auto_increment primary key,
    nom varchar (50) not null, 
    prenom varchar (50), 
	telephone varchar (20) , 
	adresse varchar (150)   
    ) engine=innodb;
    
create table quartier(
	id bigint auto_increment primary key,
    nom varchar (50) not null, 
    id_ville bigint not null
    ) engine=innodb;
        
        
create table ville(
	id bigint auto_increment primary key,
	nom varchar (50) not null 
    ) engine=innodb;
        
        
create table type(
	id bigint auto_increment primary key,
    nom varchar (50) not null
    ) engine=innodb;
    
    
    
alter table bien add constraint fk_bien_type foreign key(id_type) references type(id);    
alter table bien add constraint fk_bien_client foreign key(id_client) references client(id);
alter table bien add constraint fk_bien_quartier foreign key(id_quartier) references quartier(id);


alter table contrat add constraint fk_contrat_bien foreign key(reference) references bien(reference);    
alter table contrat add constraint fk_contrat_client foreign key(id_client) references client(id); 


alter table quartier add constraint fk_quartier_ville foreign key(id_ville) references ville(id);    
   
insert into type(id,nom) values (1,'appartement');
insert into type  values (2,'villa');
insert into type (nom)  values ('garage');
insert into type  values 
	(4,'maison'),
    (5,'duplex'),
    (6,'terrain');
insert into type(id,nom) value (7,'studio');    
	



insert into ville values 
	(1,'tetouan'),
    (2,'martil'),
    (3,'m''diq');

insert into client values 
 (1,'marchoud','ali','0121548754','av 2 mars imm3'),
 (2,'benhsan','youssef','06215487','av ibn sina imm2'),
 (3,'mahmoudi','karima','0587541245','av mokawama imm5'),
 (4,'mansouri','souad','0587547845','av haj mohamed imm1'),
 (5,'krimou','farid','0654214512','av  ibn toumart imm4'),
 (6,'kamali','yassine','0545781545','av  sebou imm 1');
 

insert into quartier values 
(1,'touilaa',1),
(2,'saniat rmel',1),
(3,'chomoue',2),
(4,'miramar',2),
(5,'zaouia',3);

insert into bien values
('L21',80,3,1500,1,1,1),
('L45',180,5,3500,2,2,2),
('L23',30,1,800,1,3,3),
('L91',100,3,2000,3,1,4),
('L214',90,4,1800,2,2,2),
('L1',40,2,1000,1,3,3);


insert into contrat values
('2023-08-23',null,null,100,1500,'L23',4),
('2023-08-24','2023-09-01',null,150,1700,'L214',4),
('2023-08-25',null,null,50,1000,'L1',4),
('2023-08-26','2023-09-15','2023-09-24',100,1000,'L23',4),
('2023-08-27','2023-08-12',null,100,1500,'L91',4);

create index idx_nom_ville on ville(nom asc);

create index idx_nom_quartier on quartier(nom asc);

alter table ville add constraint unq_nom unique (nom);

select  * from ville;
select id, nom from ville;
use blog;
select * from location_203.ville;
use location_203;

select id, nom from ville as v;
select id, nom from ville v;
select id id_ville, nom nom_ville from ville v;
select id id ville, nom nom ville from ville v;
select id 'id ville', nom 'nom ville' from ville v;

select * 
from ville v
where nom ='tetouan';

select * 
from ville v
where nom ='tétouan';
select * 
from ville v
where nom ='Tetouan';

select * 
from ville v
where nom like'tet%';

select * from bien
where reference like 'L__';
select * from quartier

select q.id,q.nom,v.nom from quartier q
join ville v on q.id_ville = v.id
where v.nom like 'tet%';

select * 
from quartier 
where id_ville in 
		(select id 
        from ville 
        where nom 
        like 'tet%');


select * 
from quartier 
where id_ville in 
		(1,2);
        
        
select * 
from quartier q , ville v
where q.id_ville= v.id

and v.nom like 'tet%'

select * from quartier

insert into quartier values (6,'zaouia',3)






