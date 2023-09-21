select ceiling(rand()*24);

#1.	La liste des biens de type ‘villa’
#methode 1
select * from bien b
	JOIN type t ON b.id_type = t.id
    where t.nom = 'villa';
    
#methode 2
select * 
from bien 
where id_type in (
	select id 
	from type 
	where nom='villa');

#2.	La liste des appartements qui se trouvent à Tétouan
select b.* from bien as b 
	join type as t on b.id_type = t.id 
    join quartier q on b.id_quartier= q.id
    join ville v on q.id_ville= v.id
    where t.nom='appartement' and v.nom='tetouan';
    
   select b.*
   from bien b
   join type t on b.id_type = t.id
   join quartier q on b.id_quartier = q.id
   join ville v on q.id_ville = v.id
   where t.nom = 'appartement'
   and v.nom = 'tetouan';

select * 
from bien
where id_type in (
	select id 
	from type 
    where nom = 'appartement')
and id_quartier in ( 
	select id 
    from quartier 
    where id_ville in (
		select id 
        from ville 
        where nom = 'tetouan')
	);

#3.	La liste des appartements loués par M. Marchoud Ali
select b.*, c.* from bien as b
join contrat as c on b.reference = c.reference
join client as cl on c.id_client=cl.id
join type as t on b.id_type=t.id
where  t.nom='appartement' and cl.nom='Marchoud' and cl.prenom='ali'
order by b.reference asc;

#4.	Le nombre des appartements loués dans le mois en cours

select count(* ) nb
from bien b
join type t on b.id_type = t.id
join contrat c on b.reference = c.reference
where t.nom = 'appartement'
and month(c.date_creation) = month(curdate())
and  year(c.date_creation) = year(curdate())
;


#5.	Les appartements disponibles actuellement à 
#Martil dont le loyer est inférieur à 2000 DH 
#triés du moins chère au plus chère

select *
from bien b
join type t on b.id_type = t.id
join quartier q on b.id_quartier = q.id
join ville v on q.id_ville = v.id
where t.nom = 'appartement'
and v.nom = 'Martil'
and b.loyer <2000
and reference not in (select reference from contrat 
where date_entree<=curdate() 
		and (date_sortie>curdate() or date_sortie is null)
)
order by b.loyer asc;


#6.	La liste des biens qui n’ont jamais été loués
select * from bien where reference not in (
			select distinct reference from contrat);


#7.	La somme des loyers du mois en cours
select sum(loyer) Total from contrat c where 
month(c.date_creation) = month(curdate())
and  year(c.date_creation) = year(curdate());
