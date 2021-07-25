use master 
go

create database QLBH1
go

use QLBH1
go

create table SanPham(
	masp nchar(10) primary key,
	tensp nvarchar(20),
	soluong int,
	dongia money,
	mausac nchar(5)

)
go

create table Nhap(
	sohdn nchar(10),
	masp nchar(10),
	ngayN nvarchar(20),
	soluongN int,
	dongiaN money,
	constraint PK_nhap primary key (sohdn,masp),
	constraint FK_nhap_sp foreign key (masp)
		references SanPham(masp)
)
go

create table Xuat(
	sohdx nchar(10),
	masp nchar(10),
	ngayX nvarchar(20),
	soluongX int,
	constraint PK_xuat primary key (sohdx,masp),
	constraint FK_xuat_sp foreign key (masp)
		references SanPham(masp)
)
go

insert into SanPham values('SP01',N'Ti vi',15,50000,'do')
insert into SanPham values('SP02',N'Tủ lạnh',35,30000,'do')
insert into SanPham values('SP03',N'Máy giặt',20,10000,'do')
insert into SanPham values('SP04',N'Kem',10,25000,'do')
insert into SanPham values('SP05',N'Áo',25,40000,'do')

insert into Nhap values('HDN01','SP01','2/1/2000',11,20000)
insert into Nhap values('HDN02','SP03','3/1/2000',13,10000)
insert into Nhap values('HDN03','SP01','8/6/2000',22,24000)

insert into Xuat values('HDX01','SP01','7/1/2000',21)
insert into Xuat values('HDX02','SP02','5/1/2000',24)
insert into Xuat values('HDX03','SP04','6/1/2000',15)

select * from SanPham
select * from Nhap
select * from Xuat

delete from Nhap
delete from Xuat
delete from SanPham
--cau2
create proc sp_cau2(@sohdn nchar(10),@masp nchar(10),@soluongN int,@dongiaN money,@kq int output)
as
begin
	 if(not exists(select * from SanPham where masp=@masp))
		set @kq=1
	else
	begin
		set @kq=0
		update Nhap set sohdn=@sohdn,masp=@masp,soluongN=@soluongN,dongiaN=@dongiaN
		where sohdn=@sohdn
	end

	return @kq
end

--test

select * from Nhap
declare @kq int
exec sp_cau2 'HDN01','SP09',30,40000,@kq output
select @kq
select * from Nhap

--test 
select * from Nhap
declare @kq int
exec sp_cau2 'HDN03','SP01',20,50000,@kq output
select @kq
select * from Nhap

--cau3
create trigger trg_cau3
on Nhap
for insert
as
begin 
	declare @dongiaN int
	set @dongiaN = (select dongiaN from inserted )
	if(not exists(select inserted.masp from inserted inner join SanPham on inserted.masp=SanPham.masp))
		begin
			raiserror (N'Không đúng rồi',16,1)
			rollback transaction
		end
	else
		if(@dongiaN>(select dongia from inserted inner join SanPham on inserted.masp=SanPham.masp))
			begin
			raiserror (N'Không đúng rồi',16,1)
			rollback transaction
			end
		else 
			update SanPham set soluong = soluong + inserted.soluongN
			from inserted inner join SanPham on inserted.masp=SanPham.masp
end

--test th loi
select * from SanPham
select * from Nhap
insert into Nhap values('HDN04','SP01','3/2/2001',12,60000)

--test
select * from SanPham
select * from Nhap
insert into Nhap values('HDN05','SP01','3/2/2001',12,20000)
select * from SanPham
select * from Nhap