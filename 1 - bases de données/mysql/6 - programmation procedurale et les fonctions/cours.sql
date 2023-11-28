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
SELECT HELLO() AS salutation;

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
/*
 Equation premier degès
 Ax+B=0


rappel mathématique
Si A=0 et B=0   --  x= toute valeur de R
Si A=0 et B!=0   --  x= Ensemble vide
Si A!=0          -- x = -B/A
*/


drop function if exists equation1;
delimiter $$
create function equation1(a float,b float)
returns varchar(20)
deterministic
begin
declare result varchar(50);
	if a<>0 then
		set result = -b/a;
	else 
		if b=0 then 
			set result = "toutes valeurs dans R";
		else
			set result = "impossible";
		end if;
    end if;
    return result;
end $$
delimiter ;



select equation(0,0); #2  2
select equation(0,5); #4  2
select equation(7,0); #5  1
select equation(7,2); #5  1




/* Equation deuxième degès
 Ax²+Bx+C=0

rappel mathématique
Si A=0 et B=0 et C=0   -- x= toute valeur de R
Si A=0 et B=0 et C!=0   -- x = ensemble vide
Si A=0 et B!=0    -- x = -C/B
Si A!=0        
     delta = b²-4AC
     Si delta <0    impossible dans R
     Si delta = 0  x1=x2=-B/2A
     Si delta >0  x1=-B-racine(delta)/2A   x2=-B+racine(delta)/2A
 */    
     

drop function if exists equation2;
delimiter $$
create function equation2(a float,b float,c float)
returns varchar(20)
deterministic
begin
declare result varchar(50);
declare delta float;
declare x1,x2 float;

	if a<>0 then
		set delta = (b*b)-(4*a*c);
		if delta > 0 then
			set x1 = (-b-sqrt(delta))/(2*a);
			set x2 = (-b+sqrt(delta))/(2*a);
			set result = concat("x1=",round(x1,2)," x2=", round(x2,2));
		elseif delta = 0 then
			set x1 = -b/(2*a);
			set result = concat("x1=x2=",round(x1,2));
		else
			set result = "impossible dans R";
		end if;
	else 
		if b<>0 then 
			set x1 = -c/b;
            set result = concat("x",round(x1,2));
		else
			if c=0 then
				set result = "Toute valeur de R";
			else
				set result = "ensemble vide";
			end if;
        end if;
    end if;
    return result;
end $$
delimiter ;     
     
select equation2(2,4,2);     
select equation2(2,6,2);    
select equation2(2,3,2);      
select equation2(0,4,2);       
select equation2(0,0,2);   
select equation2(0,0,0);   
     
     
/*Exercice participation au prix de repas

Un patron d'usine dicide de participer aux prix de repas de ces ouvrier
il instaure les règles suivante
le taux de participation est de 30%
si le salaire de l'ouvrier est inférieur à 3000 dh la participation est marjorée de 10%
si l'ouvrier est mariée la participation est augmentée de 5%
 et pour chaque enfant on va ajouter 5%
 le taux de participation ne peut jamais dépasser 60%
ecrire une fonction mysql qui accepte les paramètres necessaires et qui affiche le montant de la participation
*/
drop function if exists participation;
delimiter $$
create function participation(salaire float,f boolean,enfants int,repas float)
returns varchar(20)
deterministic
begin
	declare taux float default 0.30;
    declare participe float;
	if salaire < 3000 then
		set taux = taux + 0.10;
	end if;
    if f then 
		set taux = taux + 0.05;
	end if;
	set taux = taux + 0.05* enfants;

    if taux > 0.60 then
		set taux = 0.60;
	end if;
    set participe = repas * taux;
    return round(participe,2);
end$$
delimiter ;
select participation(3500,false,0,100);
select participation(3500,false,2,100);
select participation(3500,true,0,100);
select participation(2000,false,0,100);
select participation(2000,true,0,100);
select participation(2000,true,2,100);
select participation(2000,true,10,100);


#les boucles


drop function if exists somme;
delimiter $$
create function somme(n int)
returns int
deterministic
begin
	declare s int default 0;
    declare i int default 1;
    while i<=n do
		set s = s+i;
        set i=i+1;
    end while;
    return s;
end $$
delimiter ;

select somme(5);


drop function if exists somme;
delimiter $$
create function somme(n int)
returns int
deterministic
begin
	declare s int default 0;
    declare i int default 0;
    repeat
		set s = s+i;
        set i=i+1;
    until i>n end repeat;
    return s;
end $$
delimiter ;




drop function if exists somme;
delimiter $$
create function somme(n int)
returns int
deterministic
begin
	declare s int default 0;
    declare i int default 0;
    boucle1: loop
		set s = s+i;
        set i=i+1;
        if i>n then
			leave boucle1;
        end if;
    end loop boucle1;
    return s;
end $$
delimiter ;



select somme(5);
select somme(10);
select somme(0);
select somme(1);



/*
Ecrire une fonction sommePaire qui permet de calculer la somme des n premier entiers paires 
sans untilisation d'une incrementation par deux (utilisez le modulo)
*/

drop function if exists sommePair;
delimiter $$
create function sommePair(n int)
returns int
deterministic

begin
	declare s int default 0;
    declare i int default 0;
    while (i<=n) do
		if i%2=0 then
			set s = s + i;
		end if;
        set i = i + 1;
	end while;
    return s;
end $$
delimiter ;
select sommePair(12);


/*
ecrire une fonction qui permet de calculer le factoriel d'un entier
Exemple 5!=5*4*3*2
        2! = 2
        1!=1
        0!=1;
  */      
use librairie_201;
select * from ecrivain;

drop function if exists Factoriel;
delimiter $$
create function Factoriel(n int)
returns int
deterministic

begin
	declare res int default 1;
    declare i int default 1;
 		repeat 
			set  res = res * i;
			set i = i + 1;
		until i > n end repeat;
    return res;
end $$
delimiter ;

select Factoriel(0);
select Factoriel(1);
select Factoriel(5);



drop function if exists MoyenneParEcrivain;
delimiter $$
create function MoyenneParEcrivain(nom varchar(50), prenom varchar(50))
returns float
reads sql data
begin
	declare moyenne float;
  select avg(prixvente) into moyenne from ecrivain ec
		join ecrire e on ec.numecr = e.numecr
		join tarifer t on e.numouvr = t.numouvr
		where nomecr = nom and prenomecr = prenom;
	return moyenne;

end $$
delimiter ;


drop function if exists MoyenneParEcrivain;
delimiter $$
create function MoyenneParEcrivain(nom varchar(50), prenom varchar(50))
returns float
reads sql data
begin
	declare moyenne float;
   set moyenne =  (select avg(prixvente) from ecrivain ec
		join ecrire e on ec.numecr = e.numecr
		join tarifer t on e.numouvr = t.numouvr
		where nomecr = nom and prenomecr = prenom);
	return moyenne;

end $$
delimiter ;


select MoyenneParEcrivain('Archer','S.H.');


#les fonctions

#les procedures
#les déclencheurs - les triggers
#les transactions
#les tables temporaires
 #La gestion des erreurs
#les curseurs
#la sécurité
#la sauvegarde et la restauration
