select * from sanpham
select * from hangsx
select * from nhanvien
select * from nhap
select * from pnhap
select * from xuat
select * from pxuat
------------------
select masp,tensp,tenhang,soluong,mausac,giaban,donvitinh,mota
from sanpham inner join hangsx on sanpham.mahangsx=hangsx.mahangsx
order by giaban DESC
------------------
select masp ,tensp,soluong,mausac ,giaban,donvitinh,mota
from sanpham inner join hangsx on sanpham.mahangsx=hangsx.mahangsx
where tenhang = 'samsung'
------------------
select * 
from nhanvien
where gioitinh = N'Nữ'and phong = N'Kế toán'
--------------------
select top 10 xuat.sohdx,ngayx,soluongx
from xuat inner join pxuat on xuat.sohdx=pxuat.sohdx
where year(ngayx) = 2020
order by soluongx DESC
---------------------
select top 10 masp,tensp,soluong,mausac,giaban,donvitinh,mota
from sanpham
order by giaban DESC
--------------------
select masp,tensp,giaban
from sanpham inner join hangsx on sanpham.mahangsx=hangsx.mahangsx
where giaban between 1000000 and 25000000 and tenhang = 'samsung'
--------------------------
select top 1 nhap.sohdn,ngaynhap
from nhap inner join pnhap on nhap.sohdn=pnhap.sohdn
where year(ngaynhap)=2020 
order by soluongN*dongiaN DESC
------------------------
select nhap.sohdn,ngaynhap
from nhap inner join pnhap on nhap.sohdn=pnhap.sohdn
where year(ngaynhap)=2020 and soluongN*dongiaN = (select max(soluongN*dongiaN)
from nhap inner join pnhap on nhap.sohdn=pnhap.sohdn
where year(ngaynhap)=2020)


