--CRUD Operation--
--Insert---

Insert Into Departments Values ('Accounting'),
									('Finance'),
										('Marketing'),
											('HRM'),
												('Management')
go
Select * From Departments
Insert Into JObs Values ('Manager'),
							('AssitantManager'),
								('Admin'),
									('JuniorAdmin'),
										('Accountant'),
											('BookKepper'),
													('ITSupport'),
														('FrontOfficer'),
															('Cashiar')
go

Select * From JObs

Insert into Address Values (1,'DHaka','Sherpur'),
								(2,'Chittagong','Patiya'),
									(3,'Barishal','Patukhali'),
										(4,'Cumilla','NabiNagor'),
											(5,'Rajshahi','Natore'),
												(6,'Khulna','Kustia'),
													(7,'Shylhet','MoulabiBazar'),
														(8,'Rongpur','Tetulia')
Go
Select * From Address		

Insert into Employees Values ('Sarwer','01827478927',2,120000,0.50,dbo.fn_TotalSalary(120000,.50)),
							 ('Rony',  '01525755227',6,25000,0.50,dbo.fn_TotalSalary(25000,.50)),
							  ('Iqbal','01775965565',2,65000,0.50,dbo.fn_TotalSalary(65000,.50)),
							   ('Kashem','0157435555',4,40000,0.50,dbo.fn_TotalSalary(40000,.50)),
							    ('Maruf','017827478927',1,62000,0.50,dbo.fn_TotalSalary(62000,.50)),
								 ('Didar','0195455555',8,33000,0.50,dbo.fn_TotalSalary(33000,.50)),
								  ('Monmon','0152475555',2,15000,0.50,dbo.fn_TotalSalary(15000,.50)),
								   ('Shakawat','01965455',2,20000,0.50,dbo.fn_TotalSalary(20000,.50)),
								    ('Rabiul','0182475555',2,70000,0.50,dbo.fn_TotalSalary(70000,.50)),
									 ('Koli','0155475555',2,60000,0.50,dbo.fn_TotalSalary(60000,.50)),
									 ('Lily','017527478927',1,25000,0.50,dbo.fn_TotalSalary(25000,.50)),
									 ('Junayed','0184752545',1,10000,0.50,dbo.fn_TotalSalary(10000,.50)),
									 ('Muntasir','0175842654',1,15200,0.50,dbo.fn_TotalSalary(15200,.50)),
									 ('Saiful','01966955555',3,35000,0.50,dbo.fn_TotalSalary(35000,.50)),
									 ('Dulal','0196688555',3,54000,0.50,dbo.fn_TotalSalary(54000,.50)),
									 ('Moni','01966847555',5,7200,0.50,dbo.fn_TotalSalary(7200,.50)),
									 ('Nishat','01966847775',6,5800,0.50,dbo.fn_TotalSalary(5800,.50)),
									 ('Faruk','0156847555',6,30000,0.50,dbo.fn_TotalSalary(30000,.50)),
									 ('Shahed','01565547555',6,28000,0.50,dbo.fn_TotalSalary(28000,.50)),
									 ('Habib','0156847555',8,80000,0.50,dbo.fn_TotalSalary(80000,.50))
go

Select * From Employees


Insert into JOB_History Values                                  (101,5203,5005,'2/6/1996','2/10/2021'),
								                                (102,5203,5005,'2/6/1955','2/10/2021'),
									                        	(103,5204,5004,'2/6/1999','2/10/2021'),
														    	(104,5203,5001,'2/6/2000','2/10/2021'),
														    	(105,5205,5002,'2/6/2010','2/10/2021'),
																(106,5208,5005,'2/6/2010','2/10/2021'),
																(107,5201,5003,'2/6/2010','2/10/2021'),
																(108,5206,5001,'2/6/2010','2/10/2021'),
																(109,5207,5002,'2/6/2010','2/10/2021'),
																(110,5201,5004,'2/6/2010','2/10/2021'),
																(111,5205,5003,'2/6/2010','2/10/2021'),
																(112,5209,5002,'2/6/2010','2/10/2021'),
																(113,5208,5005,'2/6/2010','2/10/2021'),
																(114,5203,5001,'2/6/2010','2/10/2021'),
																(115,5209,5005,'2/6/2010','2/10/2021'),
																(116,5207,5004,'2/6/2010','2/10/2021'),
																(117,5201,5005,'2/6/2012','2/10/2021'),
																(118,5202,5003,'2/6/2012','2/10/2021'),
																(119,5206,5001,'2/6/2012','2/10/2021'),
																(120,5201,5002,'2/6/2012','2/10/2021')
go


Select * From JOB_History
--Delete---
Delete from JOB_History where EmployeeId=101
--Update--
Update Employees set EmployeeName='Foysal' where EmployeeId=101

--Clause--
--SELECT, FROM, WHERE, GROUP BY, HAVING, ORDER BY

Select *
From Employees
Where EmployeeId>110
--Where--
Select TotalSalary 
From Employees
Where TotalSalary>=50000
--Group By
Select EmployeeName, Count(AddressID) AS [Total Employee]
From Employees
Group By EmployeeName

--Having
Select DepartmentID, Count(DepartmentID) AS [Total JOb]
From JOB_History
Group By DepartmentID
Having Count(DepartmentID)>=5

-- Order By(ASC)
Select  EmployeeName
From Employees
Group By EmployeeName 
Order By EmployeeName Asc
GO
-- Order By(DESC)
Select  EmployeeName
From Employees
Group By EmployeeName 
Order By EmployeeName DESC
GO
--CUBE--
Select employeeName , PhoneNumber, Sum(TotalSalary) as total
from Employees
Group by Cube(employeeName,PhoneNumber)

--INNER JOIN

SELECT Employees.EmployeeName,Employees.BasicSalary,TotalSalary,JOB_History.DepartmentID,JOB_History.JObID,JObs.JObTitle
FROM Employees
join JOB_History
on JOB_History.EmployeeId=Employees.EmployeeId
join JObs
On JOB_History.JObID=JObs.JObID

--LEFT JOIN

SELECT  j.EmployeeId,j.EndDate,j.StartDate,d.DepartmentID
FROM Departments AS d
LEFT JOIN JOB_History AS j
ON d.DepartmentID=j.DepartmentID
GO 

SELECT  *
FROM Departments 
LEFT JOIN JOB_History 
ON Departments.DepartmentID =JOB_History.DepartmentID
GO 
--Right join--
SELECT  j.EmployeeId,j.EndDate,j.StartDate,d.DepartmentID
FROM Departments AS d
Right JOIN JOB_History AS j
ON d.DepartmentID=j.DepartmentID
GO 

--Full join--
SELECT  j.EmployeeId,j.EndDate,j.StartDate,d.DepartmentID
FROM Departments AS d
Full JOIN JOB_History AS j
ON d.DepartmentID=j.DepartmentID
GO 

--Cross Join--
SELECT  j.EmployeeId,j.EndDate,j.StartDate,d.DepartmentID
FROM Departments AS d
Cross JOIN JOB_History AS j
GO 

--Self join--
SELECT *
FROM Departments AS d,Departments AS s
Where d.DepartmentID=s.DepartmentID
GO 

----CTE--
WITH CTE_Salary
AS
(Select EmployeeName , Sum(BasicSalary) AS [Total Employee]
From Employees)

Select * from CTE_Salary
GO
--Store Procedure --
Exec sp_ModifyHRTAble 5006,'SupplyChain',5210,'Swipper','Departments','Insert'
Exec sp_ModifyHRTAble 5006,'Food&Brevarage',5210,'Swipper','Departments','Update'
Exec sp_ModifyHRTAble 5006,'Food&Brevarage',5210,'Swipper','Departments','Delete'
Exec sp_ModifyHRTAble 5006,'SupplyChain',5210,'Swipper','JObs','Insert'
Exec sp_ModifyHRTAble 5006,'SupplyChain',5210,'Driver','JObs','Update'
Exec sp_ModifyHRTAble 5006,'SupplyChain',5210,'Driver','JObs','Delete'

Select * From Departments
Select * From JObs
--Trigger For Insert/Update/Delete
Insert Into Departments Values ('Production')
Update Departments set DepartmentName= 'SuplyChain' where DepartmentID=5009
Delete from Departments where DepartmentID=5004
Select * From Departments
Select * From Departments_Audit
go

--Trigger Instead of Insert/Update/Delete--
Select * From Employees
Select * From Employees_Audit

insert into Employees values('Delowara','0175000478927',1,25000,0.50,dbo.fn_TotalSalary(25000,.50))

Update Employees set EmployeeName='Lity' where EmployeeId=104

Delete from Employees where EmployeeId=105
--For Sequence--
Insert into Salary Values (Next value for Sq_Salary,'KA',15000)
go

--For Merge---
Insert into JobCandidate_Sorce Values(1,'Kalam'),
										(2,'Helal'),
											(3,'Jabbar')
go

Insert into JobCandidate_Target Values(1,'Kalam'),
										(2,'Nishat'),
											(3,'Jabbar')
go

Select * From JobCandidate_Sorce
Select * From JobCandidate_Target

Merge JobCandidate_Target as T
Using JobCandidate_Sorce as S
on T.CandidateID=S.CandidateID
When Matched then 
Update set T.CandidateName=S.CandidateName
When Not Matched by target then
Insert (CandidateID,CandidateName)values (S.CandidateID,S.CandidateName)
When Not Matched by Source then
Delete;