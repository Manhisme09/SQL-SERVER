use QLBHag
go
--a
create proc sp_nhapHangsx(@mahangsx nchar(10),@tenhang nvarchar(20),
							@diachi nvarchar(30),@sodt nchar(10),@email nvarchar(30))
as
begin
	if(exists(select tenhang from hangsx where tenhang=@tenhang))
		print N'Tên hàng đã tồn tại'
	else
		insert into hangsx values(@mahangsx,@tenhang,@diachi,@sodt,@email)
	 
end
execute sp_nhapHangsx 'h3','tivi',N'Hà Nội','0932132','manht9090@gmail.com'
select * from hangsx
------------------------------------------------------------------------------------
--b
create proc sp_nhapSanPham(@masp nchar(10),@tenhang nvarchar(20),@tensp nvarchar(30),@soluong int,
							@mausac nchar(10),@giaban money,@donvitinh nchar(10),@mota ntext)
as
begin
	if(not exists(select tenhang from hangsx where tenhang=@tenhang))
		print N'tên hang ko tồn tại'
	else
		begin
			declare @mahangsx nchar(10)
			select @mahangsx=mahangsx from hangsx where tenhang=@tenhang
			if(exists(select masp from sanpham where masp=@masp))
				
				update sanpham set masp=@masp,mahangsx=@mahangsx,tensp=@tensp,soluong=@soluong,mausac=@mausac,giaban=@giaban,donvitinh=@donvitinh,mota=@mota
					where masp=@masp
			else
				insert into sanpham values(@masp,@mahangsx,@tensp,@soluong,@mausac,@giaban,@donvitinh,@mota)


		end
end

execute sp_nhapSanPham 'SP01','Samsung',N'quạt',20,N'xám','7000000',N'chiếc',N'Hàng cận cao cấp'
execute sp_nhapSanPham 'SP06','Samsung',N'bút',20,N'đỏ','7000000',N'chiếc',N'Hàng cận cao cấp'
execute sp_nhapSanPham 'SP07','Nokia',N'thước',20,N'vàng','7000000',N'chiếc',N'Hàng cận cao cấp'
select * from sanpham
select * from hangsx
------------------------------------------------------------------------------------------------
--d
create proc sp_nhapNhanVien(@manv nchar(10),@tennv nvarchar(20),@gioitinh nchar(10),@diachi nvarchar(20),@sodt nchar(10),
							@email nvarchar(30),@phong nvarchar(20),@bien int)
as
begin
	if(@bien=0)
		update nhanvien set manv=@manv,tennv=@tennv,gioitinh=@gioitinh,diachi=@diachi,
							sodt=@sodt,email=@email,phong=@phong 
		where manv=@manv
	else
		insert into nhanvien values(@manv,@tennv,@gioitinh,@diachi,@sodt,@email,@phong)	
end
--
select * from nhanvien
execute sp_nhapNhanVien 'NV02',N'Nguyễn Đức Tuân',N'Nam',N'Hà Nội','09232133','tuan21@gmail.com',N'Vật Tư',0
execute sp_nhapNhanVien 'NV05',N'Nguyễn Đức Nam',N'Nam',N'Hà Nam','0922331','nam21@gmail.com',N'Kế Toán',1
--------------------------------------------------------------------------------
--2
--a
create proc sp_nhapNhanVien2(@manv nchar(10),@tennv nvarchar(20),@gioitinh nchar(10),@diachi nvarchar(20),@sodt nchar(10),
							@email nvarchar(30),@phong nvarchar(20),@flag int,@kq int output)
as
begin
	if(@gioitinh<>N'Nam' and @gioitinh<>N'Nữ')
		set @kq=1
	else
		begin
			set @kq=0
			if(@flag=0)
				insert into nhanvien values(@manv,@tennv,@gioitinh,@diachi,@sodt,@email,@phong)	
			else
				update nhanvien set manv=@manv,tennv=@tennv,gioitinh=@gioitinh,diachi=@diachi,
									sodt=@sodt,email=@email,phong=@phong 
				where manv=@manv
		end
end
--

declare @kq int
exec sp_nhapNhanVien2 'NV06',N'Trần Thị Trang',N'Nữ',N'Hà Nội','0932432','trang123@gmail.com',N'Kế Toán',0,@kq output
exec sp_nhapNhanVien2 'NV06',N'Trần Thị Hà',N'Nữ',N'Hà Nam','0932432','ha123@gmail.com',N'Kế Toán',2,@kq output
exec sp_nhapNhanVien2 'NV06',N'Trần Thị Trang',N'NNN',N'Hà Nội','0932432','trang123@gmail.com',N'Kế Toán',0,@kq output
select * from nhanvien
select @kq
--------------------------------------------------------------------------------------
--b
