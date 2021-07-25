create proc sp_nhapkhoa( @makhoa int,@tenkhoa nvarchar(20),@dienthoai nvarchar(12) )
as
	begin
		if(exists(select tenkhoa from khoa where tenkhoa = @tenkhoa))
			print 'ten khoa' + @tenkhoa + 'da ton tai'
		else
			insert into khoa values(@makhoa,@tenkhoa,@dienthoai)
	end
-------
select * from khoa
exec sp_nhapkhoa 6,N'Điện tử','1224556'

-----------------------------------------------------------
create proc sp_nhaplop(@malop int,@tenlop nvarchar(20),
						 @khoa int,@hedt nvarchar(20),
						 @namnhaphoc int, @makhoa int)
as
	 begin
		 if(exists(select * from lop where tenlop=@tenlop))
			print 'lop da ton tai'
		 else
			 if(not exists(select * from khoa where makhoa=@makhoa))
				print 'khoa nay chua ton tai'
			 else
				 insert into lop
				values(@malop,@tenlop,@khoa,@hedt,@namnhaphoc,@makhoa)
	 end

 --Gọi thủ tục
 SELECT * FROM LOP
 SELECT * FROM khoa
 EXEC SP_NHAPLOP 7,'TIN22',2,'DH','2011',3
-----------------------------------------------------------------
create proc sp_nhapkhoa3(@makhoa int,@tenkhoa nvarchar(20),@dienthoai nvarchar(20),@kq int output)
as
	begin
		if(exists(select tenkhoa from khoa where tenkhoa=@tenkhoa))
			set @kq = 0
		else
			insert into khoa values (@makhoa,@tenkhoa,@dienthoai)
		
		return @kq
	end
----
declare @loi int
exec sp_nhapkhoa3 8,'CNTTASAS','12356',@loi OUTPUT
select @loi
---------------------------------------------------------------------
create proc sp_nhaplop4(@malop int,@tenlop nvarchar(20),@hedt nvarchar(20),@namnhaphoc int, @makhoa int,@kq int output)
as
	begin
		if(exists(select tenlop from lop where tenlop=@tenlop)
			set @kq = 0
		else
			if(not exists(select makhoa from khoa where makhoa=@makhoa))
				set @kq = 1
			else
				begin
					insert into lop values(@malop,@tenlop,@hedt,@namnhaphoc,@makhoa)
					set @kq =2

		return @kq
	end
------
									