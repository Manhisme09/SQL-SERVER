use master
go

create database QLXe
go

use QLXe
go

create table Xe(
	maxe nchar(10) primary key,
	tenxe nvarchar(30),
	soluong int
)
go
create table KhachHang(
	makh nchar(10) primary key,
	tenkh nvarchar(30),
	diachi nvarchar(30),
	sodt int,
	email nvarchar(30)
)
go
create table ThueXe(
	sohd nchar(10) primary key,
	makh nchar(10),
	maxe nchar(10),
	songaythue int,
	soluongthue int,
	constraint FK_tx_kh foreign key (makh)
		references KhachHang(makh),
	constraint FK_tx_xe foreign key (maxe)
		references Xe(maxe)
)
go

insert into Xe values('X01',N'Xe Máy',15)
insert into Xe values('X02',N'Xe Đạp',25)
insert into Xe values('X03',N'Xe Điện',35)
go

insert into KhachHang values('KH01',N'Khách Hàng 1',N'Hà Nội','09312212','manh99@gmail.com')
insert into KhachHang values('KH02',N'Khách Hàng 2',N'Hà Nam','09955554','nam@gmail.com')
insert into KhachHang values('KH03',N'Khách Hàng 3',N'Hà Nội','08461534','hai111@gmail.com')
go

insert into ThueXe values('HD01','KH01','X02',7,10)
insert into ThueXe values('HD02','KH02','X02',5,20)
insert into ThueXe values('HD03','KH03','X02',11,30)
insert into ThueXe values('HD04','KH02','X03',14,13)
insert into ThueXe values('HD05','KH01','X01',16,14)
go

select * from Xe
select * from KhachHang
select * from ThueXe

delete from ThueXe
delete from Xe
delete from KhachHang

--cau2

create function fn_cau2(@diachi nvarchar(30))
returns int
as
begin
	declare @tongxe int
	set @tongxe =(select sum(soluongthue)
					from KhachHang inner join ThueXe on KhachHang.makh=ThueXe.makh
					where diachi=@diachi
					)
	return @tongxe
end

--test
select dbo.fn_cau2(N'Hà Nội') as N'Tổng số xe'

--cau3

create proc sp_cau3(@sohd nchar(10),@makh nchar(10),@maxe nchar(10),@songaythue int,@soluongthue int,@kq int output)
as
begin
	if(not exists(select * from KhachHang where makh=@makh))	
			set @kq =1		
	else
		if(not exists(select * from Xe where maxe=@maxe))			
				set @kq =2							
	else
		begin
			set @kq =0
			insert into ThueXe values(@sohd,@makh,@maxe,@songaythue,@soluongthue)
		end
end

--test loi
declare @kq int
exec sp_cau3 'HD06','KH09','X02',14,22,@kq output
select @kq
--test loi
declare @kq int
exec sp_cau3 'HD06','KH02','X09',14,22,@kq output
select @kq
--test loi
declare @kq int
exec sp_cau3 'HD06','KH02','X01',14,22,@kq output
select @kq
select * from ThueXe

--cau4
create trigger tg_cau4
on ThueXe
for insert
as
begin
	declare @soluongthue int
	declare @soluong int
	set @soluong =(select soluong from Xe inner join inserted on Xe.maxe=inserted.maxe)
	set @soluongthue = (select soluongthue from inserted)
	if(@soluong<@soluongthue)
		begin
			raiserror(N'so luong ko du',16,1)
			rollback transaction
		end
	else
		update Xe set soluong=soluong-inserted.soluongthue
		from Xe inner join inserted on Xe.maxe=inserted.maxe
end

--test loi
insert into ThueXe values('HD07','KH03','X03',20,50)
select * from Xe
select * from ThueXe
--test
select * from Xe
select * from ThueXe
insert into ThueXe values('HD07','KH03','X03',20,10)
select * from Xe
select * from ThueXe