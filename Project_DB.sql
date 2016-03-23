---------------------------------------------BY AMBASAGER -----------------
--Part 1
----------------------------------------------------------------------------
--drop database DrivingSchool
go
If OBJECT_ID(N'DrivingSchool',N'U') is null 
	create database DrivingSchool

go



use DrivingSchool


-- Table for Car 
IF OBJECT_ID(N'Car',N'U') is null
create table Car (
carNo int primary key not null,
registrationNumber varchar(20),
)
 
-- insert data to car 

insert into Car
values
(1,'wx1234'),
(2,'as3456'),
(3,'zs2343'),
(4,'ts9876'),
(5,'ft5476')
go

--Table for inspection 
IF OBJECT_ID(N'Inspection',N'U') is null
create table Inspection(
inspectionNo int primary key not null,
inspectedDate date,
numberOfFaults int ,
faultDescription varchar(255),
carNo int references Car(carNo)
)

--insert data to inspection

insert into Inspection
values
(1,GETDATE(),1,'description one',2),
(2,GETDATE()+1,1,'description two',3),
(3,GETDATE()+1,2,'description one',2),
(4,GETDATE()+1,2,'description one',3)

go

--Table for branch
IF OBJECT_ID(N'Branch','U')is null
create table Branch(
	branchNo int not null primary key,
	address_ varchar(255) ,
	city varchar(40),
	
)
-- Insert data into Branch
insert into Branch
values
(1,'1234 B st, IA','FairField'),
(2,'1234 B st, IA','Ottumwa')

go
--Table for the Staff 
IF OBJECT_ID(N'Staff',N'U') is null
create table Staff(
staffNo int primary key not null, 
name varchar(20),
position varchar(20),
gender varchar(2), 
DOB date,
telNo varchar(40),
address_ varchar(40),
carNo int references Car(carNo),
branchNo int references Branch(branchNo)
)
--Insert value to Staff table
insert into Staff
values
(1,'Roben','adminstrator','M',GETDATE()-30,'902-234-9876','123 A st FairField, IA 52557',1,1),
(2,'Jesika','manager','F',GETDATE()-60,'703-897-3218','876 B st FairField, IA 52557',2,1),
(3,'Jermy','instructor','M',GETDATE()-40,'673-432-3456','874 C st Iowa city, IA 52557',3,1),
(4,'Janey','secratory','F',GETDATE()-50,'345-987-1234','765 D st ottumwa, IA 53557',null,2),
(5,'Jordan','instructor','F',GETDATE()-20,'987-123-9870','0987 E st FairField, IA 52557',4,1)
go

-- Table for client
IF OBJECT_ID(N'Client',N'U') is null
create table Client(
clientNo int primary key not null,
fName varchar(40) not null,
lName varchar(40) not null,
gender varchar(2),
address_ varchar(40),
validProvisionalLicense varchar(3),
staffNo int references Staff(staffNo),
interViewDate date,
interviewerID int references Staff(staffNo)
)

--insert data to Client
insert into Client
values
(1,'Frank','Jhon','M','223 A st FairField, IA 52557','yes',1,GETDATE()-2,1),
(2,'Alber','Kaney','M','123 B st FairField, IA 52557','yes',3,GETDATE()-24,2),
(3,'Kenady','Carrey','M','873 C st FairField, IA 52557','no',1,GETDATE()-8,4),
(4,'Jim','Jhonson','F','1013 D st FairField, IA 52557','yes',2,GETDATE()-9,5),
(5,'Barbera','Kelly','F','874 C st Iowa city, IA 52557','no',4,GETDATE()-12,1)
go

-- Table for DrivingTest
IF OBJECT_ID(N'DrivingTest',N'U') is null
create table DrivingTest(	
	dateTaken date not null,
	clientNo int not null,
	drivingTestResult varchar(20),
	reasonForFailing varchar(255),
	primary key (dateTaken, clientNo)
)

-- Insert into the DrivingTest
insert into DrivingTest
values
(getDate(),3,'pass',null),
(GETDATE()-1,2,'fail','speeding'),
(GETDATE()-4,3,'fail','lane change issue'),
(GETDATE()-30,1,'pass',null),
(GETDATE()-10,4,'pass',null),
(GETDATE()-16,5,'learning',null)

go

-- Table for Lesson

IF OBJECT_ID(N'Lesson',N'U') is null
create table Lesson(
clientNo_pk int references Client(clientNo) not null,
staffNo_pk int references Staff(staffNo) not null,
date_pk date,
time_pk time,
block bit,
carNo int references Car(carNo),
mileage float,
progress varchar(255),
fee float,
primary key(clientNo_pk,staffNo_pk,date_pk,time_pk)

)
-- Inser values to the Lesson
insert into Lesson
values
(1,3,GETDATE()-1,convert(time,GETDATE()),1,5,20.5,'good progress',100.0),
(4,5,GETDATE()-3,convert(time,GETDATE()),0,3,25.5,'good start',50.0),
(5,5,GETDATE()+7,convert(time,GETDATE()),0,3,30.5,'second day',100.0)

--Step 2

--a
select s.name,s.telNo
from Branch b inner join Staff s
on b.branchNo=s.branchNo
where position='manager'
--b
select *
from Branch
where city='FairField'

--c
select s.name
from Staff s inner join Branch b
On s.branchNo=b.branchNo
where s.position='instructor' AND b.city='FairField'

--d
select branchNo,COUNT(staffNo) as StaffNUmber
from Staff
group by branchNo

--e 

select b.city,COUNT(c.clientNo) As NumberOfClients
from Client c inner join DrivingTest d 
On c.clientNo=d.clientNo 
inner join Staff s
On c.staffNo=s.staffNo
inner join Branch b
On s.branchNo=b.branchNo
group by b.city

--f
select s.name,date_pk as Date_class, time_pk as starting_time
from Lesson l inner join Staff s
on l.staffNo_pk=s.staffNo
where s.position='instructor' AND date_pk='2016-03-17'

--g

select *
from Client
where interviewerID=1

-- h
select COUNT(clientNO) As NumberOfClientsInFairField
from Client c inner join Staff s
On c.staffNo=s.staffNo
where s.address_ like'%FairField%'

------------------------------------------------------------------------------------
--Part 2

--Storeprocedures and Functions -----------
-------------------------------------------------------------------------------------
--7


go
create procedure LessonsOfInstructor
@staffNo int
As
select * 
from Lesson
where staffNo_pk=@staffNo

--Test procedure

exec LessonsOfInstructor @staffNo=3


-- 8


go
create procedure staffNoAndDate
@staffNo int , @date date
As
select *
from Lesson
where staffNo_pk=@staffNo AND date_pk=DateAdd(day,7,@date)

--drop procedure staffNoAndDate
--Test 

exec staffNoAndDate 5,'2016-03-10';


go


--8.5 a

create procedure searchClient
@clientNo int 
As
select *
from Lesson
where clientNo_pk=@clientNo

--Test
exec searchClient 5

--8.5 b,

go
create procedure clientNoAndDate
@clientNo int , @date date
As
select *
from Lesson
where staffNo_pk=@clientNo AND date_pk=DateAdd(day,7,@date)

--Test
exec clientNoAndDate 5,'2016-03-10'

--c
go

exec sp_help
exec sp_statistics Brach


--9 a

go

create view Client_Lesson
As
select * 
from Client c inner join Lesson s
On s.clientNo_pk=s.clientNo_pk

--Test
go
select *
from Client_Lesson

go

--9 b


create view Branch_Staff
As
select b.city As Branch_City,s.name as Client_name, s.address_ as Client_Address
from Branch b inner join Staff s
On b.branchNo=s.branchNo

go
--Test
select * 
from Branch_Staff

go
create view DrivingTest_Client
As
select c.*,d.drivingTestResult as Result
from Client c inner join DrivingTest d
On c.clientNo=d.clientNo

go
--Test
select *
from DrivingTest_Client


--10 a

go

create function totalLessonsTaken(@clientNo int) 
returns table
As
return
select COUNT(clientNo_pk) NumberOfClients
from Lesson s
where s.clientNo_pk=@clientNo AND date_pk<GETDATE()
 
 
go

--Test
select *
from totalLessonsTaken(5)



--10 b


go
create function tLessonsTaken(@clientNo int, @date date)
returns table
AS
return
(
select count(s.clientNo_pk) as CountOfLessons
from Lesson s
where s.clientNo_pk=@clientNo AND s.date_pk<@date
);
--Test totalLessonsTaken
go
select * 
from tLessonsTaken(5,GETDATE())
go

--11

go

create function clientLesson(@clientNo int)
returns table
as
return
select c.*
from Client c inner join Lesson l
on c.clientNo=l.clientNo_pk
where c.clientNo=@clientNo

go
--Test of ClientLesson function 

select *
from clientLesson(4)


go

--12


--alter the Staff to add the totalClients column which was not added during creation of the table
alter table Staff 
add totalClients int default(0)
with values

go
--Trigger for Insert on Client table to inform Staff table to update the totalClient Count
create Trigger totalClientUpdater on Client
after Insert
As
update Staff 
set Staff.totalClients =s.totalClients+1
from Staff s inner join Inserted i
On s.staffNo=i.staffNo

--Test for Trigger 
insert into Client
values(6,'Robon','Thomas','M','453 V st, IA 52557','yes',4,GETDATE(),4)


--Trigger for Delete on Client so Staff will decrement the totalClients count

go

create Trigger totalClientsForDelete On Client
After delete
As
Update Staff 
set Staff.totalClients-=1
from Staff s inner join Deleted d
On s.staffNo=d.staffNo

--Test for the delete Trigger On Client
delete from Client
where clientNo=6


go

-------------------------------------------------------------------------------------------------
--Part 3
-------------------------------------------------------------------------------------------------

go

--i

select staffNo, name
from Staff s
where year(getDate())-year(s.DOB)>55 AND s.position='instructor'
--Insert staff older than 55 years old
insert into Staff
values(6,'Bob','instructor','M','1960-01-01 10:08:08','765-987-3425','123 D dr FairField, IA 55257',5,1,0)

go

--j

select registrationNumber
from Car c left outer join Inspection i
on c.carNo=i.carNo
where i.numberOfFaults=0 or c.carNo not in (select carNo from Inspection);

go

--k

select registrationNumber
from Car c inner join Staff s
On c.carNo=s.carNo
where s.position='instructor' AND s.carNo is not null


go

--L

select fName + ' ' + lName as FullName
from Client c inner join DrivingTest d
On c.clientNo=d.clientNo
where d.drivingTestResult='pass' AND year(d.dateTaken)=2016 AND month(d.dateTaken)=2


go

--m

insert into DrivingTest
values
(getDate()-40,2,'fail','not ready at all'),
(getDate()-3,2,'fail','speeding'),
(getDate(),2,'fail','stop sign')

select c.fName + ' ' + c.lName as FullName
from Client c
where c.clientNo in(select t.clientNo
					from DrivingTest t
					where t.drivingTestResult='fail'
					group by t.clientNo
					having count(t.clientNo)>3					
					)



go

--n
select AVG(l.mileage) as Mileage
from Lesson l
where l.block=0

go

--o
select s.branchNo,count(s.staffNo) as NumberOfAdministrators
from Staff s
where s.position='adminstrator'
group by s.branchNo


go
---------------------------------------------------------------------------------
--Step 4  Cursor
----------------------------------------------------------------------------------

--15  CURSOR WITH IF...ELSE Statment

go

--To hold the attributes of a row returned by the fetch next operation of the cursor
Declare @clientNo_pk int, @staffNo_pk int,@date_pk date, 
	@time_pk time,@block bit,@carNo int,@Mileage float,@progress Varchar(255),@fee float

--Declare a cursor that fetch's one row at a time from the table returned from the query 
Declare lesson_cursor Cursor
for select * from Lesson

--open the cursor to start fetching row 
open lesson_cursor

--This will instantiate the variables decalred above
Fetch next from lesson_cursor into  @clientNo_pk, @staffNo_pk ,@date_pk , 
	@time_pk , @block, @carNo,@Mileage ,@progress ,@fee 

--this is a loop to fetch all the rows one at a time
while @@FETCH_STATUS=0

Begin	
--Option One
	if(@Mileage>20 AND @Mileage<=25) 
	begin
	update Lesson 
	set Lesson.fee+=5
	where Lesson.clientNo_pk=@clientNo_pk AND Lesson.staffNo_pk=@staffNo_pk AND
		Lesson.date_pk=@date_pk AND Lesson.time_pk=@time_pk
	end
--Option Two
	else if(@Mileage>25 AND @Mileage<=30)
	begin
	update Lesson 
	set Lesson.fee+=5
	where Lesson.clientNo_pk=@clientNo_pk AND Lesson.staffNo_pk=@staffNo_pk AND
		Lesson.date_pk=@date_pk AND Lesson.time_pk=@time_pk
	end	
--Option Three
	else if(@Mileage>30)	
	begin
	update Lesson 
	set Lesson.fee+=10
	where Lesson.clientNo_pk=@clientNo_pk AND Lesson.staffNo_pk=@staffNo_pk AND
		Lesson.date_pk=@date_pk AND Lesson.time_pk=@time_pk		
	end
	--updated the variables from the next row
	Fetch next from lesson_cursor into  @clientNo_pk, @staffNo_pk ,@date_pk,@time_pk,
		@block, @carNo,@Mileage,@progress,@fee 

end 
--This will release the resources and close cursor
close lesson_cursor
Deallocate lesson_cursor

go

----15  CURSOR WITH CASE ....WHEN..THEN Statment

declare cursor_with_case CURSOR
for select * from Lesson

Declare @clientNo_pk int, @staffNo_pk int,@date_pk date, 
	@time_pk time,@block bit,@carNo int,@Mileage float,@progress Varchar(255),@fee float
	
	
open cursor_with_case


fetch next from cursor_with_case into 
 @clientNo_pk, @staffNo_pk ,@date_pk , 
	@time_pk , @block, @carNo,@Mileage ,@progress ,@fee 
	
Declare @temp float	

while @@FETCH_STATUS=0
begin
	update Lesson
	set Lesson.fee=(CASE 
					when @Mileage>20 AND @Mileage<=25 then Lesson.fee+5
					when @Mileage>25 AND @Mileage<=30 then Lesson.fee+8
					when @Mileage>30 then Lesson.fee+10
					ELSE Lesson.fee+0
				END)
	where	Lesson.clientNo_pk=@clientNo_pk AND Lesson.staffNo_pk=@staffNo_pk AND
		Lesson.date_pk=@date_pk AND Lesson.time_pk=@time_pk	
		
		
	fetch next from cursor_with_case into  @clientNo_pk, @staffNo_pk ,@date_pk , 
				@time_pk , @block, @carNo,@Mileage ,@progress ,@fee 
end

close cursor_with_case
deallocate cursor_with_case


go




-- 16 
Declare @forWhile int , @print varchar(40)
set @forWhile=3
while @forWhile>=0
begin
select @print=
Case @forWhile
	when 3 then '.......PROJECT......'
	when 2 then '........IS..........'
	when 1 then '........DONE........'
	ElSE '-----AMBASAGER-------'
END
	print @print
	set @forWhile-=1
END


go


-- EXTRA CREDIT String functions

IF OBJECT_ID(N'Server',N'U') is null 
create table Server
(serverNo int not null primary key ,serverName Varchar(255))

insert into Server
values
(1, 'server1.mumu.com'),
(2,'server2.admin.com'),
(3,'server.com'),
(4, 'server3.usa'),
(5,'Server2.uk'),
(6,'server'),
(7,'server_four.com.eth'),
(8,'server1.mum.com')

select *
from Server

--Get only the server name from each serverName

create table #Temp(serverName varchar(255),domainEnding varchar(5))
go

declare @name Varchar(255) 
Declare @length int
declare @Re_length int
declare @serverName varchar(255)
declare @domainEnding varchar(5)
declare cursor_serverName CURSOR
for select serverName from Server

open cursor_serverName
fetch next from cursor_serverName into @name


while @@FETCH_STATUS=0
begin 	
set @length=CASE when charindex('.',@name)>0 then charindex('.',@name)
			else len(@name)+1 --to balance the decrement in the insert statment
			end
set @Re_length=CASE when charindex('.',reverse(@name))>0 then charindex('.',reverse(@name))
			else 1  --for domains names which don't have the dot and the 1 is to neutralize the decrement by one in the substring manipulation below
			end

set @serverName=Substring(@name,1,@length -1)
set @domainEnding=reverse(Substring(reverse(@name),1,@Re_length -1))  --reverse the string then extract the part then reverse back after manipulation
insert into #Temp values(@serverName,@domainEnding)

fetch next from cursor_serverName into @name
end

close cursor_serverName
deallocate cursor_serverName
go


--Test the extracting of the server name from the domain name
select * from  #Temp
--drop table #Temp

