use master --đứng trên CSDL chính mới tạo được các CSDL
go --bó lệnh tiếp theo
create database QLBHag --tạo CSDL
on primary( --CSDL chính
	name = 'QLBHag_dat', --tên logic
	filename = 'D:\QLBHag.mdf', --file csdl chính
	size = 10MB, --kích thước khởi tạo file
	maxsize = 50MB, --kích thước tối đa
	filegrowth = 10MB --tăng trưởng
)
log on( --file nhật ký
	name = 'QLBHag_log', filename='D:\QLBHag.ldf',size=2MB,
	maxsize = 5MB,filegrowth=20%
)
go
use QLBHag --sử dụng CSDL vừa tạo ra
go
create table hangsx(
	mahangsx nchar(10) not null primary key,
	tenhang nvarchar(20) not null,
	diachi nvarchar(30),
	sodt nchar(10),
	email nvarchar(30)
)
create table nhanvien(
	manv nchar(10) not null primary key,
	tennv nvarchar(20) not null,
	gioitinh nchar(10),
	diachi nvarchar(20),
	sodt nchar(10),email nvarchar(30),phong nvarchar(20)
)
create table sanpham(
	masp nchar(10) not null primary key,
	mahangsx nchar(10) not null,
	tensp nvarchar(30) not null,
	soluong int,mausac nchar(10),giaban money,
	donvitinh nchar(10),mota ntext,
	constraint FK_sanpham_hangsx foreign key(mahangsx)
		references hangsx(mahangsx)
	--ràng_buộc tên_ràng_buộc kiểu_ràng_buộc(khóa_ngoài)
	--tham_chiếu bảng_tham_chiếu(cột_tham_chiếu)
)
create table pnhap(
	sohdn nchar(10) not null primary key,
	ngaynhap date, manv nchar(10) not null,
	constraint FK_pnhap_nhanvien foreign key(manv)
	references nhanvien(manv)
)
create table pxuat(
	sohdx nchar(10) not null primary key,
	ngayx date,manv nchar(10) not null,
	constraint FK_pxuat_nv foreign key(manv) 
	references nhanvien(manv)
)
create table nhap(
	sohdn nchar(10) not null,
	masp nchar(10) not null,
	soluongN int,dongiaN money,
	constraint PK_nhap primary key(sohdn,masp),
	constraint FK_nhap_pnhap foreign key(sohdn)
		references pnhap(sohdn),
	constraint FK_nhap_sp foreign key(masp)
		references sanpham(masp)
)
create table xuat(
	sohdx nchar(10) not null,masp nchar(10) not null,
	soluongX int,
	constraint PK_xuat primary key(sohdx,masp),
	constraint FK_x_px foreign key(sohdx)
		references pxuat(sohdx),
	constraint FK_x_sp foreign key(masp) 
		references sanpham(masp)
)
go

insert into hangsx values ('H01','Samsung','korea','0110827','ss@gmail.com.kr')
insert into hangsx values ('H02','Oppo','china','0810862','oppo@gmail.com.cn')
insert into hangsx values ('H03','Vinfone',N'Việt Nam','0822626','vf@gmail.com.vn')

insert  into nhanvien values ('NV01',N'Nguyễn Thị Thu',N'Nữ',N'Hà Nội','09826221','thu@gmail.com',N'Kế toán')
insert  into nhanvien values ('NV02',N'Lê Văn Nam',N'Nam',N'Bắc Ninh','0972252','nam@gmail.com',N'Vật Tư')
insert  into nhanvien values ('NV03',N'Trần Hòa Bình',N'Nữ',N'Hà Nội','0388388','hb@gmail.com',N'Kế toán')
insert  into nhanvien values ('NV04',N'Bùi Hòa Mình',N'Nữ',N'Hà Nam','0458388','mb@gmail.com',N'Kế toán')

insert into sanpham values ('SP01','H02',N'F1 plus',100,N'xám','7000000',N'chiếc',N'Hàng cận cao cấp')
insert into sanpham values ('SP02','H01',N'galaxy note 11',50,N'Đỏ','19000000',N'chiếc',N'Hàng cận cao cấp')
insert into sanpham values ('SP03','H02',N'F3 lite',200,N'Nâu','3000000',N'chiếc',N'Hàng cận cao cấp')
insert into sanpham values ('SP04','H03',N'Vjoy3',200,N'xám','15000000',N'chiếc',N'Hàng cận cao cấp')
insert into sanpham values ('SP05','H01',N'Galaxy V21',100,N'Nâu','8000000',N'chiếc',N'Hàng cận cao cấp')


insert into pnhap values ('N01','02-05-2019','NV01')
insert into pnhap values ('N02','04-07-2020','NV02')
insert into pnhap values ('N03','05-17-2020','NV02')
insert into pnhap values ('N04','03-22-2020','NV03')
insert into pnhap values ('N05','07-07-2020','NV01')

insert into nhap values ('N01','SP02',10,'17000000 ')
insert into nhap values ('N02','SP01',30,'6000000 ')
insert into nhap values ('N03','SP04',20,'1200000 ')
insert into nhap values ('N04','SP01',10,'6200000 ')
insert into nhap values ('N05','SP05',20,'7000000 ')

insert into pxuat values ('X01','06-14-2020','Nv02')
insert into pxuat values ('X02','03-05-2019','Nv03')
insert into pxuat values ('X03','12-12-2020','Nv01')
insert into pxuat values ('X04','06-02-2020','Nv02')
insert into pxuat values ('X05','05-18-2020','Nv01')

insert into xuat values ('X01','SP03',5)
insert into xuat values ('X02','SP01',3)
insert into xuat values ('X03','SP02',1)
insert into xuat values ('X04','SP03',2)
insert into xuat values ('X05','SP05',1)


delete from xuat
delete from pxuat
delete from nhap
delete from pnhap
delete from nhanvien
delete from sanpham
delete from hangsx

select * from sanpham
select * from hangsx
select * from nhanvien
select * from nhap
select * from pnhap
select * from xuat
select * from pxuat