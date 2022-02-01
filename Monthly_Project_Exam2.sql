USE master;
GO
DECLARE @data_path nvarchar(256);
SET @data_path = (SELECT SUBSTRING(physical_name, 1, CHARINDEX(N'master.mdf', LOWER(physical_name)) - 1)
      FROM master.sys.master_files
      WHERE database_id = 1 AND file_id = 1);
EXECUTE ('CREATE DATABASE HRMManagement
ON PRIMARY(NAME = HRMManagement_data, FILENAME = ''' + @data_path + 'MyInventoryMgt_data.mdf'', SIZE = 16MB, MAXSIZE = Unlimited, FILEGROWTH = 2MB)
LOG ON (NAME = HRMManagement_log, FILENAME = ''' + @data_path + 'MyInventoryMgt_log.ldf'', SIZE = 10MB, MAXSIZE = 100MB, FILEGROWTH = 1MB)'
);
GO

Use master
Drop Database HRMManagement

USe master
Drop Schema HR
go


Use HRMManagement
Create Table Departments 
(
DepartmentID Int Primary key Identity(5001,1) ,
DepartmentName Varchar(30) Unique Not null,
)
go



Select * From Departments

Use HRMManagement
Create Table JObs 
(
JObID Int Primary key Identity(5201,1),
JObTitle Varchar(30) Unique  null,
)
go

Use HRMManagement
Create table Address
(
AddressID int Primary key  Not Null,
DivisionName Varchar(30) Not Null,
City Varchar(30) Not Null
)
go

Use HRMManagement
Create Table  Employees
(
EmployeeId Int Primary Key Identity(101,1),
EmployeeName Varchar(30)  Null   ,
PhoneNumber Varchar(30) Check (PhoneNumber like '017%' or PhoneNumber like '018%' or PhoneNumber like '019%' or PhoneNumber like '016%' or PhoneNumber like '015%'),
AddressID int  Foreign Key References Address(AddressID),
BasicSalary Decimal(10,2),
HRentRate Decimal(10,2),
HouseRent  Decimal(10,2),
TotalSalary as (BasicSalary + HouseRent)
)
go


--Create Function (Scalar)--
Create Function fn_TotalSalary(@basicsalary Decimal(10,2),@hrentrate Decimal(10,2))
Returns Decimal
Begin
Declare @houserent  Decimal(10,2)
Set @houserent=(@basicsalary*@hrentrate)
Return @houserent
End
go

Insert into Employees Values ('Sarwer','01827478927',2,120000,0.50,dbo.fn_TotalSalary(120000,.50))

 --Tabular Function---

 Create Function fn_GEtByName
 (
@employeename Varchar(30)
 )
 Returns Table
 as
 Return(Select *From Employees Where EmployeeName=@employeename)
 go
 Select * from dbo.fn_GEtByName('Maruf')

 Use HRMManagement
Create Table JOB_History 
(
EmployeeId Int Foreign Key References Employees(EmployeeId),
JObID Int Foreign Key References JObs(JObID),
DepartmentID Int Foreign Key References Departments(DepartmentID) on delete Cascade ,
StartDate Date Default(Getdate()) not Null,
EndDate  Date
)
go
Select * From JOB_History


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

--Alter Column--
ALTER TABLE Departments 
ALTER COLUMN DepartmentName Varchar(40);
go
--Alter Table and Add Column--
ALTER TABLE Departments
ADD DepartmentAddress Varchar(30);

--Drop DAtabase And Table
Use master
Drop Database HRMManagement
go

Use HRMManagement
Drop Table Departments
go

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

-- Non Clustered Index
Use HRMManagement
Create  NonClustered Index NONCIndex
on  JObs(JObTitle)
go
--Clustered Index--
Use HRMManagement
Create  Index index_NAme
On Employees(EmployeeName) 
GO

---Temporary Table --
Use HRMManagement
Create Table #JObs 
(
JObID Int Primary key Identity(5201,1),
JObTitle Varchar(30) Unique Not null,
)
go
---Global Table --
Use HRMManagement
Create Table ##JObs 
(
JObID Int Primary key Identity(5201,1),
JObTitle Varchar(30) Unique Not null,
)
go
----CTE--
WITH CTE_Salary
AS
(Select EmployeeName , Sum(BasicSalary) AS [Total Employee]
From Employees)

Select * from CTE_Salary
GO

--Create a View--
Use HRMManagement
Create view vw_Address
as
Select AddressID,DivisionName,City
from Address
where  City=City
go

Select * from vw_Address where City='Kustia'
go

--Create Sequence---

Use HRMManagement
Create Table Salary
(
SalaryDivision int ,
SalaryAmount money
)
go

Use HRMManagement
Create Sequence Sq_Salary
as 
Bigint
Start with 1
Increment by 1
go

Insert into Salary Values (Next value for Sq_Salary,'KA',15000)
go
------Store Procedur---
Create Procedure sp_ModifyHRTAble
@departmentid Int ,
	@departmentname Varchar(30),
@jobid Int ,
	@jobtitle Varchar(30),
--@addressid int ,
--	@divisionname Varchar(30) ,
--	@city Varchar(30),
--@employeeid Int,														
--	@employeename Varchar(30),											
--	@phonenumber Varchar(30),											
--	@addressid_fk int ,													
--	@basicsalary Decimal(10,2),
--	@hrentrate Decimal(10,2),
--	@houserent  Decimal(10,2),
----@employeeid_FK Int ,
----	@jobid_fk Int ,
----	@departmentid_fk Int ,
----	@startdate Date,
----	@enddate Date,
@tableName Varchar(30),
@operationName Varchar(30)
As 
Begin
----Departments--
If (@tableName='Departments' and @operationName='Insert')
	Begin
	Insert into Departments Values (@departmentname)
	end
If (@tableName='Departments' and @operationName='Update')
	Begin
	Update Departments Set DepartmentName=@departmentname
			Where DepartmentID=@departmentid
	END
If (@tableName='Departments' and @operationName='Delete')
	Begin
	Delete From  Departments 
	Where DepartmentID=@departmentid
	END
--JObs--
If (@tableName='JObs' and @operationName='Insert')											
	Begin																					
	Insert into JObs Values (@jobtitle)
	end
If (@tableName='JObs' and @operationName='Update')
	Begin
	Update JObs Set JObTitle=@jobtitle
			Where JObID=@jobid
	END
If (@tableName='JObs' and @operationName='Delete')
	Begin
	Delete From  JObs 
	Where JObID=@jobid
	END
end
go
----Address--																				
--If (@tableName='Address' and @operationName='Insert')									
--	Begin																				
--	Insert into Address Values (@divisionname,@city)
--	end
--If (@tableName='Address' and @operationName='Update')
--	Begin
--	Update Address Set DivisionName=@divisionname,City=@city					
--			Where AddressID=addressid											
--	END																			
--If (@tableName='Address' and @operationName='Delete')							
--	Begin																		
--	Delete From  Address														
--	Where AddressID=addressid													
--	END																											
----Employees--
--If (@tableName='Employees' and @operationName='Insert')
--	Begin
--	Insert into Employees Values (@employeename,@phonenumber,@addressid_fk ,@basicsalary,@hrentrate,@houserent)
--	end		
--If (@tableName='Employees' and @operationName='Update')
--	Begin
--	Update Employees Set EmployeeName=@employeename,PhoneNumber=@phonenumber,AddressID=@addressid_fk,BasicSalary=@basicsalary,HRentRate=@hrentrate, HouseRent=@houserent        
--			Where EmployeeId=@employeeid
--	END
--If (@tableName='Employees' and @operationName='Delete')
--	Begin
--	Delete From  Employees
--	Where  EmployeeId=@employeeid
--	END
--end
--go
-----JOB_History----
--If (@tableName='JOB_History' and @operationName='Insert')
--	Begin
--	Insert into JOB_History Values (@employeeId_FK,@jObID_FK,@departmentID_FK ,@startDate,@endDate)
--	end
--If (@tableName='JOB_History' and @operationName='Update')
--	Begin
--	Update JOB_History Set JObID=@jObID_FK,DepartmentID=@departmentID_FK,StartDate=@startDate,EndDate=@endDate
--			Where EmployeeId=@employeeId_FK
--	End
--If (@tableName='JOB_History' and @operationName='Delete')
--	Begin
--	Delete From  JOB_History
--	Where EmployeeId=@employeeId_FK
--	END
--End
--go

--Create Trigger

Exec sp_ModifyHRTAble 5006,'SupplyChain',5210,'Swipper','Departments','Insert'
Exec sp_ModifyHRTAble 5006,'Food&Brevarage',5210,'Swipper','Departments','Update'
Exec sp_ModifyHRTAble 5006,'Food&Brevarage',5210,'Swipper','Departments','Delete'
Exec sp_ModifyHRTAble 5006,'SupplyChain',5210,'Swipper','JObs','Insert'
Exec sp_ModifyHRTAble 5006,'SupplyChain',5210,'Driver','JObs','Update'
Exec sp_ModifyHRTAble 5006,'SupplyChain',5210,'Driver','JObs','Delete'

Select * From Departments
Select * From JObs

--Trigger--
--For Trigger--
USe HRMManagement
Create Table Departments_Audit
(
DepartmentID Int ,
DepartmentName Varchar(30) Unique Not null,
AuditAction Varchar(100),
AuditActionTime Datetime
)
go

--After/For Trigger--
--Insert Triger--
Create Trigger trg_AfterInsert on dbo.Departments
for Insert 
as 
Declare
@departmentID Int ,
@departmentName Varchar(30),
@auditAction Varchar(100),
@auditActionTime Datetime

Select @departmentID=i.DepartmentID From INSERTED i
Select @departmentName=i.DepartmentName From INSERTED i
Set @auditAction='Inserted Recort---After insert trigger Fired !!!'
Insert into Departments_Audit (DepartmentID,DepartmentName,AuditAction,AuditActionTime)
		Values(@departmentID,@departmentName,@auditAction,GETDATE());

		Print 'After Insert Trigger Fired!!!'
Go
--Update---
Create Trigger trg_AfterUpdate on dbo.Departments
for Update 
as 
Declare
@departmentID Int ,
@departmentName Varchar(30),
@auditAction Varchar(100),
@auditActionTime Datetime

Select @departmentID=i.DepartmentID From INSERTED i
Select @departmentName=i.DepartmentName From INSERTED i
Set @auditAction='Updated Recort---After Update trigger Fired !!!'
Insert into Departments_Audit (DepartmentID,DepartmentName,AuditAction,AuditActionTime)
		Values(@departmentID,@departmentName,@auditAction,GETDATE());

		Print 'After Update Trigger Fired!!!'
Go
--Delete---
Create Trigger trg_AfterDelete on dbo.Departments
for Delete 
as 
Declare
@departmentID Int ,
@departmentName Varchar(30),
@auditAction Varchar(100),
@auditActionTime Datetime

Select @departmentID=d.DepartmentID From Deleted d
Select @departmentName=d.DepartmentName From Deleted d
Set @auditAction='Deleted Recort---After Delete trigger Fired !!!'
Insert into Departments_Audit (DepartmentID,DepartmentName,AuditAction,AuditActionTime)
		Values(@departmentID,@departmentName,@auditAction,GETDATE());

		Print 'After Deleted Trigger Fired!!!'
Go
Insert Into Departments Values ('Production')
Update Departments set DepartmentName= 'SuplyChain' where DepartmentID=5009
Delete from Departments where DepartmentID=5004
Select * From Departments
Select * From Departments_Audit
go
--Instead of Trigger--
Create Table  Employees_Audit
(
EmployeeId Int ,
EmployeeName Varchar(30) ,
PhoneNumber Varchar(30) ,
AddressID int ,
BasicSalary Decimal(10,2),
HRentRate Decimal(10,2),
HouseRent  Decimal(10,2),
AuditAction Varchar(100),
AuditActionTime Datetime
)
go
--Insert Triger--

Create Trigger trg_InsteadofInsert on dbo.Employees
Instead of Insert 
as 
Declare
@employeeId Int ,
@employeeName Varchar(30) ,
@phoneNumber Varchar(30) ,
@addressID int ,
@basicSalary Decimal(10,2),
@hRentRate Decimal(10,2),
@houseRent  Decimal(10,2),
@auditAction Varchar(100),
@auditActionTime Datetime

Select @employeeId=i.EmployeeId From inserted i
Select @employeeName=i.EmployeeName From inserted i
Select @phoneNumber=i.PhoneNumber From inserted i
Select @addressID=i.AddressID From inserted i
Select @basicSalary=i.BasicSalary From inserted i
Select @hRentRate=i.HRentRate From inserted i
Select @houseRent=i.HouseRent From inserted i
Set @auditAction='Inserted Recort---Instead of insert trigger Fired !!!'
Begin
	Begin Tran
		Set Nocount on
		if @basicSalary>=75000 
			Begin
				Raiserror ( 'Cannot insert this .Salary must below 75000',16,1)
				rollback
			End
		Else 
		Begin
			Insert Into Employees(EmployeeName,PhoneNumber,AddressID,BasicSalary,HRentRate,HouseRent) Values(@employeeName,@phoneNumber,@addressID,@basicSalary,@hRentRate,dbo.fn_TotalSalary(@basicSalary,@hRentRate));
			Insert into Employees_Audit (EmployeeId,EmployeeName,PhoneNumber,AddressID,BasicSalary,HRentRate,HouseRent,AuditAction,AuditActionTime)
		Values(@@identity,@employeeName,@phoneNumber,@addressID,@basicSalary,@hRentRate,dbo.fn_TotalSalary(@basicSalary,@hRentRate),@auditAction,GETDATE());
		End
	Commit Tran
	Print 'Instead of insert trigger Fired !!!'
End
go
--Update Triger--

Create Trigger trg_InsteadofUpdate on dbo.Employees
Instead of Update 
as 
Declare
@employeeId Int ,
@employeeName Varchar(30) ,
@phoneNumber Varchar(30) ,
@addressID int ,
@basicSalary Decimal(10,2),
@hRentRate Decimal(10,2),
@houseRent  Decimal(10,2),
@auditAction Varchar(100),
@auditActionTime Datetime

Select @employeeId=i.EmployeeId From inserted i
Select @employeeName=i.EmployeeName From inserted i
Select @phoneNumber=i.PhoneNumber From inserted i
Select @addressID=i.AddressID From inserted i
Select @basicSalary=i.BasicSalary From inserted i
Select @hRentRate=i.HRentRate From inserted i
Select @houseRent=i.HouseRent From inserted i
Set @auditAction='Updated Recort---Update of insert trigger Fired !!!'
Begin
	Begin Tran
		Set Nocount on
		if @basicSalary>=75000 
			Begin
				Raiserror ( 'Cannot insert this .Salary must below 75000',16,1)
				rollback
			End
		Else 
		Begin
			Update Employees set EmployeeName=@employeeName,PhoneNumber=@phoneNumber,AddressID=@addressID,BasicSalary=@basicSalary,HRentRate=@hRentRate,HouseRent=dbo.fn_TotalSalary(@basicSalary,@hRentRate)
			Where EmployeeId=@employeeId
			Insert into Employees_Audit (EmployeeId,EmployeeName,PhoneNumber,AddressID,BasicSalary,HRentRate,HouseRent,AuditAction,AuditActionTime)
		Values(@@identity,@employeeName,@phoneNumber,@addressID,@basicSalary,@hRentRate,dbo.fn_TotalSalary(@basicSalary,@hRentRate),@auditAction,GETDATE());
		End
	Commit Tran
	Print 'Instead of Updated trigger Fired !!!'
End
go

--Delete Triger--

Create Trigger trg_InsteadofDelete on dbo.Employees
Instead of Delete 
as 
Declare
@employeeId Int ,
@employeeName Varchar(30) ,
@phoneNumber Varchar(30) ,
@addressID int ,
@basicSalary Decimal(10,2),
@hRentRate Decimal(10,2),
@houseRent  Decimal(10,2),
@auditAction Varchar(100),
@auditActionTime Datetime

Select @employeeId=i.EmployeeId From inserted i
Select @employeeName=i.EmployeeName From inserted i
Select @phoneNumber=i.PhoneNumber From inserted i
Select @addressID=i.AddressID From inserted i
Select @basicSalary=i.BasicSalary From inserted i
Select @hRentRate=i.HRentRate From inserted i
Select @houseRent=i.HouseRent From inserted i
Set @auditAction='Deleted Recort---Instead of Delete trigger Fired !!!'
Begin																						--Begin Tran...End/Commit and Rollback --
	Begin Tran
		Set Nocount on
		if @basicSalary>=75000 
			Begin
				Raiserror ( 'Cannot insert this .Salary must below 75000',16,1)
				rollback
			End
		Else 
		Begin
			Delete from  Employees Where EmployeeId= @employeeId
			Insert into Employees_Audit (EmployeeId,EmployeeName,PhoneNumber,AddressID,BasicSalary,HRentRate,HouseRent,AuditAction,AuditActionTime)
		Values(@@identity,@employeeName,@phoneNumber,@addressID,@basicSalary,@hRentRate,dbo.fn_TotalSalary(@basicSalary,@hRentRate),@auditAction,GETDATE());
		End
	Commit Tran
	Print 'Instead of Deleted trigger Fired !!!'
End
go

Select * From Employees
Select * From Employees_Audit

insert into Employees values('Delowara','0175000478927',1,25000,0.50,dbo.fn_TotalSalary(25000,.50))

Update Employees set EmployeeName='Lity' where EmployeeId=104

Delete from Employees where EmployeeId=105

----Merge--
Use HRMManagement
Create table JobCandidate_Sorce
(
CandidateID int ,
CandidateName varchar(30)
)
go

Use HRMManagement
Create table JobCandidate_Target
(
CandidateID int ,
CandidateName varchar(30)
)
go

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
