use master;
go

create database	Artem_Peredery;
go

use Artem_Peredery;
go

CREATE SCHEMA sales;
go

CREATE SCHEMA persons;
go

CREATE TABLE sales.Orders (OrderNum INT NULL);
go

backup database Artem_Peredery
to disk  'C:\Users\Artem\Desktop\БД\Lab1\Artem_Peredery.bak';

drop database Artem_Peredery;

RESTORE DATABASE AdventureWorks2012
FROM disk= 'C:\Users\Artem\Desktop\БД\Lab1\Artem_Peredery.bak'