use master
go
create database QLSV
on primary(
	name = 'QLSV_dat',
	filename = 'D:\QLSV.mdf',
	size = 10MB,
	maxsize = 50MB,
	filegrowth = 10MB
)
log on(
	name = 'QLSV_log',
	filename = 'D:\QLSV.ldf',
	size = 2MB,
	maxsize = 5MB,
	filegrowth = 20%
)
go

use QLSV
go

create table lop(
	malop nchar(10) not null primary key,
	tenlop nvarchar(20) not null,
	phong nvarchar(20)

)
go

create table sv(
	masv nchar(10) not null primary key,
	tensv nvarchar(25) not null,
	malop nchar(10),
	constraint FK_sv_lop foreign key(malop)
		references lop(malop)
)
go


insert into lop values('1','CD','1')
insert into lop values('2','DH','2')
insert into lop values('3','LT','2')
insert into lop values('4','CH','4')

insert into sv values('1','A','1')
insert into sv values('2','B','2')
insert into sv values('3','C','1')
insert into sv values('4','D','3')

select * from lop
select * from sv