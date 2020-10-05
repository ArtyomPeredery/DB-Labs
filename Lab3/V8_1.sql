use AdventureWorks2012;
go
-- a) добавьте в таблицу dbo.Address поле PersonName типа nvarchar размерностью 100 символов;
alter table dbo.Address 
	add PersonName nvarchar(100);
go
-- b) объявите табличную переменную с такой же структурой как dbo.Address и заполните ее данными из dbo.Address,
--  где StateProvinceID = 77. Поле AddressLine2 заполните значениями из CountryRegionCode таблицы Person.CountryRegion,
--   Name таблицы Person.StateProvince и City из Address. Разделите значения запятыми;
declare @AddressTemp table (
	AddressID int not null,
	AddressLine1 nvarchar(64) null,
	AddressLine2 nvarchar(64) not null,
	City nvarchar(36) null,
	StateProvinceID int null,
	PostalCode nvarchar(16) null,
	ModifiedDate datetime null,
	ID int identity(1,1) UNIQUE not null,
	PersonName nvarchar(100) null
);

insert into @AddressTemp
	(AddressID,	AddressLine1, AddressLine2,	City, StateProvinceID, PostalCode, ModifiedDate)
select 
	AddressID, AddressLine1,
	(CONCAT(
		(select 
			CR.CountryRegionCode 
		from 
			Person.CountryRegion as CR inner join Person.StateProvince as SP 
		on 
			CR.CountryRegionCode = SP.CountryRegionCode inner join Person.Address as AD
		on 
			SP.StateProvinceID = AD.StateProvinceID
		where 
			AD.AddressID = A.AddressID),', ', 
		(select 
			SP.Name 
		from 
			Person.StateProvince as SP inner join Person.Address as AD 
		on 
			SP.StateProvinceID = AD.StateProvinceID
		where 
			AD.AddressID = A.AddressID), ', ', 
		City)),
	City, StateProvinceID, PostalCode, ModifiedDate
from 
	dbo.Address as A
where 
	StateProvinceID = 77;
-- c) обновите поле AddressLine2 в dbo.Address данными из табличной переменной. 
-- Также обновите данные в поле PersonName данными из Person.Person,
--  соединив значения полей FirstName и LastName;
update dbo.Address
set 
	AddressLine2 = AT.AddressLine2 
from 
	@AddressTemp as AT;

update dbo.Address 
set 
	PersonName = P.FirstName + ' ' + P.LastName 
from 
	Person.Person as P inner join Person.BusinessEntityAddress as B 
on 
	B.BusinessEntityID = P.BusinessEntityID 
where 
	B.AddressID = dbo.Address.AddressID;

-- d) удалите данные из dbo.Address, которые относятся к типу ‘Main Office’ из таблицы Person.AddressType;
delete dbo.Address 
from 
	dbo.Address as A inner join Person.BusinessEntityAddress as B
on
	A.AddressID = B.AddressID inner join Person.AddressType as AT
on
	B.AddressTypeID = AT.AddressTypeID
where 
	AT.Name = 'Main Office';

SELECT *
FROM AdventureWorks2012.INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Address';

-- e) удалите поле PersonName из таблицы, удалите все созданные ограничения и значения по умолчанию;
-- Имена ограничений вы можете найти в метаданных. 
alter table dbo.Address drop column PersonName;
alter table dbo.Address drop constraint PK__Address__091C2A1BFF1AA07B
alter table dbo.Address drop constraint UQ__Address__3214EC26F78C1001
alter table dbo.Address drop constraint ChkRemainder
alter table dbo.Address drop constraint dfltValue
-- f) удалить таблицу dbo.Address.
drop table dbo.Address