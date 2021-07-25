use master
go

create database QLBenhVien
go

use QLBenhVien
go

create table BenhVien(
	mabv nchar(10) not null primary key,
	tenbv nvarchar(20)
)
go

create table KhoaKham(
	makhoa nchar(10) not null primary key,
	tenkhoa nvarchar(20),
	sobenhnhan int,
	mabv nchar(10),
	constraint FK_kk_bv foreign key (mabv)
		references BenhVien(mabv)
)
go

create table BenhNhan(
	mabn nchar(10) not null primary key,
	hoten nvarchar(30),
	ngaysinh nvarchar(20),
	gioitinh nchar(5),
	songaynv int,
	makhoa nchar(10),
	constraint FK_bn_kk foreign key (makhoa)
		references KhoaKham(makhoa)
)
go

insert into BenhVien values('BV01',N'Sóc Sơn')
insert into BenhVien values('BV02',N'Bạch Mai')
go

insert into KhoaKham values('KK01',N'Nội',40,'BV02')
insert into KhoaKham values('KK02',N'Ngoại',70,'BV01')
go

insert into BenhNhan values('BN01',N'Hà','4/2/2001','nu',10,'KK01')
insert into BenhNhan values('BN02',N'Nam','3/5/2000','nu',15,'KK02')
insert into BenhNhan values('BN03',N'Hó','4/2/2005','nam',10,'KK01')
insert into BenhNhan values('BN04',N'Hào','5/2/2002','nu',5,'KK02')
insert into BenhNhan values('BN05',N'Hải','3/2/1990','nam',20,'KK01')
go

select * from BenhVien
select * from KhoaKham
select * from BenhNhan

--cau2
create view vw_cau2
as
	select KhoaKham.makhoa,tenkhoa,count(*) as 'So nguoi'
	from KhoaKham inner join BenhNhan on KhoaKham.makhoa=BenhNhan.makhoa
	where gioitinh = 'nu'
	group by KhoaKham.makhoa,tenkhoa
--
select * from vw_cau2

--cau3
create proc sp_cau3(@makhoa nchar(10))
as
begin
	select KhoaKham.makhoa,tenkhoa,sum(songaynv*80000) as 'Tong Tien'  
	from KhoaKham inner join BenhNhan on KhoaKham.makhoa=BenhNhan.makhoa
	where KhoaKham.makhoa='KK01'
	group by KhoaKham.makhoa,tenkhoa
end
--test
exec sp_cau3 'KK01'
exec sp_cau3 'KK02'

--cau4
create trigger trg_cau4
on BenhNhan
for insert
as
begin
	 declare @sobn int
	 set @sobn =(select sobenhnhan from KhoaKham inner join inserted on KhoaKham.makhoa=inserted.makhoa)
	 if(@sobn>100)
	  begin
		raiserror(N'so benh nhan qua 100',16,1)
		rollback transaction
	  end	
	else
		update KhoaKham set sobenhnhan=sobenhnhan+1
		from KhoaKham inner join inserted on  KhoaKham.makhoa=inserted.makhoa
end

select * from KhoaKham
select * from BenhNhan
insert into BenhNhan values('BN06',N'Hảiaaa','3/2/1990','nam',20,'KK01')
insert into BenhNhan values('BN07',N'Hảiaabba','3/2/1990','nam',25,'KK01')
select * from KhoaKham
select * from BenhNhan