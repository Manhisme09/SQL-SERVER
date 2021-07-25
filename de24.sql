use master 
go

create database QLDA
go

use QLDA
go

create table NhanVien(
	manv nchar(10) primary key,
	tennv nvarchar(20),
	gioitinh nchar(5),
	hesoluong int,
)
go
create table DuAn(
	mada nchar(10) primary key,
	tenda nvarchar(20),
	ngaybatdau nchar(20),
	soluongnv int
)
go
create table ThamGia(
	manv nchar(10),
	mada nchar(10),
	nhiemvu nvarchar(20),
	constraint PK_tg primary key(manv,mada),
	constraint FK_tg_da foreign key (mada)
		references DuAn(mada),
	constraint FK_tg_nv foreign key (manv)
	references NhanVien(manv)
)
go
insert into NhanVien values('nv01',N'A','nam',4)
insert into NhanVien values('nv02',N'B','nu',2)
insert into NhanVien values('nv03',N'C','nam',6)

insert into DuAn values('da01','Q+','3/2/2001',33)
insert into DuAn values('da02','W+','5.2/2001',20)
insert into DuAn values('da03','E+','3/6/2001',43)

insert into ThamGia values('nv01','da01','O')
insert into ThamGia values('nv01','da02','P')
insert into ThamGia values('nv01','da03','I')
insert into ThamGia values('nv02','da01','L')
insert into ThamGia values('nv03','da01','K')
insert into ThamGia values('nv02','da02','J')
insert into ThamGia values('nv03','da03','M')

select * from NhanVien
select * from DuAn
select * from ThamGia
delete from ThamGia
delete from DuAn
delete from NhanVien
--cau1
create proc sp_cau1(@manv nchar(10),@hsl int)
as
begin
	if(@hsl<(select hesoluong from NhanVien where manv=@manv) or not exists(select * from NhanVien where manv=@manv))
		print 'khong hop le'
	else
		update NhanVien set hesoluong=@hsl,manv=@manv
		where manv=@manv
end

select * from NhanVien
execute sp_cau1 'nv04',10
execute sp_cau1 'nv02',1
execute sp_cau1 'nv03',7

--cau2
create trigger trg_cau2
on ThamGia
for insert
as
begin
	if((select hesoluong from inserted inner join NhanVien on inserted.manv=NhanVien.manv)<2.34)
		begin
		raiserror(N'hsl khong hop le',16,1) 
		rollback transaction
		end
	else
		update DuAn set soluongnv=soluongnv+1
		from DuAn inner join inserted on DuAn.mada=inserted.mada
end
select * from NhanVien
select * from DuAn
select * from ThamGia
insert into ThamGia values('nv03','da02','O')
select * from NhanVien
select * from DuAn
select * from ThamGia