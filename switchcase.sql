use QLHANG

select * from Hang
select * from HDBan
select * from HangBan

alter view hoangdz 
as
select HangBan.MaHD,NgayBan,sum(DonGia * SoLuong) as TongTien
from HangBan, HDBan
where HangBan.MaHD = HDBan.MaHD
group by HangBan.MaHD,NgayBan

select * from hoangdz

alter proc hoangdz1(@thang int, @nam int)
as 
begin
	select HangBan.MaHang, TenHang, NgayBan, SoLuong, CASE 
	when DATEPART(dw, NgayBan) = 2 then 'Thu 2'
	when DATEPART(dw, NgayBan) = 3 then 'Thu 3'
	when DATEPART(dw, NgayBan) = 4 then 'Thu 4'
	when DATEPART(dw, NgayBan) = 5 then 'Thu 5'
	when DATEPART(dw, NgayBan) = 6 then 'Thu 6'
	when DATEPART(dw, NgayBan) = 7 then 'Thu 7'
	else 'Chu Nhat'
	end as Thu
	from HangBan inner join HDBan on HangBan.MaHD = HDBan.MaHD
	inner join Hang on HangBan.MaHang = Hang.MaHang
	where DATEPART(m, NgayBan) = @thang and DATEPART(yy, NgayBan) = @nam
 	end

exec hoangdz1 8,2222