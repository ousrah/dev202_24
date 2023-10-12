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

# Equation premier degès
# Ax+B=0

#rappel mathématique
#Si A=0 et B=0   --  x= toute valeur de R
#Si A=0 et B!=0   --  x= Ensemble vide
#Si A!=0          -- x = -B/A

# Equation deuxième degès
# Ax²+Bx+C=0

#rappel mathématique
#Si A=0 et B=0 et C=0   -- x= toute valeur de R
#Si A=0 et B=0 et C!=0   -- x = ensemble vide
#Si A=0 et B!=0    -- x = -C/B
#Si A!=0        
#     delta = b²-4AC
#     Si delta <0    impossible dans R
#     Si delta = 0  x1=x2=-B/2A
#     Si delta >0  x1=-B-racine(delta)/2A   x2=-B+racine(delta)/2A
     
     
#Exercice participation au prix de repas
#Un patron d'usine dicide de participer aux prix de repas de ces ouvrier
#il instaure les règles suivante
#le taux de participation est de 30%
#si le salaire de l'ouvrier est inférieur à 3000 dh la participation est marjorée de 10%
#si l'ouvrier est mariée la participation est augmentée de 5%
# et pour chaque enfant on va ajouter 5%
# le taux de participation ne peut jamais dépasser 60%
#ecrire une fonction mysql qui accepte les paramètres necessaires et qui affiche le montant de la participation










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
