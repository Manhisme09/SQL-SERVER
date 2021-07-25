use master
go

create database QLbanhangd3
go

use QLbanhangd3
go

create table CongTy(
	mact nchar(10) not null primary key,
	tenct nvarchar(20),
	trangthai nvarchar(20),
	thanhpho nvarchar(20)
)
go

create table SanPham(
	masp nchar(10) not null primary key,
	tensp nvarchar(20),
	mausac nchar(10),
	soluong int,
	giaban money
)
go

create table CungUng(
	mact nchar(10),
	masp nchar(10),
	soluongcungung int,
	ngaycungung nvarchar(20)
	constraint PK_cungung primary key (mact,masp),
	constraint FK_mot foreign key (mact)
		references CongTy(mact),
	constraint FK_hai foreign key (masp)
		references SanPham(masp)

)
go

insert into CongTy values('CT01','SamSung',N'tốt',N'Hà Nội')
insert into CongTy values('CT02','Nokia',N'kém',N'Ba Vì')
insert into CongTy values('CT03','Crucial',N'tốt',N'Đà Nẵng')

insert into SanPham values('SP01',N'tủ lạnh',N'đỏ',20,30000)
insert into SanPham values('SP02',N'tủ kem',N'vàng',40,60000)
insert into SanPham values('SP03',N'máy xay',N'đen',15,50000)

insert into CungUng values('CT01','SP02',6,'8/2/2000')
insert into CungUng values('CT02','SP03',2,'5/6/1999')
insert into CungUng values('CT01','SP03',5,'4/2/2000')
insert into CungUng values('CT03','SP02',7,'5/1/2000')
insert into CungUng values('CT03','SP03',8,'5/6/2000')

select * from CongTy
select * from SanPham
select * from CungUng

delete from CungUng
delete from SanPham
delete from CongTy
--cau2
create function fn_cau2(@tenct nvarchar(20),@ngaycungung nvarchar(20))
returns @bang table(tensp nchar(10),mausac nchar(10),soluong int,giaban money)
as
begin 
	insert into @bang
		select tensp,mausac,soluong,giaban
		from CongTy inner join CungUng on CongTy.mact=CungUng.mact
				inner join SanPham on SanPham.masp=CungUng.masp
		where tenct=@tenct and ngaycungung=@ngaycungung
	return 
end

--
select * from fn_cau2('Crucial','5/6/2000')

--cau3
create proc sp_cau3(@mact nchar(10),@tenct nvarchar(20),@trangthai nvarchar(20),@diachi nvarchar(20),@bien int output)
as
begin
	 if(exists(select tenct from CongTy where tenct=@tenct))
		set @bien = 1	
	 else
		begin
		set @bien = 0 
		insert into CongTy values(@mact,@tenct,@trangthai,@diachi)
		end
	return @bien
	
end
--test
declare @kq int
exec sp_cau3 'CT06','SamSung',N'tốt1',N'Hà Nội1',@kq output
select @kq
if(@kq=0)
begin
select * from CongTy
end
--select * from CongTy
--cau4
create trigger trg_cau4
on CungUng
for update
as
begin
	declare @slmoi int
	declare @slcu int
	set @slmoi = (select soluongcungung from inserted )
	set @slcu = (select soluongcungung  from deleted )
	if((@slmoi-@slcu)>(select soluong from SanPham inner join inserted on SanPham.masp=inserted.masp))
		begin
		raiserror(N'Khong du',16,1)
		rollback transaction 
		end
	else
		update SanPham set soluong = soluong -(@slmoi-@slcu)
		from SanPham inner join inserted on SanPham.masp=inserted.masp
end

--test
select * from SanPham
select * from CungUng
update CungUng set soluongcungung = 15
where   mact = 'CT03' and masp = 'SP02'
select * from SanPham
select * from CungUng