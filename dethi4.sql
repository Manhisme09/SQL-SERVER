use master
go

create database QLTruongHoc
go

use QLTruongHoc 
go

create table GiaoVien(
	magv nchar(10) primary key,
	tengv nvarchar(30)
)
go

create table Lop(
	malop nchar(10) primary key,
	tenlop nvarchar(30),
	phong int,
	siso int,
	magv nchar(10),
	constraint FK_lop_gv foreign key (magv)
		references GiaoVien(magv)
)
go

create table SinhVien(
	masv nchar(10) primary key,
	tensv nvarchar(30),
	gioitinh nchar(5),
	quequan nvarchar(30),
	malop nchar(10),
	constraint FK_sv_lop foreign key (malop)
		references Lop(malop)
)
go

insert into GiaoVien values('GV01',N'Giáo Viên 1')
insert into GiaoVien values('GV02',N'Giáo Viên 2')
insert into GiaoVien values('GV03',N'Giáo Viên 3')
go
insert into Lop values('L01',N'Tên Lớp 1',504,32,'GV02')
insert into Lop values('L02',N'Tên Lớp 2',304,42,'GV03')
insert into Lop values('L03',N'Tên Lớp 3',302,52,'GV01')
go
insert into SinhVien values('SV01',N'Sinh Viên 1','nam',N'Hà Nội','L02')
insert into SinhVien values('SV02',N'Sinh Viên 2','nu',N'Hà Nội','L01')
insert into SinhVien values('SV03',N'Sinh Viên 3','nam',N'Hà Nam','L02')
insert into SinhVien values('SV04',N'Sinh Viên 4','nu',N'Hà Nội','L03')
insert into SinhVien values('SV05',N'Sinh Viên 5','nam',N'Hà Tây','L01')
go

select * from GiaoVien
select * from Lop
select * from SinhVien

delete from SinhVien
delete from Lop
delete from GiaoVien

--cau2
create function fn_cau2(@tenlop nvarchar(30),@tengv nvarchar(30))
returns @bang table(masv nchar(10),tensv nvarchar(30),gioitinh nchar(5),quequan nvarchar(30))
as
begin
	insert into @bang 
		select masv,tensv,gioitinh,quequan
		from SinhVien inner join Lop on SinhVien.malop=Lop.malop
				inner join GiaoVien on Lop.magv=GiaoVien.magv
		where tengv=@tengv and tenlop=@tenlop
	return
end

--test 
select * from fn_cau2 (N'Tên Lớp 2',N'Giáo Viên 3')

--cau3
create proc sp_cau3(@masv nchar(10),@tensv nvarchar(30),@gioitinh nchar(5),@quequan nvarchar(30),@tenlop nchar(10))
as
begin 
	if(not exists(select tenlop from Lop where tenlop=@tenlop))
		begin
			print N'ten lop khong ton tai'
		end
	else
		begin
			declare @malop nchar(10)
			set @malop = (select malop from Lop where tenlop=@tenlop)
			insert into SinhVien values(@masv,@tensv,@gioitinh,@quequan,@malop)
		end
end

--test loi
exec sp_cau3 'SV06',N'Sinh Viên 6','nam',N'Ba Vì',N'Tên Lớp 5'
--test dung
exec sp_cau3 'SV06',N'Sinh Viên 6','nam',N'Ba Vì',N'Tên Lớp 3'
select * from SinhVien

--cau4
create trigger trg_cau4
on SinhVien
for update
as
begin
		update Lop set siso=siso+1 
		from inserted  inner join Lop on inserted.malop=Lop.malop

		update Lop set siso=siso-1
		from deleted inner join Lop on deleted.malop=Lop.malop
end

--test loi

select * from Lop
select * from SinhVien
update SinhVien set malop='L01'
where masv = 'SV03'

select * from Lop
select * from SinhVien