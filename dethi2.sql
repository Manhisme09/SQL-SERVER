use master
go

create database QLHang4
go

use QLHang4
go

create table Hang(
	mahang nchar(10) primary key,
	tenhang nvarchar(30),
	dvtinh nvarchar(30),
	slton int
)
go

create table HDBan(
	mahd nchar(10) primary key,
	ngayban date,
	hotenkhach nvarchar(30)
)
go

create table HangBan(
	mahd nchar(10),
	mahang nchar(10),
	dongia money,
	soluong int,
	constraint PK_hb primary key (mahang,mahd),
	constraint FK_hb_hd foreign key (mahd)
		references HDBan(mahd),
	constraint FK_hb_h foreign key (mahang)
		references Hang(mahang)

)
go

insert into Hang values('H01', N'Hàng 1', N'Cái', 30)
insert into Hang values('H02', N'Hàng 2', N'Hộp', 40)
insert into Hang values('H03', N'Hàng 3', N'Lọ', 50)
go

insert into HDBan values('HD01', '02-03-2021', N'Khách hàng 1')
insert into HDBan values('HD02',  '02-22-2021', N'Khách hàng 2')
insert into HDBan values('HD03', '02-01-2021', N'Khách hàng 3')
go

insert into HangBan values('HD01', 'H01', 50000, 100)
insert into HangBan values('HD02', 'H02', 20,2)
insert into HangBan values('HD03', 'H01', 250000, 300)
insert into HangBan values('HD02', 'H01', 30,4)
insert into HangBan values('HD01', 'H02', 450000, 40)
go

select * from Hang
select * from HDBan
select * from HangBan

delete from HangBan
delete from HDBan
delete from Hang

--cau2
create function fn_cau2(@thang int,@nam int)
returns @bang table(mahd nchar(10),ngayban nvarchar(30),tongtien money)
as
begin
	insert into @bang
		select HDBan.mahd,ngayban,sum(soluong*dongia)
		from HDBan inner join HangBan on HDBan.mahd=HangBan.mahd
		where MONTH(ngayban)=@thang and YEAR(ngayban)=@nam
		group by HDBan.mahd,ngayban
		having sum(soluong*dongia)>500
	return
end

--test
select * from fn_cau2(02,2021)

--cau3
create proc sp_cau3(@mahd nchar(10),@tenhang nvarchar(30),@dongia int,@soluong int,@kq int output)
as
begin 
	if(not exists(select * from Hang where tenhang= @tenhang))
		begin
			print N'Khong ton tai ten hang'
			set @kq=0
		end
		if(not exists(select * from HDBan where mahd=@mahd))
			begin
				print N'Khong ton tai ma hd'
			set @kq=0
			end
	else
		begin
			declare @mahang nchar(10)
			set @mahang = (select mahang from Hang where tenhang=@tenhang)
			insert into HangBan values(@mahd,@mahang,@dongia,@soluong)
			set @kq=1
		end
	return @kq
end

--test
declare @kq int
exec sp_cau3 'HD03',N'Hàng 3',50,100,@kq output
select * from HangBan
select @kq
--test loi1
declare @kq int
exec sp_cau3 'HD07',N'Hàng 3',50,100,@kq output
select @kq
--tesst loi 2
declare @kq int
exec sp_cau3 'HD07',N'Hàng 7',50,100,@kq output
select @kq

--cau4
create trigger trg_cau4
on HangBan
for update
as
begin
	declare @slmoi int
	declare @slcu int
	declare @slton int
	set @slmoi = (select soluong from inserted)
	set @slcu =(select soluong from deleted)
	set @slton =(select slton from inserted inner join Hang on Hang.mahang=inserted.mahang)
	if((@slmoi-@slcu)>@slton)
		begin
			raiserror(N'Khong hop le',16,1)
			rollback transaction
		end
	else
		update Hang set slton=slton-(@slmoi-@slcu)
		from Hang inner join inserted on Hang.mahang=inserted.mahang
		
end

--test
select * from Hang
select * from HangBan
update HangBan set soluong = 50
where mahang='H02' and mahd='HD01'
select * from Hang
select * from HangBan

--test loi
select * from Hang
select * from HangBan
update HangBan set soluong = 400
where mahang='H01' and mahd='HD03'
select * from Hang
select * from HangBan
