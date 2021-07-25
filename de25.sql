use master
go
create database QLSinhVien
go

use QLSinhVien
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
		references khoa(makhoa)
)
go
create table SinhVien(
	masv nchar(10) not null primary key,
	hoten nvarchar(20),
	ngaysinh nvarchar(20),
	gioitinh nchar(5),
	malop nchar(10),
	constraint FK_sv_lop foreign key (malop)
		references lop(malop)

)
go

insert into Khoa values('K01','CNTT')
insert into Khoa values('K02','English')

insert into Lop values('L01','HTTT',30,'K01')
insert into Lop values('L02','TACB',82,'K02')

insert into SinhVien values('SV01',N'Nguyễn Văn A','3/4/2000',N'nam','L01')
insert into SinhVien values('SV02',N'Nguyễn Thị B','1/2/2001',N'nữ','L02')
insert into SinhVien values('SV03',N'Nguyễn Băn C','3/2/1999',N'nam','L02')
insert into SinhVien values('SV04',N'Nguyễn Thị D','1/4/1822',N'nữ','L01')
insert into SinhVien values('SV05',N'Nguyễn Thị E','4/2/1833',N'nữ','L02')
delete from SinhVien

delete from Lop
delete from Khoa

select * from Khoa
select * from Lop
select * from SinhVien
--cau1
create proc sp_cau1(@x int,@y int)
as
begin 
		select masv,hoten,ngaysinh,tenlop,tenkhoa
		from SinhVien inner join Lop on SinhVien.malop=Lop.malop
						inner join Khoa on Khoa.makhoa=Lop.makhoa
		where YEAR(GETDATE())-YEAR(ngaysinh) between @x and @y
end

exec sp_cau1 19,23
--cau2
create trigger trg_cau2
on SinhVien
for insert
as
begin
	declare @ss int
	select @ss=siso from Lop inner join inserted on Lop.malop=inserted.malop
	if(@ss>80)
		begin
			raiserror(N'Sĩ số quá 80',16,1)
			rollback transaction
		end
	else
		update Lop set Lop.siso=Lop.siso+1
		from Lop inner join inserted on Lop.malop=inserted.malop
end

select * from Lop
select * from SinhVien
insert into SinhVien values('SV06',N'Nguyễn Thị Ê','4/2/1999',N'nữ','L02')
select * from Lop
select * from SinhVien

insert into SinhVien values('SV07',N'Nguyễn Thị Q','4/2/1999',N'nữ','L01')
insert into SinhVien values('SV08',N'Nguyễn Thị W','4/2/1999',N'nữ','L01')
select * from Lop
select * from SinhVien