use master
go
create database deptemp
on primary(
	name = 'deptemp_dat',
	filename = 'D:\deptemp.mdf',
	size = 10MB,
	maxsize = 50MB,
	filegrowth = 10MB
	
)
log on(
	name = 'deptemp_log',
	filename = 'D:\deptemp.ldf',
	size = 2MB,
	maxsize = 5MB,
	filegrowth = 2%
)
go
use deptemp
go
create table department(
	departmentNo int primary key,
	departmentName char(25) not null,
	location char(25) not null
)
create table employee(
	empNo int primary key,
	fname varchar(15) not null,
	lname varchar(15) not null,
	job varchar(25) not null,
	hireDate datetime not null,
	salary numeric not null,
	commision numeric null,
	departmentNo int,
	constraint FK_emp_dep foreign key(departmentNo)
		references department(departmentNo) 
)
go

insert into department values(10,'Accounting','Melbourne')
insert into department values(20,'Research','Adealide')
insert into department values(30,'Sales','Sydney')
insert into department values(40,'Operations','Perth')

go


insert into employee values(1,'John', 'Smith', 'Clerk', '17-Dec-1980',800, null ,20)
insert into employee values(2,'Peter', 'Allen', 'Salesman', '20-Feb-1981', 1600 ,300, 30)
insert into employee values(3, 'Kate', 'Ward', 'Salesman', '22-Feb-1981', 1250 ,500, 30)
insert into employee values(4,'Jack', 'Jones', 'Manager', '02-Apr-1981', 2975, null ,20)
insert into employee values(5, 'Joe', 'Martin', 'Salesman', '28-Sep-1981',1250, 1400, 30)


select * from department
select * from employee

