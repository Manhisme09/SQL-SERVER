use master
go

create database QLBanHang2

go

use QLBanHang2

go
--a.create table
create table VatTu(
	MaVT nvarchar(10) not null primary key,
	TenVT nvarchar(50),
	DVTinh nvarchar(20),
	SLCon int default 0
)
create table HoaDon(
	MaHD nvarchar(10) not null primary key,
	NgayLap date,
	HoTenKhach nvarchar(50)
)

create table CTHoaDon(
	MaHD nvarchar(10) not null,
	MaVT nvarchar(10) not null,
	DonGiaBan money default 0,
	SLBan int default 0,
	constraint VT_CTHD foreign key(MaVT) references VatTu(MaVT),
	constraint HD_CTHD foreign key(MaHD) references HoaDon(MaHD),
	constraint fk_CTHD primary key(MaHD, MaVT)
)

go

--b. insert data
insert into VatTu values('VT01', N'Xi măng Thăng Long', N'Bao 50kg', 200),
						('VT02', N'Xi măng trắng', N'Bao 50kg', 350),
						('VT03', N'Cát vàng', N'Khối', 100)
insert into HoaDon values('HD01', '4/22/2020', N'Phạm Thanh Nam'),
						 ('HD02', '4/12/2020', N'Hòa Văn B'),
						 ('HD03', '5/01/2020', N'Ngô Thị La')
insert into CTHoaDon values('HD01', 'VT01', 65000, 25),
							('HD01', 'VT02', 85000, 10),
							('HD02', 'VT02', 85000, 21),
							('HD03', 'VT01', 65000, 30),
							('HD03', 'VT03', 20000, 10)
go

--test
select * from VatTu
select * from HoaDon
select * from CTHoaDon
delete from CTHoaDon
delete from VatTu
delete from HoaDon
go

--cau4
create trigger trg_cau4
on CTHoaDon
for delete
as
begin
	declare @mavt nvarchar(10)
	declare @mahd nvarchar(10)
	select @mahd = MaHD from deleted
	select @mavt=MaVT from deleted
	if((select count(*) from CTHoaDon)=0)
		begin
			raiserror(N'Day la dong duy nhat cua hoa don',16,1)
			rollback transaction
		end
	else
		update  VatTu set SLCon=SLCon+SLBan
		from VatTu inner join deleted on VatTu.MaVT=deleted.MaVT
		
end

--test 
select * from VatTu
select * from CTHoaDon
delete from CTHoaDon where MaHD='HD07'and MaVT='VT05'
select * from VatTu
select * from CTHoaDon