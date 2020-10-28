USE AdventureWorks2012;
GO

-- a) Создайте таблицу Person.CountryRegionHst, которая будет хранить информацию об изменениях в таблице Person.CountryRegion.
CREATE SCHEMA [Person];
GO
	CREATE TABLE [Person].[CountryRegionHst]
	(
		[ID] INT IDENTITY(1, 1) PRIMARY KEY,
		[Action] NVARCHAR(6) NOT NULL,
		[ModifiedDate] DATETIME NOT NULL CONSTRAINT [DF_CountryRegionHst_ModifiedDate] DEFAULT GETDATE(),
		[SourceID] NVARCHAR(3) NOT NULL,
		[UserName] NVARCHAR(100) NOT NULL CONSTRAINT [DF_CountryRegionHst_UserName] DEFAULT CURRENT_USER,

		CONSTRAINT [CH_CountryRegionHst_Action] CHECK([Action] IN ('INSERT', 'UPDATE', 'DELETE'))
	);
GO

-- b) Создайте три AFTER триггера для трех операций INSERT, UPDATE, DELETE для таблицы Person.CountryRegion.
--  Каждый триггер должен заполнять таблицу Person.CountryRegionHst с указанием типа операции в поле Action.
USE AdventureWorks2012;
GO
	-- AFTER INSERT
	CREATE TRIGGER [TR_CountryRegion_AI] ON [Person].[CountryRegion]
	AFTER INSERT
	AS
	BEGIN
		INSERT INTO [ALEXEY_KOSYUK].[Person].[CountryRegionHst]
		(
			[Action],
			[SourceID]
		)
		SELECT
			'INSERT',
			[I].[CountryRegionCode]
		FROM [INSERTED] AS [I];
	END
GO
	-- AFTER UPDATE
	CREATE TRIGGER [TR_CountryRegion_AU] ON [Person].[CountryRegion]
	AFTER UPDATE
	AS
	BEGIN
		INSERT INTO [ALEXEY_KOSYUK].[Person].[CountryRegionHst]
		(
			[Action],
			[SourceID]
		)
		SELECT
			'UPDATE',
			[I].[CountryRegionCode]
		FROM [INSERTED] AS [I];
	END
GO
	-- AFTER DELETE
	CREATE TRIGGER [TR_CountryRegion_AD] ON [Person].[CountryRegion]
	AFTER DELETE
	AS
	BEGIN
		INSERT INTO [ALEXEY_KOSYUK].[Person].[CountryRegionHst]
		(
			[Action],
			[SourceID]
		)
		SELECT
			'DELETE',
			[D].[CountryRegionCode]
		FROM [DELETED] AS [D];
	END
GO

-- c) Создайте представление VIEW, отображающее все поля таблицы Person.CountryRegion. 
-- Сделайте невозможным просмотр исходного кода представления.
CREATE VIEW [Person].[CountryRegion_View]
WITH ENCRYPTION
AS
	SELECT * FROM [Person].[CountryRegion];
GO

-- d) Вставьте новую строку в Person.CountryRegion через представление. Обновите вставленную строку.
--  Удалите вставленную строку. Убедитесь, что все три операции отображены в Person.CountryRegionHst.
INSERT INTO [Person].[CountryRegion_View]
(
	[CountryRegionCode],
	[ModifiedDate],
	[Name]
)
VALUES
(
	'MSQ',
	GETDATE(),
	'MINSK'
);
GO

UPDATE [Person].[CountryRegion_View]
SET
	[ModifiedDate] = GETDATE(),
	[Name] = 'MINSK'
WHERE [CountryRegionCode] = 'MSQ';
GO

DELETE FROM [Person].[CountryRegion_View]
WHERE [CountryRegionCode] = 'MSQ';
GO
