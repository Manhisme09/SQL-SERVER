use master
go
drop database QLBH
create database QLBH
go

use QLBH
go

create table MatHang(
	mahang nchar(10) not null primary key,
	tenhang nvarchar(20),
	soluong int
)
go

create table NhatKyBanHang(
	stt int not null primary key,
	ngay date,
	nguoimua nvarchar(20),
	mahang nchar(10),
	soluong int,
	giaban money,
	constraint FK_nhatkebanhang_mathang foreign key (mahang)
		references MatHang(mahang)
)
go

insert into MatHang values(1,N'Kẹo',100)
insert into MatHang values(2,N'Bánh',200)
insert into MatHang values(3,N'Thuốc',100)
go

insert into NhatKyBanHang values(1,'2/9/1999',N'Nguyễn Đức Mạnh',2,230,50000)
go

delete from MatHang
delete from NhatKyBanHang
select * from MatHang
select * from NhatKyBanHang

--a
create trigger trg_nhatkybanhang_insert
on NhatKyBanHang
for insert
as
	begin
		update MatHang set MatHang.soluong=MatHang.soluong-inserted.soluong
		from MatHang inner join inserted on MatHang.mahang=inserted.mahang
	end
--test
select * from MatHang
select * from NhatKyBanHang
insert into NhatKyBanHang values(2,'2/3/1999',N'Nam',3,50,10000)
select * from MatHang
select * from NhatKyBanHang


