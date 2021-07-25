use master
go

create database QLKHO7
go

use QLKHO7
go

create table Ton(
	mavt nchar(10) primary key,
	tenvt nvarchar(20),
	soluongT int
)
go

create table Nhap(
	sohdn nchar(10),
	mavt nchar(10),
	soluongN int,
	dongiaN money,
	ngayN date,
	constraint PK_nhap primary key(sohdn,mavt),
	constraint FK_nhap_ton foreign key(mavt)
		references Ton(mavt)

)
go

create table Xuat(
	sohdx nchar(10),
	mavt nchar(10),
	soluongX int,
	dongiaX money,
	ngayX date,
	constraint PK_xuat primary key(sohdx,mavt),
	constraint FK_xuat_ton foreign key(mavt)
		references Ton(mavt)
)
go

insert into Ton values('VT01',N'Bút bi',25)
insert into Ton values('VT02',N'Máy tính',20)
insert into Ton values('VT03',N'Cặp',15)
insert into Ton values('VT04',N'Điện thoại',5)

insert into Nhap values('HDN01','VT01',15,15000,'05/03/2021')
insert into Nhap values('HDN02','VT03',35,25000,'05/05/2021')
insert into Nhap values('HDN03','VT02',26,150000,'05/06/2021')
go

insert into Xuat values('HDX01','VT01',5,11000,'05/02/2021')
insert into Xuat values('HDX02','VT02',2,14000,'05/01/2021')
insert into Xuat values('HDX03','VT04',7,7000,'02/02/2021')
go

select * from Ton
select * from Nhap
select * from Xuat

--cau2
create function fn_cau2(@ngayX date,@mavt nchar(10))
returns @bang table (mavt nchar(10),tenvt nvarchar(20),tienban money)
as
begin
	insert into @bang
	select Ton.mavt,tenvt,sum(soluongX*dongiaX)
	from Ton inner join Xuat on Ton.mavt=Xuat.mavt
	where ngayX=@ngayX and Ton.mavt=@mavt
	group by Ton.mavt,tenvt

	return
end

--test
select * from fn_cau2('2021/02/02','VT04')

--cau3
create proc sp_cau3(@sohdx nchar(10),@mavt nchar(10),@soluongX int,@dongiaX money,@ngayX date,@kq int output)
as
begin
	if(not exists(select * from Ton where mavt=@mavt))
		set @kq =1
	else
	begin
		set @kq=0
		insert into Xuat values(@sohdx,@mavt,@soluongX,@dongiaX,@ngayX)
	end
end

--test TH mavt khong ton tai
declare @kq int
exec sp_cau3 'HDX04','VT09',13,40000,'03/01/2021',@kq output
select @kq
--test TH dung
declare @kq int
exec sp_cau3 'HDX04','VT02',13,40000,'03/01/2021',@kq output
select @kq
select * from Xuat

--cau4
create trigger trg_cau4
on Nhap
for insert
as
begin
	if(not exists(select * from inserted inner join Ton on inserted.mavt=Ton.mavt))
		begin
			raiserror(N'mavt khong ton tai',16,1)
			rollback transaction
		end
	else
		begin
		update Ton
		set soluongT = soLuongT + soLuongN
		from inserted inner join Ton on Ton.mavt=inserted.mavt
		end
end

--test TH mavt khong ton tai
insert into Nhap values('HDN06','VT09',5,100000,'03/02/2021')

--test TH dung
select * from Ton
insert into Nhap values('HDN06','VT03',5,100000,'03/02/2021')
select * from Nhap
select * from Ton
