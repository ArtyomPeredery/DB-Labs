use AdventureWorks2012;
go

-- a) создайте таблицу dbo.Address с такой же структурой как Person.Address,
--  кроме полей geography, uniqueidentifier, не включая индексы, ограничения и триггеры;
create table dbo.Address (
	AddressID int,
	AddressLine1 nvarchar(64),
	AddressLine2 nvarchar(64),
	City nvarchar(32),
	StateProvinceID int,
	PostalCode nvarchar(16),
	ModifiedDate datetime,
	PRIMARY KEY (AddressID)
);
go

-- b) используя инструкцию ALTER TABLE, добавьте в таблицу dbo.Address новое поле ID с типом данных INT, 
-- имеющее свойство identity с начальным значением 1 и приращением 1. 
-- Создайте для нового поля ID ограничение UNIQUE;
alter table dbo.Address 
	add ID int identity(1,1) UNIQUE;
go

-- с) создайте для таблицы dbo.Address ограничение для поля StateProvinceID, 
-- чтобы заполнить его можно было только нечетными числами;
alter table dbo.Address 
	add constraint ChkRemainder check((StateProvinceID % 2) = 1);
go

-- d) создайте для таблицы dbo.Address ограничение DEFAULT для поля AddressLine2, задайте значение по умолчанию ‘Unknown’;
alter table dbo.Address 
	add constraint dfltValue 
	default 'Unknown' for AddressLine2;
go

-- e) Выберите для вставки только те адреса, где значение поля Name из таблицы CountryRegion начинается на букву ‘а’. 
-- Также исключите данные, где StateProvinceID содержит четные числа. Заполните поле AddressLine2 значениями по умолчанию;
insert into dbo.Address 
	(temp.AddressID,
	temp.AddressLine1,	
	temp.City,
	temp.StateProvinceID,
	temp.PostalCode,
	temp.ModifiedDate)
select 
	temp.AddressID,
	temp.AddressLine1,	
	temp.City,
	temp.StateProvinceID,
	temp.PostalCode,
	temp.ModifiedDate 
from 
	Person.Address as temp inner join Person.StateProvince as S
on 
	temp.StateProvinceID = S.StateProvinceID inner join Person.CountryRegion as C
on 
	S.CountryRegionCode = C.CountryRegionCode and C.Name like 'a%' and (temp.StateProvinceID % 2) = 1;
go

-- f) измените поле AddressLine2, запретив вставку null значений.
alter table dbo.Address 
	alter column AddressLine2 nvarchar(64) not null;

select * from dbo.Address
