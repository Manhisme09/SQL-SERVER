use master
go
create database QLbanhang1
go
use QLbanhang1
go
create table sanpham(
masp nchar(30) not null primary key,
tensp nchar(30) ,
mausac nchar(10),
soluong int,
giaban money
)
create table congty(
mact nchar(30) not null primary key,
tenct nchar(30) ,
trangthai nchar(30),
thanhpho nchar(30)
)
create table cungung(
mact nchar(30) not null,
masp nchar(30) not null,
soluongcungung int,
constraint PK_cungung primary key (mact,masp),
constraint FK_sanpham_cungung foreign key (masp) references sanpham(masp),
constraint FK_congty_cungung foreign key (mact) references congty(mact)
)
-----
insert into sanpham values (N'SP01',N'thuoc',N'xanh',30,200000)
insert into sanpham values (N'SP02',N'thuoc la',N'xanh la',40,400000)
insert into sanpham values (N'SP03',N'thuoc phien',N'xanh lam',10,500000)
-----
insert into congty values (N'CT01',N'Thang long',N'online',N'Hanoi')
insert into congty values (N'CT02',N'Dong do',N'offline',N'Hanoi')
insert into congty values (N'CT03',N'Hoa sen',N'overline',N'Hanoi')
-----
insert into cungung values(N'CT01',N'SP01',15)
insert into cungung values(N'CT01',N'SP02',25)
insert into cungung values(N'CT02',N'SP01',10)
insert into cungung values(N'CT03',N'SP01',12)
insert into cungung values(N'CT02',N'SP03',21)
---
select*from sanpham
select*from congty
select*from cungung
delete from cungung
delete from congty
delete from sanpham
--cau2
create proc sp_cau2(@masp nchar(30))
as
begin
	if(not exists(select * from sanpham where masp=@masp))
		print N'Khong ton tai ma san pham'
	else
		if((select soluong from sanpham where masp=@masp)>10)
			print N'Khong duoc xoa san pham nay'
		else
			delete from cungung 
			where masp=@masp
			delete from sanpham
			where masp=@masp
			delete from congty
			where mact=(select mact from cungung where masp=@masp)
end
--test
exec sp_cau2 'SP03'
select*from sanpham
--cau3
create trigger trg_cau3
on cungung
for insert
as
begin
	declare @slcu int
	select @slcu= soluongcungung from inserted
	if(@slcu>(select soluong from inserted inner join sanpham on inserted.masp=sanpham.masp)) 
		begin
		raiserror (N'khong thoa man',16,1)
		rollback transaction
		end
	else
		update sanpham set soluong=soluong-@slcu
		from sanpham inner join inserted on sanpham.masp=inserted.masp

end
--test
select * from sanpham
select*from cungung
insert into cungung values(N'CT03',N'SP02',5)
select * from sanpham
select*from cungung