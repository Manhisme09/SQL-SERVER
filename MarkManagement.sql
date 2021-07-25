use master 
go
create database MarkManagement
on primary(
	name = 'MarkManagement_dat',
	filename = 'D:\MarkManagement.mdf',
	size = 10MB,
	maxsize = 50MB,
	filegrowth = 10MB
)
log on(
	name = 'MarkManagement_log',filename = 'D:\MarkManagement.ldf',
	size = 2MB, maxsize = 5MB, filegrowth=20%

)
go
use MarkManagement
go
create table students(
	studentID nvarchar(12) primary key,
	studentName nvarchar(25) not null,
	dateofBirth datetime not null,
	email nvarchar(40),
	phone nvarchar(12),
	class nvarchar(10)
)
create table subjects(
	subjectID nvarchar(10) primary key,
	subjectName nvarchar(25) not null
)
create table mark(
	studentID nvarchar(12),
	subjectID nvarchar(10),
	theory tinyint,
	practical tinyint,
	date datetime,
	constraint PK_mark primary key(studentID,subjectID),
	constraint FK_mark_subjects foreign key(subjectID)
		references subjects(subjectID), 
	constraint fK_mark_students foreign key(studentID)
		references students(studentID), 
)
go

insert into students values('AV0807005',N'Mai Trung Hiếu','11/10/1989','trunghieu@yahoo.com','0904115116','AV1')
insert into students values('AV0807006',N'Nguyễn Quý Hùng','2/12/1988','quyhung@yahoo.com','0955667787','AV2')
insert into students values('AV0807007',N'Đỗ Đắc Huỳnh','2/1/1990','dachuynh@yahoo.com','0988574747','AV2')
insert into students values('AV0807009',N'An Đăng Khuê','6/3/1986','dangkhue@yahoo.com','0986757463','AV1')
insert into students values('AV0807010',N'Nguyễn T. Tuyết Lan','12/7/1989','tuyetlan@yahoo.com','0983310342','AV2')
insert into students values('AV0807011',N'Đinh Phụng Long','2/12/1990','phunglong@yahoo.com','','AV1')
insert into students values('AV0807012',N'Nguyễn Tuấn Nam','2/3/1990','tuannam@yahoo.com','','AV1')

go

insert into subjects values('S001','SQL')
insert into subjects values('S002','Java Simplefield')
insert into subjects values('S003','Active Server Page')

go

insert into mark values('AV0807005','S001',8,25,'6/5/2008')
insert into mark values('AV0807006','S002',16,30,'6/5/2008')
insert into mark values('AV0807007','S001',10,25,'6/5/2008')
insert into mark values('AV0807009','S003',7,13,'6/5/2008')
insert into mark values('AV0807010','S003',9,16,'6/5/2008')
insert into mark values('AV0807011','S002',8,30,'6/5/2008')
insert into mark values('AV0807012','S001',7,31,'6/5/2008')
insert into mark values('AV0807005','S002',12,11,'6/6/2008')
insert into mark values('AV0807007','S003',11,20,'6/6/2008')
insert into mark values('AV0807010','S001',7,6,'6/6/2008')


go

select * from students
select * from subjects
select * from mark



