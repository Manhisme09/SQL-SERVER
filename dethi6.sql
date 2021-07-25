use master
go

create database QLBenhVien3
go

use QLBenhVien3
go

create table BenhNhan(
	mabn nchar(10) primary key,
	tenbn nvarchar(30),
	gioitinh nchar(5),
	sodt nvarchar(30),
	email nvarchar(30)
)
go

create table Khoa(
	makhoa nchar(10) primary key,
	tenkhoa nvarchar(30),
	diachi nvarchar(30),
	tienngay money,
	tongbenhnhan int
)

go

create table HoaDon(
	sohd nchar(10) primary key,
	mabn nchar(10),
	makhoa nchar(10),
	songay int,
	constraint FK_hd_khoa foreign key (makhoa)
		references Khoa(makhoa),
	constraint FK_hd_BenhNhan foreign key (mabn)
		references BenhNhan(mabn)

)
go

insert into BenhNhan values('BN01',N'Bệnh nhân 1','nam','0923124','bn1@gmail.com')
insert into BenhNhan values('BN02',N'Bệnh nhân 2','nu','0432324','bn2@gmail.com')
insert into BenhNhan values('BN03',N'Bệnh nhân 3','nam','06541564','bn3@gmail.com')
go

insert into Khoa values('K01',N'Khoa 1',N'Địa chỉ 1',10000,20)
insert into Khoa values('K02',N'Khoa 2',N'Địa chỉ 2',40000,15)
insert into Khoa values('K03',N'Khoa 3',N'Địa chỉ 3',20000,40)
go

insert into HoaDon values('HD01','BN01','K02',7)
insert into HoaDon values('HD02','BN02','K02',4)
insert into HoaDon values('HD03','BN03','K02',6)
insert into HoaDon values('HD04','BN02','K01',12)
insert into HoaDon values('HD05','BN01','K02',15)
go

select * from BenhNhan
select * from Khoa
select * from HoaDon

delete from HoaDon
delete from Khoa
delete from BenhNhan


--cau2
create function fn_cau2 (@mabn nchar(10))
returns money
as
begin
	declare @tien money
	set @tien =(select sum(tienngay*songay)
				from BenhNhan inner join HoaDon on BenhNhan.mabn=HoaDon.mabn
						inner join Khoa on Khoa.makhoa=HoaDon.makhoa
				where HoaDon.mabn=@mabn
				)
	return @tien
end

--test
select dbo.fn_cau2('BN02') as N'Tong tien'

--cau3
create proc sp_cau3(@sohd nchar(10),@mabn nchar(10),@tenkhoa nvarchar(30),@songay int)
as
begin
	declare @makhoa nchar(10)
	set @makhoa=(select makhoa from Khoa where tenkhoa=@tenkhoa)
	if(not exists(select * from Khoa where tenkhoa=@tenkhoa))
		print N'Ten khoa ko ton tai'
	else
		insert into HoaDon values(@sohd,@mabn,@makhoa,@songay)
end

--test loi
exec sp_cau3 'HD06','BN01',N'Khoa 9',25

--test thanhcong
exec sp_cau3 'HD06','BN01',N'Khoa 3',25
select * from HoaDon

--cau4 
create trigger trg_cau4
on HoaDon
for insert
as
begin
	update Khoa set tongbenhnhan=tongbenhnhan+1
	from Khoa inner join inserted on Khoa.makhoa=inserted.makhoa
end

--

select * from Khoa
select * from HoaDon
insert into HoaDon values('HD07','BN01','K03',10)
select * from Khoa
select * from HoaDon
