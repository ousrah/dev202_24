/*________________________________________
Exercice 1 :
On considère la table suivante :
Produit (NumProduit, libelle, PU, stock)
*/


drop database if exists produits_202;

create database produits_202 collate utf8mb4_general_ci;
use produits_202;

create table Produit(
	numProduit int auto_increment primary key,
	libelle varchar(50) ,
	PU float ,
    stock int);


insert into produit values (1,'table',350,100),
							(2,'chaise',100,10),
                            (3,'armoire',2350,10),
                            (4,'pc',3500,20),
                            (5,'clavier',150,200),
                            (6,'souris',50,200),
                            (7,'ecran',2350,70),
                            (8,'scanner',1350,5),
                            (9,'imprimante',950,5);
                            
select * from produit;
#1.	Ecrire une PS qui affiche tous les produits ;
drop procedure p1
delimiter $$
create procedure p1()
begin
	select * from produit;
end $$
delimiter ;
call p1();

#2.	Ecrire une procédure stockée qui affiche les libellés des produits dont le stock 
#est inférieur à 10 ;
drop procedure p2
delimiter $$
create procedure p2()
begin
select libelle from Produit where stock<10;
end $$
delimiter ;
call p2();
#3.	Ecrire une PS qui admet en paramètre un numéro de produit et affiche 
#un message contenant le libellé, le prix et la quantité en stock équivalents, 
#si l’utilisateur passe une valeur lors de l’exécution de la procédure ;
drop procedure if exists p3;
delimiter $$
create procedure p3(in nprd int)
begin
	#declare libprd varchar(50);
    #declare prixprd float;
    #declare stockprd int;
    if nprd is null then 
		select"entrer un nbr valide" as message;
	else
	#	select libelle,pu,stock into libprd,prixprd,stockprd 
	#		from produit 
    #        where numproduit=nprd;
    #    select concat('produit:',libelle,"  prix",pu,"  stock",stock );
		select concat('produit:',libelle,"  prix:",pu,"  stock:",stock ) as message
        from produit 
        where numproduit=nprd;
    end if ;  

end $$
delimiter ;
call p3(null);
call p3(2);



#4.	Ecrire une PS qui permet de supprimer un produit en passant son numéro 
#comme paramètre ;
drop procedure if exists q4
delimiter $$
create procedure q4( in num int)
begin
     delete from produit where numProduit = num;
end $$
delimiter ;
call q4(3);
select * from produit;



#Exercice 2 :
#Ecrire une PS qui permet de mettre à jour le stock après une opération de vente de produits, 
#la PS admet en paramètre le numéro d’article à vendre et la quantité à vendre puis
# retourne un message suivant les cas :
#a.	Opération impossible : si la quantité est supérieure au stock de l’article ;
#b.	Besoin de réapprovisionnement si stock-quantité < 10
#c.	Opération effectuée  avec succès, la nouvelle valeur du stock est (afficher la nouvelle valeur) ;
drop procedure if exists sell_product;
delimiter $$
create procedure sell_product(in id int, in qte int, out msg varchar(50))
begin
	declare stoq int;
    select stock into stoq from produit where numProduit = id;
    if qte > stoq then
		set msg = "operation impossible";
      
	else
		update produit
			set stock = stoq-qte
			where numProduit = id;
		if stoq-qte<10 then
			set msg = "besion de réapprovisionement";
		else 
			set msg = concat("Opération effectué avec succés: ", stoq-qte);
		end if ;
	end if;
end $$
delimiter ;

select * from produit;
call sell_product(1,3,@msg);
select @msg;
call sell_product(1,100,@msg);
select @msg;
call sell_product(1,88,@msg);
select @msg;

#Exercice 3 :
#Ecrire une PS qui retourne le prix moyen des produits (utiliser un paramètre OUTPUT) ;
# Exécuter la PS ;
drop procedure Ex3;
delimiter $$
create procedure Ex3(out moyenne  float)
begin
	select avg(PU) into moyenne  from produit ;
end$$
delimiter ;

call moyenneProduit(@moyenne);
select @moyenne;

#Exercice 4 :
#Créer une procédure stockée qui accepte comme paramètre un entier et retourne 
#le factoriel de ce nombre.

drop procedure if exists exercice4;
delimiter $$
create procedure exercice4(  in n int, out f bigint  )
	begin
	declare i int default 1;
	set f=1;
	while (i<=n)do
		set f=f*i;
		set i=i+1;
	end while;
	end $$
delimiter ;
call exercice4(5,@f);
select @f;

#methode recursive
drop procedure if exists ex04;
delimiter //
create procedure ex04(in n int , out result bigint )
begin
	declare res bigint;
	if n = 0 or n = 1 then 
		SET RESULT = 1;
	else
		call ex04(n-1 , res);
		set result = n * res;
	end if ;
end //
delimiter ;
set max_sp_recursion_depth = 10;
call ex04(0 , @result);
select @result;





#Exercice 5 :
#1.	Créer une procédure stockée qui accepte les paramètres suivants : 
#a.	 2 paramètres de type entier  
#b.	 1 paramètre de type caractère.
#c.	1 paramètre output de type entier

drop procedure if exists ex5; 
delimiter $$
create procedure ex5( in a int ,in b int,in c varchar(2), out res varchar(250))
begin 
   case c
       when "+" then 
          set res= a+b ;
	   when "-" then 
          set res= a-b ;
	   when "*" then 
          set res= a*b ;
	   when "/" then 
			if b !=0 then
				set res= a/b ;
			else
				set res ="impossible de diviser par 0";
			end if;
	   when "%" then 
          set res= a%b ;
	   else 
          set res="l'operation est invalide";
	end case ;
end$$
delimiter ;
call ex5(18,3,"*",@res);select @res;
call ex5(18,3,"+",@res);select @res;
call ex5(18,3,"-",@res);select @res;
call ex5(18,3,"/",@res);select @res;
call ex5(18,0,"/",@res);select @res;
call ex5(18,3,"%",@res);select @res;
call ex5(18,3,"l",@res);select @res;
	


#La procédure doit enregistrer le résultat de calcul entre les deux nombres selon l’opérateur passé dans le troisième paramètre (+,-,%,/,*). 
#Exercice 6 :
#Soit la base de données suivante :
#Recettes (NumRec, NomRec, MethodePreparation, TempsPreparation)
#Ingrédients (NumIng, NomIng, PUIng, UniteMesureIng, NumFou)
#Composition_Recette (NumRec, NumIng, QteUtilisee)
#Fournisseur (NumFou, RSFou, AdrFou)




drop database if exists cuisine_202;
create database cuisine_202;
use cuisine_202;
create table Recettes (
NumRec int auto_increment primary key, 
NomRec varchar(50), 
MethodePreparation varchar(60), 
TempsPreparation int
);
create table Fournisseur (
NumFou int auto_increment primary key, 
RSFou varchar(50), 
AdrFou varchar(100)
);
create table Ingredients (
NumIng int auto_increment primary key,
NomIng varchar(50), 
PUIng float, 
UniteMesureIng varchar(20), 
NumFou int,
   constraint  fkIngredientsFournisseur foreign key (NumFou) references Fournisseur(NumFou)
);
create table Composition_Recette (
NumRec int not null,
constraint  fkCompo_RecetteRecette foreign key (NumRec) references Recettes(NumRec), 
NumIng int not null ,
  constraint  fkCompo_RecetteIngredients foreign key (NumIng) references Ingredients(NumIng),
QteUtilisee int,
constraint  pkRecetteIngredients primary key (NumIng,NumRec)
);

insert into Recettes  values(1,'gateau','melangeprotides' ,30),
							(2,'pizza ','melangeglucides' ,15),
							(3,'couscous','melangelipides' ,45);
                            
insert into Fournisseur  values (1,'meditel','fes'),
								(2,'maroc telecom','casa'),
								(3,'inwi','taza');
                                
insert into Ingredients values(1,'Tomate', 100,'cl',1),
								(2,'ail', 200,'gr',2),
								(3,'oignon', 300,'verre',3);
							
insert into Composition_Recette values (2,1,10);
insert into Composition_Recette values (2,2,1);



#Créer les procédures stockées suivantes :
#PS1 : Qui affiche la liste des ingrédients avec pour chaque ingrédient le numéro, 
#le nom et la raison sociale du fournisseur.



drop procedure if exists ps1;
delimiter //
create procedure ps1()
begin
	select i.NumIng, i.NomIng, f.RSFou from Ingredients i
    join Fournisseur f on i.NumFou = f.NumFou; 
end //
delimiter ;
call ps1();


#PS2 : Qui affiche pour chaque recette le nombre d'ingrédients et le montant 
#cette recette
use cuisine_202;
DROP PROCEDURE IF EXISTS ps2;
delimiter $$
CREATE PROCEDURE ps2()
BEGIN
  SELECT r.NumRec, r.NomRec, COUNT(c.NumIng) Nombre_Ingredients, IFNULL(ROUND(SUM(c.QteUtilisee * i.PUIng), 2), 0) Montant_Recette
  FROM Recettes r
  LEFT JOIN Composition_Recette c ON r.NumRec = c.NumRec
  LEFT JOIN Ingredients i ON c.NumIng = i.NumIng
  GROUP BY r.NumRec;
END$$
delimiter ;
CALL ps2();



#PS3 : Qui affiche la liste des recettes qui se composent de plus de 10 ingrédients avec 
#pour chaque recette le numéro et le nom

drop procedure if exists ps3;
delimiter $$ 
create procedure ps3()
begin
	select r.numrec,r.nomrec
    from Recettes r
    JOIN Composition_Recette c on r.numrec = c.numrec
    group by r.numrec,r.nomrec
    having count(c.NumIng) > 10;
    
end $$
delimiter ;

call ps3();



#PS4 : Qui reçoit un numéro de recette et qui retourne son nom
drop procedure if exists ps4;
delimiter $$
create procedure ps4(in id int, out r varchar(50))
begin
select NomRec into r from recettes r where r.NumRec=id;
end$$
delimiter ;
call ps4(1, @r);
select @r;




#PS5 : Qui reçoit un numéro de recette. Si cette recette a au moins un ingrédient, 
#la procédure retourne son meilleur ingrédient (celui qui a le montant le plus bas) 
#sinon elle ne retourne "Aucun ingrédient associé"

drop procedure if exists ps5;
delimiter $$
create procedure ps5(n int,out msg varchar(100))
begin
	declare nb int;
    select count(*) into nb from composition_recette where numrec = n;
    if nb=0 then
		set msg = "Aucun ingrédient associé";
	else
		select concat("le meilleur ingrédient est ",noming) into msg from ingredients i join composition_recette c on i.numing = c.numing
        where numrec = n
        order by puing asc
        limit 1;
    end if ;
end$$
delimiter ;
select * from ingredients;
call ps5(2,@msg);
select @msg;

#PS6 : Qui reçoit un numéro de recette et qui affiche la liste des ingrédients correspondant à
# cette recette avec pour chaque ingrédient le nom, la quantité utilisée et le montant

drop procedure if exists ex6q6;						
delimiter $$								
create procedure ex6q6(in num int)						
begin										
  select i.NomIng, c.QteUtilisee, ROUND(c.QteUtilisee * i.PUIng, 2) Montant		
  from Composition_Recette c						
  join Ingredients i on c.NumIng = i.NumIng
  where c.NumRec = num;
end$$
delimiter ;
call ex6q6(2);



#PS7 : Qui reçoit un numéro de recette et qui affiche :
#Son nom (Procédure PS_4)
#La liste des ingrédients (procédure PS_6)
#Son meilleur ingrédient (PS_5)




drop procedure if exists ps7;
delimiter $$
	create procedure ps7(n int)
    begin
		call ps4(n, @r);
		select @r;
		call ps5(n,@msg);
		select @msg;
		call ex6q6(n);
	end $$
delimiter ;
call ps7(1);

#PS8 : Qui reçoit un numéro de fournisseur vérifie si ce fournisseur existe. 
#Si ce n'est pas le cas afficher le message 'Aucun fournisseur ne porte ce numéro' Sinon vérifier,
#s'il existe des ingrédients fournis par ce fournisseur si c'est le cas afficher la liste
#des ingrédients associés (numéro et nom) Sinon afficher un message 'Ce fournisseur n'a aucun
#ingrédient associé. Il sera supprimé' et supprimer ce fournisseur

drop procedure if exists ps8;
delimiter $$
create procedure ps8(in numf int)
begin
	if numf in (select NumFou from Fournisseur) then
		if numf in (select NumFou from Ingredients) then 
			select NumIng,NomIng from ingredients where NumFou=numf;
		else 
			select "Ce fournisseur n'a aucun ingrédient associé. Il sera supprimé" Advertissement;
			delete from fournisseur where NumFou = numf;
		end if;
	else 
		select 'Aucun fournisseur ne porte ce numéro' Advertissement;
	end if;
end $$
delimiter ;

call ps8(4);
insert into fournisseur values (null,'Test','Test');
select * from fournisseur;


#PS9 : Qui affiche pour chaque recette :
#Un message sous la forme : "Recette : (Nom de la recette), temps de préparation : (Temps)
#La liste des ingrédients avec pour chaque ingrédient le nom et la quantité
#Un message sous la forme : Sa méthode de préparation est : (Méthode)
#Si le prix de reviens pour la recette est inférieur à 50 DH afficher le message
#'Prix intéressant'

drop procedure if exists ps9;
delimiter &
create procedure ps9()
begin
	declare nomR varchar(80);
    declare numR int;
    declare tempsR time;
    declare methR text;
    declare price float;
    declare flag boolean default false;
    declare c1 cursor for select NumRec, NomRec, MethodePreparation, TempsPreparation from Recettes;
	declare continue handler for not found set flag = true;
	open c1;
		b1: loop
			fetch c1 into numR, nomR, methR, tempsR;
			if flag then
				leave b1;
			end if;
            select concat("-Recette : ", nomR, " temps de preparation: ", tempsR) as recette ;
            select cr.qteutilisee, i.nomIng from composition_recette cr join ingredients i on cr.numIng = i.numing where numrec = numR;
            select concat("cette recette se prepare comme ça: ", methR) as methode;
            select sum(cr.qteutilisee * i.puIng) into price from composition_recette cr join ingredients i on cr.numIng = i.numing where numrec = numR;
            if price < 50 then
				select ("prix interessant");
            end if;
        end loop b1;
    close c1;
end &
delimiter ;

call ps9();



