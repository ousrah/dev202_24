/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     14/09/2023 13:40:29                          */
/*==============================================================*/


drop table if exists BIEN;

drop table if exists CLIENT;

drop table if exists CONTRAT;

drop table if exists QUARTIER;

drop table if exists TYPE;

drop table if exists VILLE;

/*==============================================================*/
/* Table: TYPE                                                  */
/*==============================================================*/
create table TYPE
(
   ID_TYPE              int not null auto_increment,
   NOM_TYPE             varchar(50),
   primary key (ID_TYPE)
);

/*==============================================================*/
/* Table: VILLE                                                 */
/*==============================================================*/
create table VILLE
(
   ID_VILLE             int not null auto_increment,
   NOM_VILLE            varchar(30),
   primary key (ID_VILLE)
);

/*==============================================================*/
/* Table: QUARTIER                                              */
/*==============================================================*/
create table QUARTIER
(
   ID_QUARTIER          int not null auto_increment,
   ID_VILLE             int not null,
   NOM_QUARTIER         varchar(50),
   primary key (ID_QUARTIER),
   constraint FK_LOCALISE foreign key (ID_VILLE)
      references VILLE (ID_VILLE) on delete restrict on update restrict
);

/*==============================================================*/
/* Table: CLIENT                                                */
/*==============================================================*/
create table CLIENT
(
   ID_CLIENT            int not null auto_increment,
   NOM_CLIENT           varchar(30),
   PRENOM_CLIENT        varchar(30),
   TELEPHONE_CLIENT     varchar(30),
   ADRESSE_CLIENT       varchar(150),
   primary key (ID_CLIENT)
);

/*==============================================================*/
/* Table: BIEN                                                  */
/*==============================================================*/
create table BIEN
(
   REFERENCE            varchar(10) not null,
   ID_TYPE              int not null,
   ID_QUARTIER          int not null,
   ID_CLIENT            int not null,
   SUPERFICIE           float,
   NB_PIECES            smallint,
   LOYER                float,
   primary key (REFERENCE),
   constraint FK_APPARTIENT foreign key (ID_TYPE)
      references TYPE (ID_TYPE) on delete restrict on update restrict,
   constraint FK_SE_TROUVE foreign key (ID_QUARTIER)
      references QUARTIER (ID_QUARTIER) on delete restrict on update restrict,
   constraint FK_POSSEDE foreign key (ID_CLIENT)
      references CLIENT (ID_CLIENT) on delete restrict on update restrict
);

/*==============================================================*/
/* Table: CONTRAT                                               */
/*==============================================================*/
create table CONTRAT
(
   ID_CLIENT            int not null,
   REFERENCE            varchar(10) not null,
   DATE_CREATION        datetime not null,
   DATE_ENTREE          datetime,
   DATE_SORTIE          datetime,
   CHARGES              float,
   LOYER_CONTRAT        float not null,
   primary key (ID_CLIENT, REFERENCE, DATE_CREATION),
   constraint FK_CONTRAT2 foreign key (ID_CLIENT)
      references CLIENT (ID_CLIENT) on delete restrict on update restrict,
   constraint FK_CONTRAT foreign key (REFERENCE)
      references BIEN (REFERENCE) on delete restrict on update restrict
);

