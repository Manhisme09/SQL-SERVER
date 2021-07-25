use master
go

create database QLSinhViend1
go

use QLSinhViend1
go

create table Khoa(
	makhoa nchar(10) not null primary key,
	tenkhoa nvarchar(20)

)
go

create table Lop(
	malop nchar(10) not null primary key,
	tenlop nvarchar(20),
	siso int,
	makhoa nchar(10),
	constraint FK_lop_khoa foreign key (makhoa)
		references Khoa(makhoa)
)
go

create table SinhVien(
	masv nchar(10) not null primary key,
	hoten nvarchar(30),
	ngaysinh nvarchar(20),
	gioitinh nchar(5),
	malop nchar(10),
	constraint FK_sv_lop foreign key (malop)
		references Lop(malop)
)
go

insert into Khoa values('K01','CNTT')
insert into Khoa values('K02',N'Du Lịch')
go
insert into Lop values('L01','HTTT01',35,'K01')
insert into Lop values('L02',N'Du Lịch02',70,'K02')
go
insert into SinhVien values('SV01',N'Nguyễn Đức Nam','2/4/2001','nam','L01')
insert into SinhVien values('SV02',N'Nguyễn Kim Nam','5/1/2000','nam','L02')
insert into SinhVien values('SV03',N'Nguyễn Văn Nam','5/5/2002','nu','L01')
insert into SinhVien values('SV04',N'Nguyễn Khoai Nam','6/4/2001','nam','L02')
insert into SinhVien values('SV05',N'Nguyễn Củ Nam','5/1/2001','nu','L02')
go

select * from Khoa
select * from Lop
select * from SinhVien

--cau2
create function fn_cau2(@tenkhoa nchar(10))
returns @bang table(masv nchar(10),hoten nvarchar(30),tuoi int)
as
begin
	insert into @bang
		select masv,hoten,YEAR(GETDATE())-YEAR(ngaysinh)
		from SinhVien inner join Lop on SinhVien.malop=Lop.malop
					inner join Khoa on Khoa.makhoa=Lop.makhoa
		where tenkhoa=@tenkhoa
	return
end
--test
select * from fn_cau2('CNTT')
select * from fn_cau2(N'Du Lịch')

--cau 3
create proc sp_cau3(@x int,@y int)
as
begin
	select masv,hoten,ngaysinh,gioitinh,tenlop,tenkhoa,YEAR(GETDATE())-YEAR(ngaysinh) as 'tuoi'
	from SinhVien inner join Lop on SinhVien.malop=Lop.malop
					inner join Khoa on Khoa.makhoa=Lop.makhoa
	where YEAR(GETDATE())-YEAR(ngaysinh) between @x and @y
end
exec sp_cau3 10,20

--cau4
create trigger trg_cau4
on SinhVien
for insert
as
begin
	declare @ss int
	set @ss = (select siso from Lop inner join inserted on Lop.malop=inserted.malop)
	if(@ss>80)
		begin
			raiserror(N'Si so qua 80 hoc sinh',16,1)
			rollback transaction
		end
	else
		update Lop set siso=siso+1
		from Lop inner join inserted on Lop.malop=inserted.malop
		
end

select * from Lop
select * from SinhVien
insert into SinhVien values('SV06',N'Nguyễn Thị Ê','4/2/1999',N'nữ','L02')
select * from Lop
select * from SinhVien