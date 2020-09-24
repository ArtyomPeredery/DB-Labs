use AdventureWorks2012;
go

-- Вывести на экран список сотрудников которые подавали резюме при трудоустройстве.
select 
	Employee.BusinessEntityID, Employee.OrganizationLevel, Employee.JobTitle, JobCand.JobCandidateID, JobCand.Resume
from 
	HumanResources.Employee as Employee inner join HumanResources.JobCandidate as JobCand 
on 
	JobCand.BusinessEntityID = Employee.BusinessEntityID;

-- Вывести на экран названия отделов, в которых работает более 10-ти сотрудников
select 
	Dep.DepartmentID, Dep.Name, COUNT(Dep.DepartmentID) as EmpCount
from 
	HumanResources.Department as Dep inner join HumanResources.EmployeeDepartmentHistory as EmpDepHis
on 
	Dep.DepartmentID = EmpDepHis.DepartmentID 
group by 
	Dep.DepartmentID, Dep.Name
having COUNT(Dep.DepartmentID) > 10;

-- Вывести на экран накопительную сумму часов отпуска по причине болезни (SickLeaveHours) в рамках каждого отдела.
--  Сумма должна накапливаться по мере трудоустройства сотрудников (HireDate).
select 
	Dep.Name, Emp.HireDate,	Emp.SickLeaveHours,
	(select 
		SUM(SickLeaveHours) 
	from 
		HumanResources.Employee as E inner join HumanResources.EmployeeDepartmentHistory as HEmpDepHis
	on
		E.BusinessEntityID = HEmpDepHis.BusinessEntityID inner join HumanResources.Department as D
	on 
		D.DepartmentID = HEmpDepHis.DepartmentID
	where 
		HireDate <= Emp.HireDate and D.Name = Dep.Name) as AccumulativeSum
from 
	HumanResources.Department as Dep inner join HumanResources.EmployeeDepartmentHistory as EDH
on 
	Dep.DepartmentID = EDH.DepartmentID inner join HumanResources.Employee as Emp
on 
	EDH.BusinessEntityID = Emp.BusinessEntityID
group by Dep.Name, Emp.HireDate, Emp.SickLeaveHours, Emp.BusinessEntityID 
order by Dep.Name, Emp.HireDate;

