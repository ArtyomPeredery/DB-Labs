use AdventureWorks2012;
-- Вывести на экран холостых сотрудников, 
-- которые родились раньше 1960 года (включая 1960 год).
select 
	BusinessEntityID, BirthDate, MaritalStatus, Gender, HireDate 
from 
	HumanResources.Employee 
where
	MaritalStatus = 'S' and BirthDate < '1961-01-01';
-- Вывести на экран сотрудников, работающих на позиции ‘Design Engineer’, 
-- отсортированных в порядке убывания принятия их на работу.
select 
	BusinessEntityID, JobTitle, BirthDate, Gender, HireDate 
from 
	HumanResources.Employee 
where 
	JobTitle = 'Design Engineer' order by HireDate desc;
-- Вывести на экран количество лет, отработанных каждым сотрудником отделе ‘Engineering’ ([DepartmentID] = 1). 
-- Если поле EndDate = NULL это значит, что сотрудник работает в отделе по настоящее время.
select 
	BusinessEntityID, DepartmentID, StartDate, EndDate,
    	DATEDIFF(YEAR, StartDate, case when EndDate is  NULL 
			then GETDATE() 
		else EndDate
	end) as YearsWorked 
from 
	HumanResources.EmployeeDepartmentHistory 
where 
	DepartmentID = '1';
