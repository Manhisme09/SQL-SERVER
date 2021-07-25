use master
go
create database QLKHO
on primary(
	name = 'QLKHO_dat',
	filename = 'D:\QLKHO.mdf',
	size = 10MB,
	maxsize = 50MB,
	filegrowth = 10MB
)
log on(
	name = 'QLKHO_log',filename = 'D:\QLKHO.ldf',
	size = 2MB,maxsize = 5MB,filegrowth = 20%
)
go

use QLKHO
go

create table ton(
	mavt nvarchar(15) not null primary key,
	tenvt nvarchar(20) not null,
	soluongT int , 
)
go

create table nhap(
	sohdn nchar(10) not null,
	mavt nvarchar(15) not null,
	soluongN int,
	dongiaN money,
	ngayN date,
	constraint PK_nhap primary key(sohdn,mavt),
	constraint FK_nhap_ton foreign key(mavt)
		references ton(mavt) 
) 
go

create table xuat(
	sohdx nchar(10) not null,
	mavt nvarchar(15) not null,
	soluongX int,
	dongiaX money,
	ngayX date,
	constraint PK_xuat primary key(sohdx,mavt),
	constraint FK_xuat_ton foreign key(mavt)
		references ton(mavt)
)
go


insert into ton values('VT01',N'tủ lạnh',5)
insert into ton values('VT02',N'ti vi',7)
insert into ton values('VT03',N'máy giặt',10)
insert into ton values('VT04',N'laptop',7)
insert into ton values('VT05',N'đồng hồ',6)
go

insert into nhap values('N01','VT02',3,'5000000','03-12-2020')
insert into nhap values('N02','VT04',2,'2000000','01-04-2020')
insert into nhap values('N03','VT05',3,'6000000','06-12-2020')
go

insert into xuat values('X01','VT01',2,'4000000','04-11-2020')
insert into xuat values('X02','VT04',1,'1000000','06-09-2020')
go


select * from ton

select * from nhap

select * from xuat
delete from ton
delete from xuat
delete from nhap