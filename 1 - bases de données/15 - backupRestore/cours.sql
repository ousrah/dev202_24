#backup
#vous pouvez utiliser phpmyadmin pour faire facilement la sauvegarde et la restauration

#vous pouvez aussi utiliser les lignes de commandes comme suit :

#a executer en ligne de commande
mysqldump -h localhost -P 3308 -u root  -p vols_202 > d:\vols_202.sql


#restore
#methode 1
c:\>mysql -h localhost -P 3308 -u root  -p 
mysql> create database vols_202B collate utf8mb4_general_ci;
mysql>exit
c:\>mysql -h localhost -P 3308 -u root  -p vols_202B < d:\vols_202.sql

#methode 2
c:\>mysql -h localhost -P 3308 -u root  -p 
mysql> create database vols_202C collate utf8mb4_general_ci;
mysql>use vols_202C;
mysql> source d:\vols_202.sql
mysql>exit

