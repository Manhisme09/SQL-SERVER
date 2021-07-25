create database QLKHO5
go

use QLKHO5
go

create table VatTu(
	mavt nchar(10) primary key,
	tenvt nvarchar(30),
	slcon int
)
go

create table PhieuXuat(
	sopx nchar(10) primary key,
	ngayxuat date,
	hotenkhach nvarchar(30)
)
go

create table HangXuat(
	sopx nchar(10),
	mavt nchar(10),
	dongia money,
	slban int,
	constraint PK_hx primary key (sopx,mavt),
	constraint FK_hx_px foreign key (sopx)
		references PhieuXuat(sopx),
	constraint FK_hx_vt foreign key (mavt)
		references VatTu(mavt)
)
go

insert into VatTu values('VT01', N'Vật tư 1', 20)
insert into VatTu values('VT02', N'Vật tư 2', 50)
insert into VatTu values('VT03', N'Vật tư 3', 80)
go

insert into PhieuXuat values('PX01', '2021-06-26', N'Khách hàng 1')
insert into PhieuXuat values('PX02', '2021-05-01', N'Khách hàng 2')
insert into PhieuXuat values('PX03', '2021-05-01', N'Khách hàng 3')
go

insert into HangXuat values('PX01', 'VT01', 250000, 30)
insert into HangXuat values('PX02', 'VT01', 220000, 20)
insert into HangXuat values('PX03', 'VT01', 210000, 10)
insert into HangXuat values('PX01', 'VT02', 200000, 60)
insert into HangXuat values('PX02', 'VT03', 290000, 50)
go

select * from VatTu
select * from PhieuXuat
select * from HangXuat

delete HangXuat
delete PhieuXuat
delete VatTu
--cau2
create view vw_cau2
as
	select PhieuXuat.sopx,FORMAT(ngayxuat, 'dd-MM-yyyy') AS N'Ngày Xuất',sum(dongia*slban) as 'tong tien'
	from PhieuXuat inner join HangXuat on PhieuXuat.sopx=HangXuat.sopx
	where YEAR(ngayxuat)=YEAR(GETDATE())
	group by PhieuXuat.sopx,ngayxuat

--test 
select * from vw_cau2

--cau3
create proc sp_cau3(@month int,@year int)
as
begin
	declare @tongvt int
	set @tongvt = (select sum(slban)
					from PhieuXuat inner join HangXuat on PhieuXuat.sopx=HangXuat.sopx
					where YEAR(ngayxuat)= @year and MONTH(ngayxuat)=@month
					
						)
	declare @notif nvarchar(100)
	set @notif = N'Tổng số lượng vật tư xuất trong tháng' + CONVERT(CHAR(2), @month) 
						+ '- ' + CONVERT(CHAR(4), @year) + N' là: ' + CONVERT(CHAR, @tongvt)
	print @notif
end

--test
exec sp_cau3 05,2021

--cau4
create trigger trg_cau4
on HangXuat
for insert
as
begin
	declare @slb int
	declare @slcon int
	set @slb = (select slban from inserted)
	set @slcon = (select slcon from VatTu inner join inserted on inserted.mavt=VatTu.mavt)
	if(@slb>@slcon)
		begin
			raiserror (N'Khong du so luong ban',16,1)
			rollback transaction
		end
	else
		begin
			update VatTu set slcon=slcon-@slb
			from inserted inner join VatTu on inserted.mavt=VatTu.mavt
		end
end

--test loi
insert into HangXuat values('PX03', 'VT02', 110000, 100)
select * from VatTu
select * from HangXuat

--test thanh cong 
select * from VatTu
select * from HangXuat
insert into HangXuat values('PX03', 'VT02', 110000, 10)
select * from VatTu
select * from HangXuat