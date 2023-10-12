#La programmation procédurale sous mysql
#----------------------------------------------

#les blocs d'instructions

select * from ouvrage;

drop function if exists hello;
delimiter $$
create function hello()
returns varchar(30)
deterministic
begin
	return("bonjour");
end $$
delimiter ;

drop function if exists somme;
delimiter $$
create function somme (a int, b int)
returns int
deterministic
begin
	return a+b;
end $$
delimiter ;


select somme(3,5);


#la declaration
#l'affectation

drop function if exists somme;
delimiter $$
create function somme (a int, b int)
returns int
deterministic
begin
	declare result int default 0;
    set result = a+b;
    #select a+b into result;
	return result;
end $$
delimiter ;


select somme(3,5);



#l'affichage
select current_date();
select hello() as salutation;

#les conditions
#les boucles

#les fonctions

#les procedures
#les déclencheurs - les triggers
#les transactions
#les tables temporaires
 #La gestion des erreurs
#les curseurs
#la sécurité
#la sauvegarde et la restauration
