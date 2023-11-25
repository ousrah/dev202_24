#La gestion des utilisateurs
#users
create user 'khalid'@'localhost' identified by '123456';
#create user 'khalid'@'192.168.10.52' identified by '123456';
#create user 'khalid'@'%' identified by '123456';
drop user if exists 'khalid'@'localhost';
set password for khalid@localhost = 'abcdefg';

grant all privileges on  vols_202.* to khalid@localhost;

revoke all privileges on vols_202.* from khalid@localhost;

grant select on vols_202.pilote to khalid@localhost;
grant select on vols_202.avion to khalid@localhost;
grant insert, update on vols_202.avion to khalid@localhost;

revoke update on vols_202.avion from khalid@localhost;
show grants for  khalid@localhost;
grant select (villed,villea) on vols_202.vol to khalid@localhost;

flush privileges;

#roles

drop user if exists u1@localhost;
drop user if exists u2@localhost;
drop user if exists u3@localhost;

create user u1@localhost identified by '123456';
create user u2@localhost identified by '123456';
create user u3@localhost identified by '123456';

drop role if exists lecture@localhost;
drop role if exists edition@localhost;

create role lecture@localhost;
create role edition@localhost;

grant select on vols_202.pilote to lecture@localhost;
grant select,insert, update, delete on vols_202.pilote to edition@localhost;


grant lecture@localhost to u1@localhost;
set default role all to u1@localhost;

revoke lecture@localhost from u1@localhost;
grant lecture@localhost to u1@localhost;


show grants for u1@localhost using lecture@localhost;


grant edition@localhost to u1@localhost;


show grants for u1@localhost using  lecture@localhost,edition@localhost;
















