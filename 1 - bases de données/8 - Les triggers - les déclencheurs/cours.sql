drop database if exists gestion_commerciale_202;
create database gestion_commerciale_202 collate utf8mb4_general_ci;
use gestion_commerciale_202;

create table produit(
id_produit int auto_increment primary key,
designation varchar(50),
qteStock int
);
create table commande(
id_commande int auto_increment primary key,
dateCommande datetime);

create table ligne
(id_produit int,
id_commande int,
qte int,
prixVente float,
constraint fk_ligne_produit foreign key (id_produit) references produit(id_produit),
constraint fk_ligne_commande foreign key (id_commande) references commande(id_commande)
);


insert into produit values (1,'table',20),(2,'chaise',60),(3,'armoire',5);

insert into commande values (1,'2023-10-26');

insert into ligne values (1,1,2,500),(1,2,3,400),(2,3,4,200);

update produit set qtestock = qtestock-2 where id_produit=1;

select * from produit;
delete from ligne where id_produit = 1 and id_commande = 1;
update produit set qtestock = qtestock+2 where id_produit=1;




drop trigger if exists t1;
delimiter $$
create trigger t1 after insert on ligne for each row
begin
	update produit set qtestock=qtestock-new.qte where id_produit = new.id_produit;

end$$
delimiter ;


select * from ligne;
insert into ligne values (1,1,2,500);
insert into ligne values (2,1,5,500),(3,1,2,500);
select * from produit;


drop trigger if exists t2 ;
delimiter $$
create trigger t2 after delete on ligne for each rowt1t1
begin
	update produit set qtestock = qtestock+old.qte where id_produit = old.id_produit;

end$$
delimiter ;

delete  from ligne;
select * from produit;


alter table produit add constraint chkStock check (qteStock >=0);
update produit set qtestock = -180 where id_produit=1;

insert into ligne values (1,1,200,500);
select * from ligne;
select * from produit;

drop trigger if exists t3; 
delimiter $$
create trigger t3 after update on ligne for each row
begin
	if old.qte!=new.qte then
		update produit 
		set qtestock = qtestock+old.qte-new.qte 
		where id_produit=old.id_produit;
	end if;
end $$
delimiter ;

insert into ligne values (1,1,2,500);
select * from ligne;
select * from produit;
update ligne set qte = 12 where id_produit = 1 and id_commande = 2;



insert into commande values (2,'2023-10-26');
insert into ligne values (1,2,7,500);


update ligne set prix = 450 where id_produit = 1 and id_commande = 2;

