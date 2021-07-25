create proc sp_them_nhan_vien(@manv nvarchar(4),@macv nvarchar(2),@tennv nvarchar(30),@ngaysinh datetime,@luongcanban float,@ngaycong int,@phucap float)
as
	begin
		if(not exists(select macv from chucvu where macv=@macv))
			print N'Mã chức vụ' + N'không tồn tại'
		else
			insert into nhanvien values(@manv,@macv,@tennv,@ngaysinh,@luongcanban,@ngaycong,@phucap)
	end
----
exec sp_them_nhan_vien 'NV06','KT',N'Nguyễn Đức Nam','2/9/1999',300000,25,100000
exec sp_them_nhan_vien 'NV07','KA',N'Nguyễn Đức Hải','2/9/1999','300000','25','100000'
select * from nhanvien
-------------------------------------------------------------------------
create proc sp_luongln()
as
	begin
		declare @kq float

--------------------------------------------------------------------------
create proc sp_them_nhan_vien2(@manv nvarchar(4),@macv nvarchar(2),
								 @tennv nvarchar(30),@ngaysinh datetime,
								 @luongcanban float,@ngaycong int,
								 @phucap float,@kq int output)
as
	begin
		if(not exists(select macv from chucvu where macv=@macv))
			set @kq = 1
		else
			insert into nhanvien values(@manv,@macv,@tennv,@ngaysinh,@luongcanban,@ngaycong,@phucap)		return @kq	end----declare @error intexec sp_them_nhan_vien2 'NV08','VS',N'Nguyễn Hải','2/9/1999','300000','25','100000',@error outputselect @error
select * from nhanvien
----------------------------------------------------------------------------------
create proc sp_them_nhan_vien3(@manv nvarchar(4),@macv nvarchar(2),
								 @tennv nvarchar(30),@ngaysinh datetime,
								 @luongcanban float,@ngaycong int,
								 @phucap float,@kq int output)
as
	begin
		if(exists(select manv from nhanvien where manv=@manv))
			set @kq = 1
		else
			begin
				set @kq = 0 
				insert into nhanvien values(@manv,@macv,@tennv,@ngaysinh,@luongcanban,@ngaycong,@phucap)
			end
		return @kq
	end
----
declare @error int
exec sp_them_nhan_vien3 'NV09','VS',N'Nguyễn Hải Nam','2/9/1999','300000','25','100000',@error output
select * from nhanvien
select @error
-----------------------------------------------------------------------------------
create proc sp_them_ngay_sinh(@manv nvarchar(4),@ngaysinh datetime,@kq int output)
as 
	begin
		if(not exists(select manv from nhanvien where manv=@manv))
			set @kq = 1
		else
			update nhanvien set ngaysinh=@ngaysinh where manv=@manv
	end
-------
declare @bien int
exec sp_them_ngay_sinh 'NV05','11/9/2001',@bien output
select @bien

select * from nhanvien