USE AdventureWorks2012;
GO

-- Создайте scalar-valued функцию, которая будет принимать в качестве входного параметра id подкатегории для продукта
--  (Production.ProductSubcategory.ProductSubcategoryID) и возвращать количество продуктов указанной подкатегории (Production.Product).
CREATE FUNCTION [Production].[GetProductCountBySubcategoryID]
(
	@id INT
)
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT(*) FROM [Product] WHERE [ProductSubcategoryID] = @id); 
END

GO

-- Создайте inline table-valued функцию, которая будет принимать в качестве входного параметра id подкатегории
--  для продукта (Production.ProductSubcategory.ProductSubcategoryID), а возвращать список продуктов указанной 
-- подкатегории из Production.Product, стоимость которых более 1000 (StandardCost).
CREATE FUNCTION [Production].[GetProductsListFromSubcategoryWithPrice]
(
	@id INT
)
RETURNS TABLE
AS
	RETURN (SELECT * FROM [Product] WHERE [ProductSubcategoryID] = @id AND [StandardCost] > 1000.00);

GO

-- CROSS APPLY
SELECT * FROM [Production].[Product] CROSS APPLY [Production].[GetProductsListFromSubcategoryWithPrice]([ProductSubcategoryID]);

GO

-- OUTER APPLY
SELECT * FROM [Production].[Product] OUTER APPLY [Production].[GetProductsListFromSubcategoryWithPrice]([ProductSubcategoryID]);

GO

-- Измените созданную inline table-valued функцию, сделав ее multistatement table-valued (предварительно сохранив для проверки код создания inline table-valued функции).
CREATE FUNCTION [Production].[GetProductsListFromSubcategoryWithPrice_Multistatement]
(
	@id INT
)
RETURNS @products TABLE
(
	[ProductID] INT NOT NULL PRIMARY KEY,
	[StandardCost] MONEY NOT NULL,
	[ProductNumber] NVARCHAR(25) NOT NULL,
	[ProductSubcategoryID] INT NOT NULL
)
AS
BEGIN
	INSERT INTO @products
		SELECT  
			[P].[ProductID],
			[P].[StandardCost],
			[P].[ProductNumber],
			[P].[ProductSubcategoryID]
		FROM [Production].[Product] AS [P]
		WHERE [ProductSubcategoryID] = @id AND [StandardCost] > 1000.00;

	RETURN;
END

GO
