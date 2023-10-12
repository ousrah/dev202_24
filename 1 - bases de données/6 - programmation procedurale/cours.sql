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

drop function if exists comparaison;
delimiter $$
create function comparaison(a int, b int)
returns varchar(50)
deterministic
begin
	declare result varchar(50);
	if a>b then
		set result = concat(a," est plus grande que ",b);
    elseif a=b then
		set result = concat(a," égale à  ",b);
    else
		set result = concat(a," est plus petite que ",b);
    end if;
	return result;
end $$
delimiter ;



drop function if exists comparaison;
delimiter $$
create function comparaison(a int, b int)
returns varchar(50)
deterministic
begin
	declare result varchar(50);
    set result = if(a<b,"petite",if(a=b,"egale","grande"));
	return result;
end $$
delimiter ;

select comparaison (2,3);



drop function if exists jourSemaine;
delimiter $$
create function jourSemaine(j int)
returns varchar(50)
deterministic
begin
	declare result varchar(50);
    set result = case j
    when 1 then "Dimanche"
    when 2 then "Lundi"
    when 3 then "Mardi"
    when 4 then "Mercredi"
    when 5 then "Jeudi"
    when 6 then "Vendredi"
    when 7 then "Samedi"
	else   "erreur"
	end;    
	return result;
end $$
delimiter ;


drop function if exists jourSemaine;
delimiter $$
create function jourSemaine(j int)
returns varchar(50)
deterministic
begin
	declare result varchar(50);
    set result = case 
    when j=1 then "Dimanche"
    when j=2 then "Lundi"
    when j=3 then "Mardi"
    when j=4 then "Mercredi"
    when j=5 then "Jeudi"
    when j=6 then "Vendredi"
    when j=7 then "Samedi"
	else   "erreur"
	end;    
	return result;
end $$
delimiter ;

select jourSemaine(3);


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
