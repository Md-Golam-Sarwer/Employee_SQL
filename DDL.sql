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

Use HRMManagement
Create Table Departments 
(
DepartmentID Int Primary key Identity(5001,1) ,
DepartmentName Varchar(30) Unique Not null,
)
go

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

--Create Function (Scalar)--
Use HRMManagement
Create Function fn_TotalSalary(@basicsalary Decimal(10,2),@hrentrate Decimal(10,2))
Returns Decimal
Begin
Declare @houserent  Decimal(10,2)
Set @houserent=(@basicsalary*@hrentrate)
Return @houserent
End
go

 --Tabular Function---
 Use HRMManagement
 Create Function fn_GEtByName
 (
@employeename Varchar(30)
 )
 Returns Table
 as
 Return(Select *From Employees Where EmployeeName=@employeename)
 go

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


------Store Procedur---
Use HRMManagement
Create Procedure sp_ModifyHRTAble
@departmentid Int ,
	@departmentname Varchar(30),
@jobid Int ,
	@jobtitle Varchar(30),
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
Use HRMManagement
go
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
Use HRMManagement
go
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
Use HRMManagement
go
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
Use HRMManagement
go
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
Use HRMManagement
go
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
Use HRMManagement
go
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
Use HRMManagement
go
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


---For Merge--
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













