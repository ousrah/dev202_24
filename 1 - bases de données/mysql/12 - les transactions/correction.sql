drop database if exists salles_202;
create database salles_202 collate utf8mb4_general_ci;
use salles_202;

create table Salle (NumSalle int auto_increment primary key, Etage int, NombreChaises int, check(NombreChaises between 20 and 30));
create table Transfert (NumSalleOrigine int, NumSalleDestination int, DateTransfert datetime, NbChaisesTransferees int,
constraint fk_salleorigine foreign key ( NumSalleOrigine) references salle(NumSalle),
constraint fk_salledestination foreign key ( NumSalleDestination) references salle(NumSalle),
constraint pk_transfert primary key (NumSalleOrigine , NumSalleDestination , DateTransfert));

insert into salle values (1,	1,	24),(2,	1,	26),(3,	1,	26),(4,	2,	28);

drop procedure if exists p1;
delimiter &&
create procedure p1(salleO int,salleD int,nbrChais int)
begin
	
	declare dateT datetime default current_timestamp();
    declare exit handler for sqlexception
			begin
				select 'Impossible d’effectuer le transfert des chaises ' as msg;
                rollback;
            end;
	start transaction;
			update Salle set NombreChaises=NombreChaises-nbrChais where NumSalle=salleO;
			update Salle set NombreChaises=NombreChaises+nbrChais where NumSalle=salleD;
            insert into Transfert value (salleO,salleD,dateT,nbrChais);
            select 'operation validee' as msg;
   commit;

end
&&
delimiter ;

call p1(2,3,4);
