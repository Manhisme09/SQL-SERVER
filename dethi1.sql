use master
go

create database QLBenhVien2
go

use QLBenhVien2
go

create table BenhVien(
	mabv nchar(10) not null primary key,
	tenbv nvarchar(30)
)
go

create table KhoaKham(
	makhoa nchar(10) not null primary key,
	tenkhoa nvarchar(30),
	sobenhnhan int,
	mabv nchar(10),
	constraint FK_kk_bv foreign key (mabv)
		references BenhVien (mabv)
)
go

create table BenhNhan(
	mabn nchar(10) not null primary key,
	hoten nvarchar(30),
	gioitinh nchar(5),
	songaynv int,
	makhoa nchar(10),
	constraint FK_bn_kk foreign key (makhoa)
		references KhoaKham (makhoa)
)
go

insert into BenhVien values('BV01',N'Sóc Sơn')
insert into BenhVien values('BV02',N'Bạch Mai')
insert into BenhVien values('BV03',N'Đà Nẵng')
go

insert into KhoaKham values('KK01',N'Nội',101,'BV02')
insert into KhoaKham values('KK02',N'Ngoại',27,'BV01')
insert into KhoaKham values('KK03',N'Răng',50,'BV02')


go

insert into BenhNhan values('BN01',N'Hà','nu',10,'KK01')
insert into BenhNhan values('BN02',N'Nam','nu',15,'KK02')
insert into BenhNhan values('BN03',N'Hóa','nam',12,'KK01')
insert into BenhNhan values('BN04',N'Hào','nu',5,'KK02')
insert into BenhNhan values('BN05',N'Hải','nam',20,'KK01')
go

select * from BenhVien
select * from KhoaKham
select * from BenhNhan

delete from BenhNhan
delete from KhoaKham
delete from BenhVien

--cau2
create function fn_cau2(@gt nchar(5))
returns @bang table(tenbv nvarchar(30),tongsobn int)
as
begin
	insert into @bang
		select BenhVien.tenbv,count(*)
		from BenhNhan inner join KhoaKham on BenhNhan.makhoa=KhoaKham.makhoa
						inner join BenhVien on BenhVien.mabv=KhoaKham.mabv
		where gioitinh= @gt	
		group by BenhVien.tenbv
	return			 
end

--test
select * from fn_cau2('nu')

--cau3
create proc sp_cau3(@tenkhoa nvarchar(30),@tenbv nvarchar(30))
as
begin
	if(not exists(select * from BenhVien inner join KhoaKham on BenhVien.mabv=KhoaKham.mabv 
							where tenbv=@tenbv and tenkhoa=@tenkhoa))
		print N'khong phu hop'
	else
		select sum(sobenhnhan) as N'tongsobn'
		from BenhVien inner join KhoaKham on BenhVien.mabv=KhoaKham.mabv
		where tenbv=@tenbv and tenkhoa=@tenkhoa
end

--test
exec sp_cau3 N'aa',N'Bạch Mai'

--cau4

create trigger trg_cau4
on BenhNhan
for insert
as
begin
	if((select sobenhnhan from KhoaKham inner join inserted on KhoaKham.makhoa=inserted.makhoa)>100)
		begin
			declare @notification nvarchar(100)
			set @notification = N'Không thể thêm  ' 
			raiserror(@notification, 16, 1)
			rollback transaction
		end
	else
		begin
			update KhoaKham set sobenhnhan=sobenhnhan+1
			from KhoaKham inner join inserted on KhoaKham.makhoa=inserted.makhoa
		end
end

--test
select * from KhoaKham
select * from BenhNhan
insert into BenhNhan values('BN06',N'Hảiaaa','nam',20,'KK02')
select * from KhoaKham
select * from BenhNhan