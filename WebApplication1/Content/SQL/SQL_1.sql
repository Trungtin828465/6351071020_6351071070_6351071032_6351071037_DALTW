CREATE DATABASE WatchStore;
GO

USE WatchStore;
GO
--10 Bảng Category (Danh mục sản phẩm)
CREATE TABLE Category (
    CategoryID INT PRIMARY KEY IDENTITY(1,1), -- Mã danh mục (tự động tăng)
    CategoryName NVARCHAR(100) NOT NULL       -- Tên danh mục sản phẩm
);

-- Dữ liệu mẫu cho Category
INSERT INTO Category (CategoryName) 
VALUES 
(N'Sang Trọng'),
(N'Thể Thao'),
(N'Thời Trang');

--
--1 Bảng Customer (Khách hàng)
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),  -- Mã khách hàng (tự động tăng)
    FullName NVARCHAR(100) NOT NULL CHECK (FullName NOT LIKE '%[0-9]%'),           -- Tên đầy đủ của khách hàng
	ImgCustomer nvarchar(50), -- Ảnh người dùng
    Email NVARCHAR(100) NOT NULL UNIQUE check( Email  LIKE '%@gmail.com') , -- email tk
	CreatedAt DATETIME DEFAULT GETDATE()  ,-- Ngày tạo tài khoản 
	Password nvarchar(50) not null,			---password
    Phone NVARCHAR(20) NOT NULL CHECK (LEN(Phone) IN (10, 11) AND Phone NOT LIKE '%[^0-9]%'),               -- Số điện thoại của khách hàng
    Gender NVARCHAR(10),-- Giới tính của khách hàng
	Address nvarchar(255), -- địa chỉ
	-- nhận hàng
	check_Remove int default 1 -- 1 là còn, 0 là xóa
);


-- Cập nhật dữ liệu mẫu cho bảng Customer   90 người dùng 
-- 68 người 2023

INSERT INTO Customer (FullName, Email, Password, Phone, Gender, Address, CreatedAt, ImgCustomer)
VALUES
(N'Nguyễn Trung Tín', 'tin@gmail.com', '123456', '0987654321', N'Nam', N'Hà Nội', '2023-09-23', N'nam1.png'),
(N'Nguyễn Văn Đúng', 'dung@gmail.com', '123456', '0901234567', N'Nam', N'Bắc Ninh', '2023-09-23', N'nam2.png'),
(N'Nguyễn Tuấn Kiệt', 'kiet@gmail.com', '123456', '0956789123', N'Nam', N'Hồ Chí Minh', '2023-09-23', N'nam3.png'),
(N'Nguyễn Phi Khanh', 'khanh@gmail.com', '123456', '0961234567', N'Nam', N'Hải Phòng', '2023-09-23', N'nam4.png'),
(N'Nguyễn Văn An', 'an.nguyen@gmail.com', '12345', '0912345678', N'Nam', N'Hà Nội', '2023-01-15', N'nam5.png'),
(N'Trần Thị Bích', 'bich.tran@gmail.com', 'password', '0932112334', N'Nữ', N'TP Hồ Chí Minh', '2023-02-10', N'nu1.png'),
(N'Lê Văn Hưng', 'hung.le@gmail.com', 'hung123', '0988111222', N'Nam', N'Đà Nẵng', '2023-03-05', N'nam6.png'),
(N'Phạm Thị Hoa', 'hoa.pham@gmail.com', 'hoa456', '0903556677', N'Nữ', N'Cần Thơ', '2023-04-12', N'nu2.png'),
(N'Nguyễn Minh Long', 'long.nguyen@gmail.com', 'minh789', '0978445566', N'Nam', N'Hải Phòng', '2023-05-18', N'nam7.png'),
(N'Vũ Thị Mai', 'mai.vu@gmail.com', 'vuthimai', '0932994455', N'Nữ', N'Quảng Ninh', '2023-06-21', N'nu3.png'),
(N'Đỗ Văn Quân', 'quan.do@gmail.com', 'doquancb', '0912667788', N'Nam', N'Nam Định', '2023-07-30', N'nam1.png'),
(N'Phạm Văn Thành', 'thanh.pham@gmail.com', 'phamthanh123', '0988995566', N'Nam', N'Bình Dương', '2023-08-13', N'nam2.png'),
(N'Bùi Thị Lan', 'lan.bui@gmail.com', 'lanbui', '0905112233', N'Nữ', N'Lâm Đồng', '2023-09-17', N'nu4.png'),
(N'Lê Anh Tuấn', 'tuan.le@gmail.com', 'lequoc123', '0978116677', N'Nam', N'Huế', '2023-10-05', N'nam3.png'),
(N'Trần Thị Kim', 'kim.tran@gmail.com', 'tran_kim', '0922334455', N'Nữ', N'TP Hồ Chí Minh', '2023-11-19', N'nu5.png'),
(N'Nguyễn Hữu Bình', 'binh.nguyen@gmail.com', 'binhpass', '0912997788', N'Nam', N'Bắc Giang', '2023-12-01', N'nam4.png'),
(N'Hoàng Văn Quý', 'quy.hoang@gmail.com', 'quyhoang', '0906778899', N'Nam', N'Nghệ An', '2023-03-14', N'nam5.png'),
(N'Phạm Thị Hằng', 'hang.pham@gmail.com', 'hang123', '0934556677', N'Nữ', N'Hải Dương', '2023-05-25', N'nu6.png'),
(N'Lê Thị Thu', 'thu.le@gmail.com', 'thu123', '0912778899', N'Nữ', N'TP Hồ Chí Minh', '2023-08-07', N'nu7.png'),
(N'Nguyễn Văn Lâm', 'lam.nguyen@gmail.com', 'nguyenlam', '0977885566', N'Nam', N'TP Hồ Chí Minh', '2023-09-28', N'nam6.png'),
(N'Đỗ Thị Yến', 'yen.do@gmail.com', 'doYen2023', '0944556677', N'Nữ', N'Hà Nội', '2023-10-22', N'nu1.png'),
(N'Võ Minh Hoàng', 'hoang.vo@gmail.com', 'minh2023', '0988223344', N'Nam', N'Đà Nẵng', '2023-06-19', N'nam7.png'),
(N'Trần Văn Sơn', 'son.tran@gmail.com', 'transon', '0912993344', N'Nam', N'Khánh Hòa', '2023-07-12', N'nam2.png'),
(N'Nguyễn Thị Tuyết', 'tuyet.nguyen@gmail.com', 'ngtuyet', '0932991122', N'Nữ', N'Gia Lai', '2023-11-08', N'nu3.png'),
(N'Lê Văn Thắng', 'thang.le@gmail.com', 'thang123', '0913778899', N'Nam', N'Hà Nội', '2023-01-20', N'nam4.png'),
(N'Phạm Thị Huyền', 'huyen.pham@gmail.com', 'huyen456', '0932885566', N'Nữ', N'TP Hồ Chí Minh', '2023-02-18', N'nu4.png'),
(N'Nguyễn Văn Khánh', 'khanh.nguyen@gmail.com', 'khanh789', '0988445566', N'Nam', N'Bình Định', '2023-03-10', N'nam5.png'),
(N'Trần Minh Khoa', 'khoa.tran@gmail.com', 'khoa2023', '0912993344', N'Nam', N'Đà Nẵng', '2023-04-25', N'nam6.png'),
(N'Phan Thị Thanh', 'thanh.phan@gmail.com', 'thanh123', '0932995566', N'Nữ', N'Cần Thơ', '2023-05-13', N'nu5.png'),
(N'Bùi Văn Hùng', 'hung.bui@gmail.com', 'hungpassword', '0905332211', N'Nam', N'Hải Phòng', '2023-06-02', N'nam7.png'),
(N'Lê Thị Ngọc', 'ngoc.le@gmail.com', 'ngoc123', '0922778899', N'Nữ', N'Quảng Nam', '2023-07-18', N'nu2.png'),
(N'Nguyễn Văn Dũng', 'dung.nguyen@gmail.com', 'dung456', '0988112233', N'Nam', N'Lâm Đồng', '2023-08-14', N'nam1.png'),
(N'Trần Thị Thanh Mai', 'mai.tran@gmail.com', 'thanhmai', '0912335566', N'Nữ', N'Hà Giang', '2023-09-09', N'nu6.png'),
(N'Phạm Văn Bình', 'binh.pham@gmail.com', 'binh2023', '0906223344', N'Nam', N'Nghệ An', '2023-10-16', N'nam2.png'),
(N'Lê Minh Tuấn', 'tuan.leminh@gmail.com', 'tuantuan', '0932667788', N'Nam', N'TP HCM', '2023-11-20', N'nam3.png'),
(N'Trần Văn Phúc', 'phuc.tran@gmail.com', 'phucphuc', '0944556677', N'Nam', N'Bình Phước', '2023-12-12', N'nam4.png'),

(N'Hoàng Thị Lan', 'lan.hoang@gmail.com', 'hoanglan', '0905111223', N'Nữ', N'TP Hồ Chí Minh', '2023-04-30', N'nu1.png'),
(N'Nguyễn Văn Tiến', 'tien.nguyen@gmail.com', 'tien123', '0912445566', N'Nam', N'Bình Thuận', '2023-05-07', N'nam1.png'),
(N'Võ Thị Bích Ngọc', 'ngoc.vo@gmail.com', 'ngoc123', '0922994455', N'Nữ', N'Bà Rịa - Vũng Tàu', '2023-06-22', N'nu2.png'),
(N'Trần Thị Hiền', 'hien.tran@gmail.com', 'tranhien', '0932886677', N'Nữ', N'Đồng Nai', '2023-07-03', N'nu3.png'),
(N'Nguyễn Văn Hải', 'hai.nguyen@gmail.com', 'hai789', '0978445567', N'Nam', N'TP Cần Thơ', '2023-08-28', N'nam2.png'),
(N'Trần Quốc Bảo', 'bao.tran@gmail.com', 'baoquoc', '0988112255', N'Nam', N'Bắc Giang', '2023-09-21', N'nam3.png'),
(N'Phạm Thanh Hà', 'ha.pham@gmail.com', 'phamthanhha', '0912336677', N'Nữ', N'TP Đà Lạt', '2023-10-10', N'nu4.png'),
(N'Phạm Thanh Hải', 'hai.pham@gmail.com', 'phamthanhha1', '0912336677', N'Nữ', N'TP Quy Nhơn', '2023-09-10', N'nu5.png'),
(N'Lê Thị Hạnh', 'hanh.le@gmail.com', 'lehanh', '0906778899', N'Nữ', N'Thừa Thiên Huế', '2023-12-05', N'nu6.png'),
(N'Nguyễn Thị Kiều', 'kieulb.nguyen@gmail.com', 'kieukiều', '0904556677', N'Nữ', N'Hà Nội', '2023-01-25', N'nu7.png'),
(N'Trần Quốc Tài', 'tai.tran@gmail.com', 'tai123', '0922334455', N'Nam', N'TP Hồ Chí Minh', '2023-02-20', N'nam4.png'),
(N'Phạm Thị Sen', 'sen.pham@gmail.com', 'sen456', '0932556789', N'Nữ', N'Quảng Ninh', '2023-03-15', N'nu1.png'),
(N'Lê Văn Cường', 'cuong.le@gmail.com', 'cuong789', '0978442233', N'Nam', N'Đà Nẵng', '2023-04-05', N'nam5.png'),
(N'Võ Thị Hồng', 'hong.vo@gmail.com', 'hong123', '0913778899', N'Nữ', N'Bắc Ninh', '2023-05-11', N'nu2.png'),
(N'Nguyễn Hoàng Khải', 'khai.nguyen@gmail.com', 'khai456', '0944556677', N'Nam', N'Hải Dương', '2023-06-15', N'nam6.png'),
(N'Nguyễn Thị Xuân', 'xuan.nguyen@gmail.com', 'xuan789', '0906885566', N'Nữ', N'Lâm Đồng', '2023-07-01', N'nu3.png'),
(N'Phạm Minh Khoa', 'khoa.pham@gmail.com', 'khoa123', '0982334455', N'Nam', N'TP Hồ Chí Minh', '2023-08-10', N'nam7.png'),
(N'Trần Văn Đạt', 'dat.tran@gmail.com', 'dat456', '0932882233', N'Nam', N'Khánh Hòa', '2023-09-04', N'nam1.png'),
(N'Lê Thị Hương', 'huong.le@gmail.com', 'huong789', '0922334566', N'Nữ', N'Tp Cần Thơ', '2023-10-18', N'nu4.png'),
(N'Nguyễn Đình Quân', 'quan.nguyen@gmail.com', 'quan123', '0912337788', N'Nam', N'Thái Nguyên', '2023-11-14', N'nam2.png'),
(N'Trần Thị Ly', 'ly.tran@gmail.com', 'ly456', '0944556677', N'Nữ', N'Hà Nam', '2023-12-08', N'nu5.png'),
(N'Phạm Văn Hoàng', 'hoang.pham@gmail.com', 'hoang789', '0906778899', N'Nam', N'Hà Tĩnh', '2023-01-12', N'nam3.png'),
(N'Lê Văn Minh', 'minh.le@gmail.com', 'minh456', '0933112233', N'Nam', N'Bình Dương', '2023-02-02', N'nam4.png'),
(N'Nguyễn Thị Hằng', 'hang.nguyen@gmail.com', 'hang123', '0922445566', N'Nữ', N'Tp Đà Lạt', '2023-03-22', N'nu6.png'),
(N'Nguyễn Văn Tuấn', 'tuan.nguyen@gmail.com', 'tuan789', '0978442233', N'Nam', N'Hà Nội', '2023-04-15', N'nam5.png'),
(N'Vũ Quốc Bảo', 'bao.vu@gmail.com', 'bao2023', '0988223344', N'Nam', N'Quảng Ngãi', '2023-05-30', N'nam6.png'),
(N'Phạm Văn Đức', 'duc.pham@gmail.com', 'duc456', '0912445566', N'Nam', N'Hải Phòng', '2023-06-25', N'nam7.png'),
(N'Nguyễn Thị Nhung', 'nhung.nguyen@gmail.com', 'nhung123', '0933998777', N'Nữ', N'Bắc Giang', '2023-07-20', N'nu7.png'),
(N'Trần Văn Huy', 'huy.tran@gmail.com', 'huy456', '0906885566', N'Nam', N'Thừa Thiên Huế', '2023-08-09', N'nam1.png'),
(N'Lê Thị Diễm', 'diem.le@gmail.com', 'diem123', '0944556677', N'Nữ', N'Kiên Giang', '2023-09-13', N'nu2.png'),
(N'Nguyễn Minh Tâm', 'tam.nguyen@gmail.com', 'tam456', '0932558899', N'Nam', N'Sóc Trăng', '2023-10-17', N'nam3.png'),
(N'Trần Thị Bạch', 'bach.tran@gmail.com', 'bach123', '0905112233', N'Nữ', N'TP Hồ Chí Minh', '2023-11-30', N'nu4.png'),
(N'Trần Văn Minh', 'tranvanminh@gmail.com', 'mypassword789', '0912345678', N'Nam', N'Đà Nẵng', '2024-02-19', 'nam1.png'),
(N'Nguyễn Văn Tùng', 'nguyenvana@gmail.com', 'password234', '0987654322', N'Nam', N'Hồ Chí Minh', '2024-11-23', 'nam2.png'),
(N'Lê Thị Hồng Diễm', 'lethib@gmail.com', 'password345', '0987654323', N'Nữ', N'Đà Nẵng', '2024-06-13', 'nu1.png'),
(N'Hoàng Văn Hoàng Hải', 'hoangvanc@gmail.com', 'password456', '0987654324', N'Nam', N'Hải Phòng', '2024-08-15', 'nam3.png'),
(N'Nguyễn Thị Duyên', 'nguyenthid@gmail.com', 'password567', '0987654325', N'Nữ', N'Bắc Ninh', '2024-10-30', 'nu2.png'),
(N'Phạm Văn Toàn', 'phamvane@gmail.com', 'password678', '0987654326', N'Nam', N'Cần Thơ', '2024-01-18', 'nam4.png'),
(N'Lê Thị Thuý Hồng', 'lethif@gmail.com', 'password789', '0987654327', N'Nữ', N'Bình Dương', '2024-05-09', 'nu3.png'),
(N'Vũ Văn Giang', 'vuvang@gmail.com', 'password890', '0987654328', N'Nam', N'Quảng Ninh', '2024-07-05', 'nam5.png'),
(N'Nguyễn Thị Hồng', 'nguyenthih@gmail.com', 'password901', '0987654329', N'Nữ', N'Nha Trang', '2024-01-29', 'nu4.png'),
(N'Hoàng Thị Thuý', 'hoangthii@gmail.com', 'password012', '0987654330', N'Nữ', N'Huế', '2024-10-23', 'nu5.png'),
(N'Trần Văn Nam', 'tranvanj@gmail.com', 'password1234', '0987654331', N'Nam', N'Hà Tĩnh', '2024-11-08', 'nam6.png'),
(N'Lê Thị Kiều Trang', 'lethik@gmail.com', 'password2345', '0987654332', N'Nữ', N'Bình Định', '2024-09-28', 'nu6.png'),
(N'Nguyễn Văn Long', 'nguyenvanl@gmail.com', 'password3456', '0987654333', N'Nam', N'Phú Yên', '2024-03-20', 'nam7.png'),
(N'Phạm Thị Mỹ Kiều', 'phamthim@gmail.com', 'password4567', '0987654334', N'Nữ', N'Thái Bình', '2024-02-19', 'nu7.png'),
(N'Hoàng Văn Thụ', 'hoangvann@gmail.com', 'password5678', '0987654335', N'Nam', N'Long An', '2024-05-14', 'nam1.png'),
(N'Nguyễn Thị Thuý Vấn', 'nguyenthio@gmail.com', 'password6789', '0987654336', N'Nữ', N'Quảng Nam', '2024-06-30', 'nu1.png'),
(N'Vũ Văn Định', 'vuthip@gmail.com', 'password7890', '0987654337', N'Nữ', N'An Giang', '2024-01-03', 'nu2.png'),
(N'Trần Văn Quyết', 'tranvanq@gmail.com', 'password8901', '0987654338', N'Nam', N'Tiền Giang', '2024-08-29', 'nam2.png'),
(N'Nguyễn Thị Trà My', 'nguyenthir@gmail.com', 'password9012', '0987654339', N'Nữ', N'Nghệ An', '2024-05-03', 'nu3.png'),
(N'Trần Nguyễn Hải', 'tranvaHAi@gmail.com', 'password8901', '0987654338', N'Nam', N'Trà Vinh', '2024-04-05', 'nam3.png'),
(N'Nguyễn Tú Trinh', 'nguyenth092@gmail.com', 'password9012', '0987654339', N'Nữ', N'Bình Định', '2024-10-01', 'nu4.png'),
(N'Lê Văn Sưu', 'levans@gmail.com', 'password0123', '0987654340', N'Nam', N'Tây Ninh', '2024-08-11', 'nam4.png');

--4 Bảng Brand (Thương hiệu đồng hồ)
CREATE TABLE Brand (
    BrandID INT PRIMARY KEY IDENTITY(1,1),     -- Mã thương hiệu (tự động tăng)
    BrandName NVARCHAR(100) NOT NULL UNIQUE   , -- Tên thương hiệu đồng hồ
	ImgBrand nvarchar(50)
);

--5 Dữ liệu mẫu cho Brand
INSERT INTO Brand (BrandName) 
VALUES 
('Casio'),--1
('Citizen'),--2
('Bentley'), --3
('Olym Pianus'),--4
('G-Shock'),--5
('Orient'),--6
('Seiko'),--7
('Tissot');--8


-- 6 Bảng Admin (Quản trị viên)
CREATE TABLE Admin (
    AdminID INT PRIMARY KEY IDENTITY(1,1),     -- Mã quản trị viên (tự động tăng)
    Adminname NVARCHAR(50) NOT NULL UNIQUE  ,   -- Tên đăng nhập của quản trị viên (không được trùng)
    Password NVARCHAR(255) NOT NULL,           -- Mật khẩu của quản trị viên
	ImgAdmin nvarchar(50), -- Ảnh admin
    FullName NVARCHAR(100) NOT NULL CHECK (FullName NOT LIKE '%[0-9]%'),           -- Tên đầy đủ của quản trị viên
    Email NVARCHAR(100) NOT NULL check( Email  LIKE '%@gmail.com'),              -- Email của quản trị viên
    Role NVARCHAR(50) NOT NULL,                -- Vai trò của quản trị viên
    CreatedAt DATETIME DEFAULT GETDATE()  ,-- Ngày tạo tài khoản quản trị viên
	Phone nvarchar(11) not null CHECK (LEN(Phone) IN (10, 11) AND Phone NOT LIKE '%[^0-9]%'),
	Gender NVARCHAR(10) ,
	check_Remove int default 1
);




INSERT INTO Admin (Adminname, Password, FullName, Email, Role,  Phone,Gender,ImgAdmin )
VALUES 
('tin', '123', N'Nguyễn Trung Tín', 'tin@gmail.com', N'Quản trị viên',  '0912345678', N'Nam', '1.jpg'),
('dung', '123', N'Nguyễn Văn Đúng', 'dung@gmail.com', N'Quản lý',  '0987654321', N'Nam','2.jpg'),
('kiet', '123', N'Nguyễn Tuấn Kiệt', 'kiet@gmail.com', N'Quản trị viên',  '0123456789',N'Nam', '3.jpg'),
('khanh', '123', N'Nguyễn Phi Khanh', 'khanh@gmail.com', N'Quản lý',  '0789123456', N'Nam', '4.jpg');


-- Bảng Supplier (Nhà cung cấp)
CREATE TABLE Supplier (
    SupplierID INT PRIMARY KEY IDENTITY(1,1),  -- Mã nhà cung cấp (tự động tăng)
    ContactName NVARCHAR(100)  NOT NULL Check (ContactName NOT LIKE '%[0-9]%'),                 -- Tên người liên hệ
	ImgSupplier nvarchar(50),
    Phone NVARCHAR(20) NOT NULL CHECK (LEN(Phone) IN (10, 11) AND Phone NOT LIKE '%[^0-9]%'),               -- Số điện thoại nhà cung cấp
    Email NVARCHAR(100) NOT NULL check( Email  LIKE '%@gmail.com') ,              -- Email nhà cung cấp
    Address NVARCHAR(255) NOT NULL,            -- Địa chỉ nhà cung cấp
    CreatedAt DATETIME DEFAULT GETDATE()      -- Ngày thêm nhà cung cấp
);
INSERT INTO Supplier ( ContactName, Phone, Email, Address, CreatedAt)
VALUES
    (N'Nguyễn Văn Tuấn', '0909123456', 'tuannv@gmail.com', N'123 Đường Lý Thường Kiệt, Quận 10, TP.HCM','2022-12-07' ),
    ( N'Lê Thị Hồng', '0918123456', 'honglt@gmail.com', N'45A Đường Phạm Văn Đồng, Quận Thủ Đức, TP.HCM','2023-07-07' ),
    ( N'Trần Văn Minh', '0987123456', 'minhtv@gmail.com', N'22 Đường Hoàng Diệu, Quận 4, TP.HCM','2023-09-28 '),
    ( N'Phạm Thị Lan', '0979123456', 'lanpt@gmail.com', N'KCN Tân Bình, Quận Tân Bình, TP.HCM','2022-03-08 '),
	( N'Phan Bảo Châu', '0359921016', 'pbct@gmail.com', N'Đống Đa, Quận 5, TP.HCM','2022-11-04 '),
    ( N'Vũ Văn Hải', '0912123456', 'haivv@gmail.com', N'Khu Phố 7, Quận 7, TP.HCM', '2021-11-17'),
	( N'Phạm Hoàng', '0912356665', 'nh@gmail.com', N'Võ Văn Ngân, Quận 9, TP.HCM','2022-05-18 '),
    ( N'Nguyễn Thuý Kiều', '0979765006', 'nntt@gmail.com', N'KCN Tân Bình, Quận 1, TP.HCM','2021-03-08 ');

	
--7 Bảng Product (Sản phẩm đồng hồ)
CREATE TABLE Product (
    ProductID INT PRIMARY KEY IDENTITY(1,1),  -- Mã sản phẩm (tự động tăng)
    ProductName NVARCHAR(100) NOT NULL,       -- Tên sản phẩm
    BrandID INT,                              -- Mã thương hiệu (liên kết với bảng Brand)
    Price DECIMAL(18, 0) NOT NULL,            -- Giá của sản phẩm
    Description NVARCHAR(MAX),                -- Mô tả chi tiết về sản phẩm
    StockQuantity INT,                        -- Số lượng tồn kho hiện tại của sản phẩm
    CategoryID INT,                           -- Mã danh mục sản phẩm (liên kết với bảng Category)
    ImageUrl NVARCHAR(255),                   -- Đường dẫn hình ảnh của sản phẩm
    SupplierID INT,                           -- Mã nhà cung cấp (liên kết với bảng Supplier)
    CreatedAt DATETIME DEFAULT GETDATE(),     -- Ngày tạo sản phẩm
    CreatedBy INT,                            -- Mã quản trị viên tạo sản phẩm (liên kết với bảng Admin)
	Discount INT ,							  -- mã giảm giá
    Check_Remove int default 1 ,			  -- xoá thì trả về 0, mặc định 1

	AverageRating float  default 0,                     -- số sao đánh giá
    -- Ràng buộc khóa ngoại
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID),
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID),
    FOREIGN KEY (BrandID) REFERENCES Brand(BrandID),
    FOREIGN KEY (CreatedBy) REFERENCES Admin(AdminID)
);


-- Dữ liệu mẫu cho Product   30 dòng
INSERT INTO Product (ProductName, BrandID, Price, Description, StockQuantity, CategoryID, ImageUrl, SupplierID, CreatedBy,Discount)
VALUES 
('Casio Edifice', 1, 2300000, N'Đồng hồ kim với thiết kế trẻ trung từ Casio', 50, 2, 'Casio Edifice.jpg', 2, 1,10),
('Casio Lavido', 1, 3200000, N'Đồng hồ thể thao bền bỉ của Casio', 100, 2, 'Casio Lavido.jpg', 5, 1, 8),
('Olym Pianus Infinity', 4, 540000, N'Đồng hồ sang trọng từ Olym Pianus', 20, 3, 'Olym Pianus Infinity.jpg', 3, 2,0),
('Olym Pianus Section', 4, 970000, N'Đồng hồ cao cấp từ Olym Pianus', 10, 3, 'Olym Pianus Section.jpg', 3, 2, 5),
('Orient Distinctive', 6, 720000, N'Đồng hồ siêu cấp Orient Distinctive', 10, 1, 'Orient Distinctive.jpg', 3, 2, 5),
('Orient Hover', 6, 580000, N'Đồng hồ siêu cấp Orient Hover', 10, 2, 'Orient Hover.jpg', 3, 2, 10),
('Orient Visibility', 6, 2800000, N'Đồng hồ siêu cấp Orient Visibility', 10, 3, 'Orient Visibility.jpg', 3, 2, 8),
('Tissot Hilane', 8, 1500000, N'Đồng hồ siêu cấp Tissot Hilane', 10, 3, 'Tissot Hilane.jpg', 5, 2,0),
('Citizen Infinity', 2, 690000, N'Đồng hồ thể thao Citizen Infinity', 10, 1, 'Citizen Infinity.jpg', 1, 2,5);
--
-- Dữ liệu mẫu cho Product
INSERT INTO Product (ProductName, BrandID, Price, Description, StockQuantity, CategoryID, ImageUrl, SupplierID, CreatedBy, Discount)
VALUES 
('Citizen Eco-Drive', 2, 720000, N'Đồng hồ năng lượng mặt trời từ Citizen', 70, 2, 'Citizen Eco-Drive.jpg', 2, 1, 12),
('Bentley Big Bang', 3, 2500000, N'Mẫu đồng hồ cao cấp với thiết kế mạnh mẽ từ Bentley', 5, 3, 'Bentley Big Bang.jpg', 3, 1, 7),
('Olym Pianus OP9908-88AMS', 4, 930000, N'Đồng hồ cơ với thiết kế mạnh mẽ từ Olym Pianus', 30, 1, 'Olym Pianus OP9908-88AMS.jpg', 2, 1, 15),
('G-Shock Seamaster', 5, 1200000, N'Đồng hồ lặn cao cấp từ G-Shock', 8, 2, 'G-Shock Seamaster.jpg', 2, 1, 8),
('Orient Bambino', 6, 2800000, N'Mẫu đồng hồ cơ cổ điển từ Orient', 40, 3, 'Orient Bambino.jpg', 3, 1, 10),
('Seiko 5 Sports', 7, 3500000, N'Đồng hồ thể thao bền bỉ từ Seiko', 60, 2, 'Seiko 5 Sports.jpg', 7, 1, 12),
('Tissot PRX', 8, 3800000, N'Mẫu đồng hồ thể thao cổ điển từ Tissot', 25, 1, 'Tissot PRX.jpg', 8, 1, 20),
('Casio GA-2100', 1, 3100000, N'Đồng hồ chống sốc bền bỉ từ Casio', 100, 3, 'Casio GA-2100.jpg', 1, 1, 5),
('Olym Pianus OP89322', 4, 5000000, N'Đồng hồ kim thanh lịch từ Olym Pianus', 35, 2, 'Olym Pianus OP89322.jpg', 4, 1, 10),
('Casio MTP-V002D', 1, 1200000, N'Đồng hồ kim cổ điển với giá phải chăng từ Casio', 80, 3, 'Casio MTP-V002D.jpg', 1, 1, 5),
('Citizen Automatic NJ0100', 2, 600000, N'Đồng hồ cơ tự động thanh lịch từ Citizen', 45, 1, 'Citizen Automatic NJ0100.jpg', 2, 1, 8),
('Bentley Classic Fusion', 3, 2900000, N'Mẫu đồng hồ cao cấp với thiết kế tối giản từ Bentley', 4, 1, 'Bentley Classic Fusion.jpg', 3, 1, 5),
('Olym Pianus OP9908-77MS', 4, 6000000, N'Đồng hồ cơ với thiết kế nam tính từ Olym Pianus', 38, 3, 'Olym Pianus OP9908-77MS.jpg', 4, 1, 10),
('G-Shock Speedmaster', 5, 1400000, N'Mẫu đồng hồ biểu tượng từng chinh phục mặt trăng từ G-Shock', 7, 2, 'G-Shock Speedmaster.jpg', 5, 1, 7),
('Orient Star Retro-Future', 6, 900000, N'Mẫu đồng hồ với thiết kế đậm chất tương lai từ Orient', 25, 1, 'Orient Star Retro-Future.jpg', 6, 1, 12),
('Seiko Presage SRPB41J1', 7, 950000, N'Đồng hồ cơ với mặt số thanh lịch từ Seiko', 30, 3, 'Seiko Presage SRPB41J1.jpg', 7, 1, 15),
('Tissot T-Race', 8, 7150000, N'Đồng hồ đua xe thể thao từ Tissot', 20, 3, 'Tissot T-Race.jpg', 8, 1, 20),
('Casio Pro Trek PRG-240', 1, 1900000, N'Đồng hồ dành cho người thích khám phá từ Casio', 22, 3, 'Casio Pro Trek PRG-240.jpg', 1, 1, 10),
('G-Shock Dimesion', 5, 1060000, N'Đồng hồ lặn cao cấp từ Omega', 8, 2, 'G-Shock Dimesion.jpg', 5, 1, 8),
('Seiko Lavio', 7, 1900000, N'Đồng hồ thể thao bền bỉ từ Seiko', 60, 2, 'Seiko Lavio.jpg', 7, 1, 12),
('Citizen Promaster Diver', 2, 1050000, N'Đồng hồ lặn chuyên nghiệp với công nghệ Eco-Drive từ Citizen', 18, 1, 'Citizen Promaster Diver.jpg', 2, 1, 7);
-- casio 5  bentley 2 Citizen 4 Orient 5 Olym 5 Seiko 3 Tissot 3 G-Shock 3

INSERT INTO Product (ProductName, BrandID, Price, Description, StockQuantity, CategoryID, ImageUrl, SupplierID, CreatedBy, Discount)
VALUES 
('Casio Hamany', 1, 350000, N'Đồng hồ Casio Hamany bền bỉ và phong cách từ Casio', 40, 1, 'Casio Hamany.jpg', 1, 1, 15),
('Casio Baby-G', 1, 2800000, N'Đồng hồ Baby-G dành cho nữ, thiết kế hiện đại', 30, 3, 'Casio Baby-G.jpg', 1, 1, 12),
('Casio Vintage', 1, 1800000, N'Đồng hồ Casio Vintage phong cách cổ điển', 25, 1, 'Casio Vintage.jpg', 1, 1, 8),
('Casio Pro Trek 7820G', 1, 5000000, N'Đồng hồ Casio Pro Trek dành cho các hoạt động ngoài trời', 20,1, 'Casio Pro Trek 7820G.jpg', 1, 1, 25),
('Casio Sheen', 1, 2700000, N'Đồng hồ Casio Sheen thanh lịch dành cho nữ', 35, 3, 'Casio Sheen.jpg', 1, 1, 10);
-- 8 bently
INSERT INTO Product (ProductName, BrandID, Price, Description, StockQuantity, CategoryID, ImageUrl, SupplierID, CreatedBy, Discount)
VALUES 
('Bentley Supper', 3, 290000, N'Mẫu đồng hồ cao cấp với thiết kế tối giản từ Bentley', 4, 3, 'Bentley Supper.jpg', 3, 1, 5),
('Bentley Heritage', 3, 3500000, N'Đồng hồ Bentley Heritage với phong cách cổ điển', 10, 3, 'Bentley Heritage.jpg', 3, 1, 7),
('Bentley Aviator', 3, 4200000, N'Đồng hồ Bentley Aviator dành cho những người yêu thích phong cách phi công', 6, 2, 'Bentley Aviator.jpg', 3, 1, 18),
('Bentley Explorer', 3, 3800000, N'Bentley Explorer với thiết kế mạnh mẽ, phù hợp cho các hoạt động ngoài trời', 8, 1, 'Bentley Explorer.jpg', 3, 1, 12),
('Bentley Urban', 3, 2700000, N'Mẫu đồng hồ Bentley Urban với thiết kế hiện đại', 15, 3, 'Bentley Urban.jpg', 3, 1, 5),
('Bentley Sport', 3, 3300000, N'Đồng hồ Bentley Sport thiết kế thể thao, chống nước tốt', 12, 3, 'Bentley Sport.jpg', 3, 1, 8),
('Bentley Elegance', 3, 310000, N'Đồng hồ Bentley Elegance với phong cách thanh lịch dành cho doanh nhân', 7, 3, 'Bentley Elegance.jpg', 3, 1, 6),
('Bentley Night Vision', 3, 4500000, N'Bentley Night Vision với chức năng dạ quang và thiết kế nổi bật', 5, 3, 'Bentley Night Vision.jpg', 3, 1, 10);
-- 6 Citizen
INSERT INTO Product (ProductName, BrandID, Price, Description, StockQuantity, CategoryID, ImageUrl, SupplierID, CreatedBy, Discount)
VALUES 
('Citizen lammidision', 2, 1050000, N'Đồng hồ lặn chuyên nghiệp với công nghệ tăng tốc từ Citizen', 18, 2, 'Citizen lammidision.jpg', 2, 1, 7),
('Citizen Eco-Drive Titanium', 2, 3200000, N'Mẫu đồng hồ bền bỉ và nhẹ nhàng với công nghệ Eco-Drive và chất liệu Titanium', 10, 1, 'Citizen Eco-Drive Titanium.jpg', 2, 1, 5),
('Citizen Chronograph CA0695', 2, 10500000, N'Đồng hồ Citizen Chronograph với mặt số phụ và tính năng bấm giờ', 15, 1, 'Citizen Chronograph CA0695.jpg', 2, 1, 8),
('Citizen Classic Automatic', 2, 6800000, N'Đồng hồ cơ tự động với thiết kế cổ điển, phù hợp cho mọi lứa tuổi', 25, 3, 'Citizen Classic Automatic.jpg', 2, 1, 3),
('Citizen Super Titanium', 2, 5400000, N'Mẫu đồng hồ cao cấp với lớp vỏ Titanium siêu bền, siêu nhẹ', 12, 3, 'Citizen Super Titanium.jpg', 2, 1, 12),
('Citizen Elegant Lady', 2, 2300000, N'Đồng hồ Citizen dành cho nữ giới với thiết kế thanh lịch và trang nhã', 20, 3, 'Citizen Elegant Lady.jpg', 2, 1, 6);
-- 5 Orient
INSERT INTO Product (ProductName, BrandID, Price, Description, StockQuantity, CategoryID, ImageUrl, SupplierID, CreatedBy, Discount)
VALUES 
('Orient Fama II', 6, 900000, N'Mẫu đồng hồ với thiết kế đậm chất tương lai từ Orient', 25, 2, 'Orient Fama II.jpg', 6, 1, 4),
('Orient Sun and Moon', 6, 1450000, N'Đồng hồ với tính năng hiển thị mặt trời và mặt trăng độc đáo', 15, 1, 'Orient Sun and Moon.jpg', 6, 1, 10),
('Orient Mako II', 6, 2700000, N'Mẫu đồng hồ lặn thể thao, phù hợp cho những chuyến phiêu lưu', 20, 2, 'Orient Mako II.jpg', 6, 1, 8),
('Orient Star Retrograde', 6, 3500000, N'Đồng hồ tự động với chức năng chỉ phút lùi độc đáo', 10, 2, 'Orient Star Retrograde.jpg', 6, 1, 30),
('Orient Conaiti', 6, 7500000, N'Mẫu đồng hồ cơ với thiết kế cổ điển, thanh lịch', 30, 2, 'Orient Conaiti.jpg', 6, 1, 5);
-- 5 Olym
INSERT INTO Product (ProductName, BrandID, Price, Description, StockQuantity, CategoryID, ImageUrl, SupplierID, CreatedBy, Discount)
VALUES 
('Olym Pianus OP9908-77KH', 4, 6000000, N'Đồng hồ cơ với thiết kế nam tính từ Olym Pianus', 38, 3, 'Olym Pianus OP9908-77KH.jpg', 4, 1, 10),
('Olym Pianus OP9908-77MT', 4, 5800000, N'Đồng hồ cơ với thiết kế sang trọng và lịch lãm', 25, 3, 'Olym Pianus OP9908-77MT.jpg', 4, 1, 22),
('Olym Pianus OP9908-77MB', 4, 6500000, N'Mẫu đồng hồ cơ với chất liệu cao cấp', 30, 1, 'Olym Pianus OP9908-77MB.jpg', 4, 1, 15),
('Olym Pianus OP9908-77A', 4, 7000000, N'Dòng đồng hồ nam với tính năng vượt trội', 22, 2, 'Olym Pianus OP9908-77A.jpg', 4, 1, 8),
('Olym Pianus OP9908-77D', 4, 7200000, N'Đồng hồ với thiết kế thể thao và năng động', 18, 2, 'Olym Pianus OP9908-77D.jpg', 4, 1, 5);
--7 Seiko
INSERT INTO Product (ProductName, BrandID, Price, Description, StockQuantity, CategoryID, ImageUrl, SupplierID, CreatedBy, Discount)
VALUES 
('Seiko Zimtal', 7, 1900000, N'Đồng hồ thể thao bền bỉ từ Seiko', 60, 3, 'Seiko Zimtal.jpg', 7, 1, 12),
('Seiko Prospex Diver', 7, 580000, N'Đồng hồ lặn chuyên nghiệp từ Seiko', 40, 1, 'Seiko Prospex Diver.jpg', 7, 1, 10),
('Seiko Presage Automatic', 7, 9200000, N'Đồng hồ tự động với thiết kế tinh tế từ Seiko', 25, 3, 'Seiko Presage Automatic.jpg', 7, 1, 32),
('Seiko Supper Sports', 7, 690000, N'Đồng hồ thể thao với phong cách trẻ trung từ Seiko', 50, 2, 'Seiko Supper Sports.jpg', 7, 1, 8),
('Seiko Astron GPS', 7, 15000000, N'Đồng hồ thông minh với công nghệ GPS từ Seiko', 10, 3, 'Seiko Astron GPS.jpg', 7, 1, 5),
('Seiko Coutura', 7, 6500000, N'Đồng hồ thời trang với thiết kế hiện đại từ Seiko', 30, 2, 'Seiko Coutura.jpg', 7, 1, 10),
('Seiko Kinetic', 7, 4000000, N'Đồng hồ Kinetic với công nghệ tiên tiến từ Seiko', 15, 1, 'Seiko Kinetic.jpg', 7, 1, 12);
--7 Tissot 
INSERT INTO Product (ProductName, BrandID, Price, Description, StockQuantity, CategoryID, ImageUrl, SupplierID, CreatedBy, Discount)
VALUES 
('Tissot PRS 516', 8, 1300000, N'Đồng hồ thể thao với thiết kế đẳng cấp từ Tissot', 15, 3, 'Tissot PRS 516.jpg', 8, 1, 15),
('Tissot Everytime', 8, 950000, N'Mẫu đồng hồ thanh lịch và đơn giản từ Tissot', 25, 1, 'Tissot Everytime.jpg', 8, 1, 10),
('Tissot Le Locle', 8, 2500000, N'Đồng hồ cơ với thiết kế tinh tế từ Tissot', 10, 2, 'Tissot Le Locle.jpg', 8, 1, 5),
('Tissot Quickster', 8, 1100000, N'Đồng hồ thể thao năng động với màu sắc nổi bật từ Tissot', 30, 1, 'Tissot Quickster.jpg', 8, 1, 12),
('Tissot V8', 8, 1600000, N'Đồng hồ thể thao mạnh mẽ và nam tính từ Tissot', 18, 2, 'Tissot V8.jpg', 8, 1, 10),
('Tissot Heritage', 8, 1450000, N'Đồng hồ mang đậm phong cách cổ điển từ Tissot', 12, 3, 'Tissot Heritage.jpg', 8, 1, 8),
('Tissot Couturier', 8, 1800000, N'Đồng hồ thời trang với thiết kế sang trọng từ Tissot', 16, 3, 'Tissot Couturier.jpg', 8, 1, 7);
-- 7 G-Shock
INSERT INTO Product (ProductName, BrandID, Price, Description, StockQuantity, CategoryID, ImageUrl, SupplierID, CreatedBy, Discount)
VALUES 
('G-Shock Mudmaster', 5, 1500000, N'Đồng hồ chống bùn bền bỉ, thiết kế thể thao từ G-Shock', 12, 2, 'G-Shock Mudmaster.jpg', 5, 1, 10),
('G-Shock Rangeman', 5, 1650000, N'Mẫu đồng hồ G-Shock chuyên dụng cho các hoạt động ngoài trời', 10, 2, 'G-Shock Rangeman.jpg', 5, 1, 5),
('G-Shock Gravitymaster', 5, 1800000, N'Đồng hồ G-Shock thiết kế hiện đại với tính năng đo độ cao', 15, 2, 'G-Shock Gravitymaster.jpg', 5, 1, 7),
('G-Shock GA-2100', 5, 1300000, N'Dòng đồng hồ G-Shock với thiết kế mỏng nhẹ và trẻ trung', 20, 3, 'G-Shock GA-2100.jpg', 5, 1, 8),
('G-Shock GA-700', 5, 1200000, N'Đồng hồ thể thao với thiết kế mạnh mẽ, đầy cá tính từ G-Shock', 25, 2, 'G-Shock GA-700.jpg', 5, 1, 10),
('G-Shock DW-5600', 5, 3100000, N'Mẫu đồng hồ G-Shock cổ điển với thiết kế đơn giản và bền bỉ', 30, 2, 'G-Shock DW-5600.jpg', 5, 1, 5),
('G-Shock GA-100', 5, 1250000, N'Đồng hồ G-Shock với thiết kế thể thao, năng động', 18, 2, 'G-Shock GA-100.jpg', 5, 1, 2);

UPDATE Product
SET CreatedAt = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % DATEDIFF(DAY, '2023-01-01', '2024-08-01')), '2023-01-01');

-- video hồng hồ
CREATE TABLE Video (
    VideoID INT PRIMARY KEY IDENTITY(1,1), 
    ProductID INT NOT NULL,
    URLVideo NVARCHAR(255) NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);
INSERT INTO Video (ProductID, URLVideo)
VALUES
    (1, 'https://www.youtube.com/watch?v=nRyYAQeRoqc'),	
    (2, 'https://www.youtube.com/watch?v=xDLs1Q5YU14'),
    (3, 'https://www.youtube.com/watch?v=MJz_8NjOV5o'),
    (4, 'https://www.youtube.com/watch?v=grlFXtA4Rws'),
	(5, 'https://www.youtube.com/watch?v=KXBdLfH-LyQ'),
	(6, 'https://www.youtube.com/watch?v=i5lUmxVxIAE'),
	(7, 'https://www.youtube.com/watch?v=ucfTKpPpJwk'),
	(8, 'https://www.youtube.com/watch?v=tfICRk17Ix8'),
	(9, 'https://www.youtube.com/watch?v=te7Bz6Fh02A'),
	(10, 'https://www.youtube.com/watch?v=te7Bz6Fh02A'),
    (11, 'https://www.youtube.com/watch?v=hZw8dgjA394'),	
    (12, 'https://www.youtube.com/watch?v=hZw8dgjA394'),
    (13, 'https://www.youtube.com/watch?v=QOBG66hQ2wo'),
    (14, 'https://www.youtube.com/watch?v=QOBG66hQ2wo'),
	(15, 'https://www.youtube.com/watch?v=FZxTPejOWn4'),
	(16, 'https://www.youtube.com/watch?v=FZxTPejOWn4'),
	(17, 'https://www.youtube.com/watch?v=FZxTPejOWn4'),
	(18, 'https://www.youtube.com/watch?v=AFaDcK5_n_c'),
	(19, 'https://www.youtube.com/watch?v=AFaDcK5_n_c'),
	(20, 'https://www.youtube.com/watch?v=9dQf6R_LMvA'),
    (21, 'https://www.youtube.com/watch?v=9dQf6R_LMvA'),	
    (22, 'https://www.youtube.com/watch?v=11nzGzILta8'),
    (23, 'https://www.youtube.com/watch?v=11nzGzILta8'),
    (24, 'https://www.youtube.com/watch?v=yDzv7grPrkQ'),
	(25, 'https://www.youtube.com/watch?v=yDzv7grPrkQ'),
	(26, 'https://www.youtube.com/watch?v=yDzv7grPrkQ'),
	(27, 'https://www.youtube.com/watch?v=o49l6eSE0ZI'),
	(28, 'https://www.youtube.com/watch?v=o49l6eSE0ZI'),
	(29, 'https://www.youtube.com/watch?v=lJHtyM_bApA'),
	(30, 'https://www.youtube.com/watch?v=lJHtyM_bApA'),
	(31, 'https://www.youtube.com/watch?v=iOgz_4X_sVs'),
	(32, 'https://www.youtube.com/watch?v=iOgz_4X_sVs'),
	(33, 'https://www.youtube.com/watch?v=3rI05jfhdcw'),
	(34, 'https://www.youtube.com/watch?v=3rI05jfhdcw'),
	(35, 'https://www.youtube.com/watch?v=9zi_rq27V7U'),
	(36, 'https://www.youtube.com/watch?v=9zi_rq27V7U'),
	(37, 'https://www.youtube.com/watch?v=wW78n4k6pnk'),
	(38, 'https://www.youtube.com/watch?v=wW78n4k6pnk'),
	(39, 'https://www.youtube.com/watch?v=iXh-Peo7WfA'),
	(40, 'https://www.youtube.com/watch?v=iXh-Peo7WfA'),
	(41, 'https://www.youtube.com/watch?v=_Ye5szXE9Jw'),
	(42, 'https://www.youtube.com/watch?v=_Ye5szXE9Jw'),
	(43, 'https://www.youtube.com/watch?v=QaqdnelK8vY'),
	(44, 'https://www.youtube.com/watch?v=QaqdnelK8vY'),
	(45, 'https://www.youtube.com/watch?v=Iebp9fW3Efw'),
	(46, 'https://www.youtube.com/watch?v=Iebp9fW3Efw'),
	(47, 'https://www.youtube.com/watch?v=M9L6XpnMb4U'),
	(49, 'https://www.youtube.com/watch?v=M9L6XpnMb4U'),
	(50, 'https://www.youtube.com/watch?v=Bfygt-AmDGc'),
	(51, 'https://www.youtube.com/watch?v=Bfygt-AmDGc'),
	(52, 'https://www.youtube.com/watch?v=umpwBRSFSzs'),
	(53, 'https://www.youtube.com/watch?v=umpwBRSFSzs'),
	(54, 'https://www.youtube.com/watch?v=QOBG66hQ2wo'),
	(55, 'https://www.youtube.com/watch?v=QOBG66hQ2wo'),
	(56, 'https://www.youtube.com/watch?v=QaqdnelK8vY'),
	(57, 'https://www.youtube.com/watch?v=iXh-Peo7WfA'),
	(58, 'https://www.youtube.com/watch?v=iOgz_4X_sVs'),
	(59, 'https://www.youtube.com/watch?v=yDzv7grPrkQ'),
	(60, 'https://www.youtube.com/watch?v=wW78n4k6pnk'),
	(61, 'https://www.youtube.com/watch?v=Iebp9fW3Efw'),
	(62, 'https://www.youtube.com/watch?v=_Ye5szXE9Jw'),
	(63, 'https://www.youtube.com/watch?v=QOBG66hQ2wo'),
	(64, 'https://www.youtube.com/watch?v=umpwBRSFSzs'),
	(65, 'https://www.youtube.com/watch?v=Bfygt-AmDGc'),
	(66, 'https://www.youtube.com/watch?v=_Ye5szXE9Jw'),
	(67, 'https://www.youtube.com/watch?v=_Ye5szXE9Jw'),
	(68, 'https://www.youtube.com/watch?v=wW78n4k6pnk'),
	(69, 'https://www.youtube.com/watch?v=3rI05jfhdcw'),
	(70, 'https://www.youtube.com/watch?v=iOgz_4X_sVs'),
	(71, 'https://www.youtube.com/watch?v=Bfygt-AmDGc'),
	(72, 'https://www.youtube.com/watch?v=M9L6XpnMb4U'),
	(73, 'https://www.youtube.com/watch?v=Iebp9fW3Efw'),
	(74, 'https://www.youtube.com/watch?v=QaqdnelK8vY'),
	(75, 'https://www.youtube.com/watch?v=_Ye5szXE9Jw'),
	(76, 'https://www.youtube.com/watch?v=iXh-Peo7WfA'),
	(77, 'https://www.youtube.com/watch?v=wW78n4k6pnk'),
	(78, 'https://www.youtube.com/watch?v=QOBG66hQ2wo'),
	(79, 'https://www.youtube.com/watch?v=3rI05jfhdcw'),
	(80, 'https://www.youtube.com/watch?v=9zi_rq27V7U');






-- Tạo bảng Images mặc định
CREATE TABLE Images_Default (
    ImageID INT PRIMARY KEY IDENTITY(1,1), 
    ProductID INT NOT NULL,
    URL_Images_Default NVARCHAR(50) NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);
INSERT INTO Images_Default (ProductID, URL_Images_Default)
VALUES 
-- Product 1 đến 30
(1, '1.jpg'), (1, '2.jpg'), (1, '3.jpg'), (1, '4.jpg'), (1, '5.jpg'),
(2, '1.jpg'), (2, '2.jpg'), (2, '3.jpg'), (2, '4.jpg'), (2, '5.jpg'),
(3, '1.jpg'), (3, '2.jpg'), (3, '3.jpg'), (3, '4.jpg'), (3, '5.jpg'),
(4, '1.jpg'), (4, '2.jpg'), (4, '3.jpg'), (4, '4.jpg'), (4, '5.jpg'),
(5, '1.jpg'), (5, '2.jpg'), (5, '3.jpg'), (5, '4.jpg'), (5, '5.jpg'),
(6, '1.jpg'), (6, '2.jpg'), (6, '3.jpg'), (6, '4.jpg'), (6, '5.jpg'),
(7, '1.jpg'), (7, '2.jpg'), (7, '3.jpg'), (7, '4.jpg'), (7, '5.jpg'),
(8, '1.jpg'), (8, '2.jpg'), (8, '3.jpg'), (8, '4.jpg'), (8, '5.jpg'),
(9, '1.jpg'), (9, '2.jpg'), (9, '3.jpg'), (9, '4.jpg'), (9, '5.jpg'),
(10, '1.jpg'), (10, '2.jpg'), (10, '3.jpg'), (10, '4.jpg'), (10, '5.jpg'),
(11, '1.jpg'), (11, '2.jpg'), (11, '3.jpg'), (11, '4.jpg'), (11, '5.jpg'),
(12, '1.jpg'), (12, '2.jpg'), (12, '3.jpg'), (12, '4.jpg'), (12, '5.jpg'),
(13, '1.jpg'), (13, '2.jpg'), (13, '3.jpg'), (13, '4.jpg'), (13, '5.jpg'),
(14, '1.jpg'), (14, '2.jpg'), (14, '3.jpg'), (14, '4.jpg'), (14, '5.jpg'),
(15, '1.jpg'), (15, '2.jpg'), (15, '3.jpg'), (15, '4.jpg'), (15, '5.jpg'),
(16, '1.jpg'), (16, '2.jpg'), (16, '3.jpg'), (16, '4.jpg'), (16, '5.jpg'),
(17, '1.jpg'), (17, '2.jpg'), (17, '3.jpg'), (17, '4.jpg'), (17, '5.jpg'),
(18, '1.jpg'), (18, '2.jpg'), (18, '3.jpg'), (18, '4.jpg'), (18, '5.jpg'),
(19, '1.jpg'), (19, '2.jpg'), (19, '3.jpg'), (19, '4.jpg'), (19, '5.jpg'),
(20, '1.jpg'), (20, '2.jpg'), (20, '3.jpg'), (20, '4.jpg'), (20, '5.jpg'),
(21, '1.jpg'), (21, '2.jpg'), (21, '3.jpg'), (21, '4.jpg'), (21, '5.jpg'),
(22, '1.jpg'), (22, '2.jpg'), (22, '3.jpg'), (22, '4.jpg'), (22, '5.jpg'),
(23, '1.jpg'), (23, '2.jpg'), (23, '3.jpg'), (23, '4.jpg'), (23, '5.jpg'),
(24, '1.jpg'), (24, '2.jpg'), (24, '3.jpg'), (24, '4.jpg'), (24, '5.jpg'),
(25, '1.jpg'), (25, '2.jpg'), (25, '3.jpg'), (25, '4.jpg'), (25, '5.jpg'),
(26, '1.jpg'), (26, '2.jpg'), (26, '3.jpg'), (26, '4.jpg'), (26, '5.jpg'),
(27, '1.jpg'), (27, '2.jpg'), (27, '3.jpg'), (27, '4.jpg'), (27, '5.jpg'),
(28, '1.jpg'), (28, '2.jpg'), (28, '3.jpg'), (28, '4.jpg'), (28, '5.jpg'),
(29, '1.jpg'), (29, '2.jpg'), (29, '3.jpg'), (29, '4.jpg'), (29, '5.jpg'),
(30, '1.jpg'), (30, '2.jpg'), (30, '3.jpg'), (30, '4.jpg'), (30, '5.jpg'),
(31, '1.jpg'), (31, '2.jpg'), (31, '3.jpg'), (31, '4.jpg'), (31, '5.jpg'),
(32, '1.jpg'), (32, '2.jpg'), (32, '3.jpg'), (32, '4.jpg'), (32, '5.jpg'),
(33, '1.jpg'), (33, '2.jpg'), (33, '3.jpg'), (33, '4.jpg'), (33, '5.jpg'),
(34, '1.jpg'), (34, '2.jpg'), (34, '3.jpg'), (34, '4.jpg'), (34, '5.jpg'),
(35, '1.jpg'), (35, '2.jpg'), (35, '3.jpg'), (35, '4.jpg'), (35, '5.jpg'),
-- xong 5 casio
(36, '1.jpg'), (36, '2.jpg'), (36, '3.jpg'), (36, '4.jpg'), (36, '5.jpg'),
(37, '1.jpg'), (37, '2.jpg'), (37, '3.jpg'), (37, '4.jpg'), (37, '5.jpg'),
(38, '1.jpg'), (38, '2.jpg'), (38, '3.jpg'), (38, '4.jpg'), (38, '5.jpg'),
(39, '1.jpg'), (39, '2.jpg'), (39, '3.jpg'), (39, '4.jpg'), (39, '5.jpg'),
(40, '1.jpg'), (40, '2.jpg'), (40, '3.jpg'), (40, '4.jpg'), (40, '5.jpg'),
(41, '1.jpg'), (41, '2.jpg'), (41, '3.jpg'), (41, '4.jpg'), (41, '5.jpg'),
(42, '1.jpg'), (42, '2.jpg'), (42, '3.jpg'), (42, '4.jpg'), (42, '5.jpg'),
(43, '1.jpg'), (43, '2.jpg'), (43, '3.jpg'), (43, '4.jpg'), (43, '5.jpg'),
-- xong 8 bently
(44, '1.jpg'), (44, '2.jpg'), (44, '3.jpg'), (44, '4.jpg'), (44, '5.jpg'),
(45, '1.jpg'), (45, '2.jpg'), (45, '3.jpg'), (45, '4.jpg'), (45, '5.jpg'),
(46, '1.jpg'), (46, '2.jpg'), (46, '3.jpg'), (46, '4.jpg'), (46, '5.jpg'),
(47, '1.jpg'), (47, '2.jpg'), (47, '3.jpg'), (47, '4.jpg'), (47, '5.jpg'),
(48, '1.jpg'), (48, '2.jpg'), (48, '3.jpg'), (48, '4.jpg'), (48, '5.jpg'),
(49, '1.jpg'), (49, '2.jpg'), (49, '3.jpg'), (49, '4.jpg'), (49, '5.jpg'),
-- xg cizi
(50, '1.jpg'), (50, '2.jpg'), (50, '3.jpg'), (50, '4.jpg'), (50, '5.jpg'),
(51, '1.jpg'), (51, '2.jpg'), (51, '3.jpg'), (51, '4.jpg'), (51, '5.jpg'),
(52, '1.jpg'), (52, '2.jpg'), (52, '3.jpg'), (52, '4.jpg'), (52, '5.jpg'),
(53, '1.jpg'), (53, '2.jpg'), (53, '3.jpg'), (53, '4.jpg'), (53, '5.jpg'),
(54, '1.jpg'), (54, '2.jpg'), (54, '3.jpg'), (54, '4.jpg'), (54, '5.jpg'),
-- xg Ori
(55, '1.jpg'), (55, '2.jpg'), (55, '3.jpg'), (55, '4.jpg'), (55, '5.jpg'),
(56, '1.jpg'), (56, '2.jpg'), (56, '3.jpg'), (56, '4.jpg'), (56, '5.jpg'),
(57, '1.jpg'), (57, '2.jpg'), (57, '3.jpg'), (57, '4.jpg'), (57, '5.jpg'),
(58, '1.jpg'), (58, '2.jpg'), (58, '3.jpg'), (58, '4.jpg'), (58, '5.jpg'),
(59, '1.jpg'), (59, '2.jpg'), (59, '3.jpg'), (59, '4.jpg'), (59, '5.jpg'),
-- xong Olym
(60, '1.jpg'), (60, '2.jpg'), (60, '3.jpg'), (60, '4.jpg'), (60, '5.jpg'),
(61, '1.jpg'), (61, '2.jpg'), (61, '3.jpg'), (61, '4.jpg'), (61, '5.jpg'),
(62, '1.jpg'), (62, '2.jpg'), (62, '3.jpg'), (62, '4.jpg'), (62, '5.jpg'),
(63, '1.jpg'), (63, '2.jpg'), (63, '3.jpg'), (63, '4.jpg'), (63, '5.jpg'),
(64, '1.jpg'), (64, '2.jpg'), (64, '3.jpg'), (64, '4.jpg'), (64, '5.jpg'),
(65, '1.jpg'), (65, '2.jpg'), (65, '3.jpg'), (65, '4.jpg'), (65, '5.jpg'),
(66, '1.jpg'), (66, '2.jpg'), (66, '3.jpg'), (66, '4.jpg'), (66, '5.jpg'),
-- xg 7 seiko
(67, '1.jpg'), (67, '2.jpg'), (67, '3.jpg'), (67, '4.jpg'), (67, '5.jpg'),
(68, '1.jpg'), (68, '2.jpg'), (68, '3.jpg'), (68, '4.jpg'), (68, '5.jpg'),
(69, '1.jpg'), (69, '2.jpg'), (69, '3.jpg'), (69, '4.jpg'), (69, '5.jpg'),
(70, '1.jpg'), (70, '2.jpg'), (70, '3.jpg'), (70, '4.jpg'), (70, '5.jpg'),
(71, '1.jpg'), (71, '2.jpg'), (71, '3.jpg'), (71, '4.jpg'), (71, '5.jpg'),
(72, '1.jpg'), (72, '2.jpg'), (72, '3.jpg'), (72, '4.jpg'), (72, '5.jpg'),
(73, '1.jpg'), (73, '2.jpg'), (73, '3.jpg'), (73, '4.jpg'), (73, '5.jpg'),
--xg tissot
(74, '1.jpg'), (74, '2.jpg'), (74, '3.jpg'), (74, '4.jpg'), (74, '5.jpg'),
(75, '1.jpg'), (75, '2.jpg'), (75, '3.jpg'), (75, '4.jpg'), (75, '5.jpg'),
(76, '1.jpg'), (76, '2.jpg'), (76, '3.jpg'), (76, '4.jpg'), (76, '5.jpg'),
(77, '1.jpg'), (77, '2.jpg'), (77, '3.jpg'), (77, '4.jpg'), (77, '5.jpg'),
(78, '1.jpg'), (78, '2.jpg'), (78, '3.jpg'), (78, '4.jpg'), (78, '5.jpg'),
(79, '1.jpg'), (79, '2.jpg'), (79, '3.jpg'), (79, '4.jpg'), (79, '5.jpg'),
(80, '1.jpg'), (80, '2.jpg'), (80, '3.jpg'), (80, '4.jpg'), (80, '5.jpg');
-- xong G-Shock


--img ChungNhan
CREATE TABLE Images_Certification (
    ImageID INT PRIMARY KEY IDENTITY(1,1), 
    BrandID INT NOT NULL,
    URL_Images_Certification NVARCHAR(50) NOT NULL,
    FOREIGN KEY (BrandID) REFERENCES Brand(BrandID)
);
INSERT INTO Images_Certification (BrandID, URL_Images_Certification)
VALUES 
(1, 'Casio.jpg'),
(2, 'Citizen.jpg'), 
(3, 'Hublot.jpg'), 
(4, 'Olym Pianus.jpg'), 
(5, 'Omega.jpg'),
(6, 'Orient.jpg'),
(7, 'Seiko.jpg'),
(8, 'Tissot.jpg');



--  img Trên tay
CREATE TABLE Images_Reality (
    ImageID INT PRIMARY KEY IDENTITY(1,1), 
    ProductID INT NOT NULL,
    URL_Images_Reality NVARCHAR(50) NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);
INSERT INTO Images_Reality (ProductID, URL_Images_Reality)
VALUES 
(1, '1.jpg'),
(2, '1.jpg'),
(3, '1.jpg'),
(4, '1.jpg'),
(5, '1.jpg'),
(6, '1.jpg'),
(7, '1.jpg'),
(8, '1.jpg'),
(9, '1.jpg'),
(10, '1.jpg'),
(11, '1.jpg'),
(12, '1.jpg'),
(13, '1.jpg'),
(14, '1.jpg'),
(15, '1.jpg'),
(16, '1.jpg'),
(17, '1.jpg'),
(18, '1.jpg'),
(19, '1.jpg'),
(20, '1.jpg'),
(21, '1.jpg'),
(22, '1.jpg'),
(23, '1.jpg'),
(24, '1.jpg'),
(25, '1.jpg'),
(26, '1.jpg'),
(27, '1.jpg'),
(28, '1.jpg'),
(29, '1.jpg'),
(30, '1.jpg'),
(31, '1.jpg'),
(32, '1.jpg'),
(33, '1.jpg'),
(34, '1.jpg'),
(35, '1.jpg'),
-- xong 5 casio
(36, '1.jpg'),
(37, '1.jpg'),
(38, '1.jpg'),
(39, '1.jpg'),
(40, '1.jpg'),
(41, '1.jpg'),
(42, '1.jpg'),
(43, '1.jpg'),
-- xog 8bently
(44, '1.jpg'),
(45, '1.jpg'),
(46, '1.jpg'),
(47, '1.jpg'),
(48, '1.jpg'),
(49, '1.jpg'),
-- xog cizi
(50, '1.jpg'),
(51, '1.jpg'),
(52, '1.jpg'),
(53, '1.jpg'),
(54, '1.jpg'),
-- xong Ori
(55, '1.jpg'),
(56, '1.jpg'),
(57, '1.jpg'),
(58, '1.jpg'),
(59, '1.jpg'),
--xg Oply
(60, '1.jpg'),
(61, '1.jpg'),
(62, '1.jpg'),
(63, '1.jpg'),
(64, '1.jpg'),
(65, '1.jpg'),
(66, '1.jpg'),
-- xg seiko
(67, '1.jpg'),
(68, '1.jpg'),
(69, '1.jpg'),
(70, '1.jpg'),
(71, '1.jpg'),
(72, '1.jpg'),
(73, '1.jpg'),
-- xg tissot
(74, '1.jpg'),
(75, '1.jpg'),
(76, '1.jpg'),
(77, '1.jpg'),
(78, '1.jpg'),
(79, '1.jpg'),
(80, '1.jpg');
-- xg G-Shock

-- chi tiết đồng hồ
create table Detail(
		ID_Detail int primary key identity(1,1),
		ProductID int not null,
		Waterproof nvarchar(30) not null, /*kháng nước*/
		Origin nvarchar(100)not null, -- xuất xứ
		GlassMaterial  nvarchar(50) not null,/* chất liệu kính*/
		Material nvarchar(100) not null,-- chất liệu dây
		Thickness nvarchar(30) not null,/* độ dầy*/
		FaceSize nvarchar(30) not null, -- size mặt
		Typeof nvarchar(30) not null, /*loại máy*/
		GenderObject nvarchar(20),
		FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

INSERT INTO Detail (ProductID, Waterproof, GlassMaterial, Thickness, FaceSize, Typeof, GenderObject,material,Origin) 
VALUES
(1, N'10 ATM', N'Sapphire', N'12mm', N'41mm', N'Automatic', N'Nam',N'Dây Inox',N'Nhật Bản'),
(2, N'30 ATM', N'Sapphire', N'13mm', N'42mm', N'Automatic', N'Nam',N'Dây Nhựa',N'Nhật Bản'), 
(3, N'20 ATM', N'Mineral', N'15mm', N'45mm', N'Pin/Quartz', N'cả Nam và Nữ',N'Dây Da',N'Pháp'), 
(4, N'5 ATM', N'Hardlex', N'11mm', N'40mm', N'Automatic', N'cả Nam và Nữ',N'Dây Da',N'Pháp'),
(5, N'10 ATM', N'Sapphire', N'13mm', N'41mm', N'Quartz', N'Nữ', N'Dây Kim Loại', N'Nhật Bản'),
(6, N'50 ATM', N'Sapphire', N'17mm', N'45mm', N'Automatic', N'Nữ', N'Dây Da', N'Hoa Kỳ'),
(7, N'3 ATM', N'Mineral', N'8mm', N'38mm', N'Quartz', N'Nữ', N'Dây Kim Loại', N'Hoa Kỳ'),
(8, N'10 ATM', N'Sapphire', N'10mm', N'40mm', N'Quartz', N'Nam', N'Dây Thép', N'Thụy Sỹ'),
(9, N'5 ATM', N'Sapphire', N'12mm', N'42mm', N'Automatic', N'cả Nam và Nữ', N'Dây Thép', N'Hàn Quốc'),
(10, N'20 ATM', N'Sapphire', N'14mm', N'44mm', N'Quartz', N'cả Nam và Nữ', N'Dây Bạc', N'Hàn Quốc'),
(11, N'10 ATM', N'Hardlex', N'9mm', N'39mm', N'Quartz', N'Nữ', N'Dây Da', N'Đức'),
(12, N'30 ATM', N'Sapphire', N'16mm', N'46mm', N'Automatic', N'Nam', N'Dây Kim Loại', N'Pháp'),
(13, N'5 ATM', N'Sapphire', N'12mm', N'40mm', N'Quartz', N'Cả Nam và Nữ', N'Dây Nhựa', N'Nhật Bản'),
(14, N'10 ATM', N'Sapphire', N'11mm', N'42mm', N'Automatic', N'Nữ', N'Dây Da', N'Hoa Kỳ'),
(15, N'3 ATM', N'Mineral', N'10mm', N'38mm', N'Quartz', N'Cả Nam và Nữ', N'Dây Dù', N'Ba Lan'),
(16, N'20 ATM', N'Sapphire', N'13mm', N'43mm', N'Automatic', N'cả Nam và Nữ', N'Dây Kim Loại', N'Thụy Sỹ'),
(17, N'50 ATM', N'Sapphire', N'18mm', N'47mm', N'Quartz', N'Nam', N'Dây Da', N'Nhật Bản'),
(18, N'5 ATM', N'Mineral', N'10mm', N'39mm', N'Quartz', N'Nữ', N'Dây Da', N'Pháp'),
(19, N'10 ATM', N'Sapphire', N'12mm', N'41mm', N'Automatic', N'Nữ', N'Dây Thép', N'Nhật Bản'),
(20, N'30 ATM', N'Sapphire', N'15mm', N'44mm', N'Quartz', N'cả Nam và Nữ', N'Dây Bạc', N'Nhật Bản'),
(21, N'5 ATM', N'Sapphire', N'11mm', N'40mm', N'Quartz', N'cả Nam và Nữ', N'Dây Da', N'Đức'),
(22, N'10 ATM', N'Hardlex', N'13mm', N'42mm', N'Automatic', N'Nữ', N'Dây Da', N'Pháp'),
(23, N'20 ATM', N'Sapphire', N'17mm', N'45mm', N'Quartz', N'Nam', N'Dây Kim Loại', N'Nhật Bản'),
(24, N'3 ATM', N'Hardlex', N'9mm', N'38mm', N'Quartz', N'Nữ', N'Dây Bạc', N'Hoa Kỳ'),
(25, N'10 ATM', N'Sapphire', N'10mm', N'40mm', N'Automatic', N'Nữ', N'Dây Thép', N'Ba Lan'),
(26, N'50 ATM', N'Sapphire', N'14mm', N'46mm', N'Quartz', N'Nữ', N'Dây Dù', N'Thụy Sỹ'),
(27, N'5 ATM', N'Mineral', N'11mm', N'39mm', N'Quartz', N'Cả Nam và Nữ', N'Dây Da', N'Nhật Bản'),
(28, N'10 ATM', N'Hardlex', N'12mm', N'41mm', N'Automatic', N'Nam', N'Dây Thép', N'Nhật Bản'),
(29, N'20 ATM', N'Sapphire', N'15mm', N'44mm', N'Quartz', N'cả Nam và Nữ', N'Dây Dù', N'Ba Lan'),
(30, N'10 ATM', N'Hardlex', N'13mm', N'43mm', N'Automatic', N'Nam', N'Dây Kim Loại', N'Hàn Quốc');
-- 5 casio
INSERT INTO Detail (ProductID, Waterproof, GlassMaterial, Thickness, FaceSize, Typeof, GenderObject, material, Origin)
VALUES
(31, N'20 ATM', N'Sapphire', N'13mm', N'45mm', N'Quartz', N'Nữ', N'Dây Thép', N'Nhật Bản'),
(32, N'5 ATM', N'Kính Khoáng', N'10mm', N'36mm', N'Quartz', N'Nữ', N'Dây Thép', N'Nhật Bản'),
(33, N'3 ATM', N'Kính Khoáng', N'9mm', N'38mm', N'Quartz', N'cả Nam và Nữ', N'Dây Kim Loại', N'Nhật Bản'),
(34, N'10 ATM', N'Sapphire', N'11mm', N'42mm', N'Solar', N'Nam', N'Dây Da', N'Nhật Bản'),
(35, N'5 ATM', N'Kính Khoáng', N'8mm', N'34mm', N'Quartz', N'Nữ', N'Dây Da', N'Nhật Bản');
--8 bently
INSERT INTO Detail (ProductID, Waterproof, GlassMaterial, Thickness, FaceSize, Typeof, GenderObject, material, Origin)
VALUES
(36, N'5 ATM', N'Sapphire', N'11mm', N'40mm', N'Quartz', N'Cả Nam và Nữ', N'Dây Da', N'Đức'),
(37, N'3 ATM', N'Kính Khoáng', N'10mm', N'39mm', N'Automatic', N'Nữ', N'Dây Da', N'Đức'),
(38, N'10 ATM', N'Sapphire', N'12mm', N'43mm', N'Quartz', N'Nam', N'Dây Da', N'Đức'),
(39, N'5 ATM', N'Sapphire', N'9mm', N'37mm', N'Quartz', N'Nam', N'Dây Da', N'Đức'),
(40, N'20 ATM', N'Kính Khoáng', N'13mm', N'45mm', N'Automatic', N'Nam', N'Dây Da', N'Đức'),
(41, N'10 ATM', N'Sapphire', N'11mm', N'42mm', N'Solar', N'Cả Nam và Nữ', N'Dây Da', N'Đức'),
(42, N'3 ATM', N'Kính Khoáng', N'8mm', N'34mm', N'Quartz', N'Nữ', N'Dây Bạc', N'Đức'),
(43, N'15 ATM', N'Sapphire', N'14mm', N'44mm', N'Automatic', N'Nữ', N'Dây Kim Loại', N'Đức');
-- 6 cizi
INSERT INTO Detail (ProductID, Waterproof, GlassMaterial, Thickness, FaceSize, Typeof, GenderObject, material, Origin)
VALUES 
(44, N'10 ATM', N'Sapphire', N'12mm', N'42mm', N'Quartz', N'Nam', N'Dây Da', N'Hàn Quốc'),
(45, N'5 ATM', N'Sapphire', N'11mm', N'39mm', N'Automatic', N'Nữ', N'Dây Thép', N'Hàn Quốc'),
(46, N'20 ATM', N'Sapphire', N'13mm', N'43mm', N'Quartz', N'Nam', N'Dây Kim Loại', N'Hàn Quốc'),
(47, N'3 ATM', N'Kính Khoáng', N'10mm', N'40mm', N'Automatic', N'Nữ', N'Dây Da', N'Hàn Quốc'),
(48, N'10 ATM', N'Sapphire', N'12mm', N'41mm', N'Quartz', N'cả Nam và Nữ', N'Dây Thép', N'Hàn Quốc'),
(49, N'5 ATM', N'Sapphire', N'9mm', N'36mm', N'Quartz', N'Nữ', N'Dây Kim Loại', N'Hàn Quốc');
-- 5 Ori
INSERT INTO Detail (ProductID, Waterproof, GlassMaterial, Thickness, FaceSize, Typeof, GenderObject, material, Origin)
VALUES 
(50, N'5 ATM', N'Sapphire', N'11mm', N'40mm', N'Automatic', N'Nam', N'Dây Da', N'Hoa Kỳ'),
(51, N'3 ATM', N'Sapphire', N'12mm', N'41mm', N'Automatic', N'cả Nam và Nữ', N'Dây Da', N'Hoa Kỳ'),
(52, N'20 ATM', N'Sapphire', N'13mm', N'43mm', N'Automatic', N'cả Nam và Nữ', N'Dây Da', N'Hoa Kỳ'),
(53, N'5 ATM', N'Sapphire', N'10mm', N'42mm', N'Automatic', N'Nam', N'Dây Da', N'Hoa Kỳ'),
(54, N'10 ATM', N'Sapphire', N'9mm', N'38mm', N'Automatic', N'Nữ', N'Dây Da', N'Hoa Kỳ');
-- 5 Oply
INSERT INTO Detail (ProductID, Waterproof, GlassMaterial, Thickness, FaceSize, Typeof, GenderObject, Material, Origin) 
VALUES 
(55, N'3 ATM', N'Sapphire', N'12mm', N'40mm', N'Cơ', N'Nữ', N'Dây Kim Loại', N'Pháp'),
(56, N'5 ATM', N'Sapphire', N'11mm', N'41mm', N'Cơ', N'Nữ', N'Dây Dù', N'Pháp'),
(57, N'10 ATM', N'Sapphire', N'13mm', N'42mm', N'Cơ', N'Nam', N'Dây Thép', N'Pháp'),
(58, N'3 ATM', N'Sapphire', N'12mm', N'40mm', N'Cơ', N'Nam', N'Dây Kim Loại', N'Pháp'),
(59, N'5 ATM', N'Sapphire', N'11mm', N'43mm', N'Cơ', N'Nam', N'Dây Thép', N'Pháp');
-- 7 seiko
INSERT INTO Detail (ProductID, Waterproof, GlassMaterial, Thickness, FaceSize, Typeof, GenderObject, Material, Origin) 
VALUES
(60, N'10 ATM', N'Sapphire', N'12mm', N'40mm', N'Automatic', N'Nữ', N'Dây Kim Loại', N'Ba Lan'),
(61, N'20 ATM', N'Sapphire', N'14mm', N'43mm', N'Quartz', N'Nữ', N'Dây Bạc', N'Ba Lan'),
(62, N'5 ATM', N'Sapphire', N'11mm', N'39mm', N'Automatic', N'Nữ', N'Dây Bạc', N'Ba Lan'),
(63, N'10 ATM', N'Mineral', N'13mm', N'42mm', N'Quartz', N'Nam', N'Dây Kim Loại', N'Ba Lan'),
(64, N'100m', N'Sapphire', N'15mm', N'44mm', N'Quartz', N'Nữ', N'Dây Kim Loại', N'Ba Lan'),
(65, N'5 ATM', N'Sapphire', N'12mm', N'41mm', N'Automatic', N'Nữ', N'Dây Thép', N'Ba Lan'),
(66, N'10 ATM', N'Sapphire', N'11mm', N'38mm', N'Quartz', N'cả Nam và Nữ', N'Dây Kim Loại', N'Ba Lan');
-- 7 tissot
INSERT INTO Detail (ProductID, Waterproof, GlassMaterial, Thickness, FaceSize, Typeof, GenderObject, Material, Origin)
VALUES
(67, N'10 ATM', N'Sapphire', N'11mm', N'40mm', N'Quartz', N'cả Nam và Nữ', N'Dây Da', N'Thụy Sỹ'),
(68, N'5 ATM', N'Kính Mineral', N'8mm', N'38mm', N'Quartz', N'Nữ', N'Dây Kim Loại', N'Thụy Sỹ'),
(69, N'30 ATM', N'Sapphire', N'12mm', N'40mm', N'Mechanical', N'Nữ', N'Thép', N'Thụy Sỹ'),
(70, N'10 ATM', N'Sapphire', N'9mm', N'41mm', N'Quartz', N'Nữ', N'Dây Kim Loại', N'Thụy Sỹ'),
(71, N'10 ATM', N'Sapphire', N'10mm', N'43mm', N'Quartz', N'Nữ', N'Dây Bạc', N'Thụy Sỹ'),
(72, N'5 ATM', N'Kính Mineral', N'8mm', N'39mm', N'Mechanical', N'Nữ', N'Dây Kim Loại', N'Thụy Sỹ'),
(73, N'30 ATM', N'Sapphire', N'10mm', N'42mm', N'Quartz', N'Nữ', N'Dây Da', N'Thụy Sỹ');
-- 7 G-Shock
INSERT INTO Detail (ProductID, Waterproof, GlassMaterial, Thickness, FaceSize, Typeof, GenderObject, Material, Origin) 
VALUES
(74, N'20 ATM', N'Sapphire', N'12mm', N'45mm', N'Quartz', N'Nam', N'Dây Nhựa', N'Nhật Bản'),
(75, N'20 ATM', N'Sapphire', N'12mm', N'50mm', N'Quartz', N'Nam', N'Dây Nhựa', N'Nhật Bản'),
(76, N'20 ATM', N'Sapphire', N'12mm', N'55mm', N'Quartz', N'Nam', N'Dây Nhựa', N'Nhật Bản'),
(77, N'20 ATM', N'Sapphire', N'12mm', N'50mm', N'Quartz', N'Nữ', N'Dây Thép', N'Nhật Bản'),
(78, N'20 ATM', N'Sapphire', N'11mm', N'44mm', N'Quartz', N'Nam', N'Dây Kim Loại', N'Nhật Bản'),
(79, N'20 ATM', N'Sapphire', N'12mm', N'50mm', N'Quartz', N'Nam', N'Dây Kim Loại', N'Nhật Bản'),
(80, N'20 ATM', N'Sapphire', N'12mm', N'43mm', N'Quartz', N'cả Nam và Nữ', N'Dây Bạc', N'Nhật Bản');


--9 Bảng Feedback (Phản hồi sản phẩm)
CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY IDENTITY(1,1),    -- Mã phản hồi (tự động tăng)
	ProductID INT,  
    CustomerID INT,                              -- Mã khách hàng (liên kết với bảng Customer)
    FeedbackText NVARCHAR(MAX),                  -- Nội dung phản hồi
    Rating INT , -- Đánh giá từ 1 đến 5 sao
    CreatedAt DATETIME DEFAULT GETDATE(),      -- Ngày tạo phản hồi
	ImageFeedBack nvarchar(50), 
	NameFeedback nvarchar(100),
    -- Ràng buộc khóa ngoại
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);



INSERT INTO Feedback (ProductID, CustomerID, FeedbackText, Rating, ImageFeedBack, NameFeedback) 
VALUES 
(1, 2, N'Đồng hồ rất đẹp, đúng với mong đợi của tôi!', 5, '1.jpg', N'Nguyễn Hoàng'),
(1, 3, N'Thiết kế tinh tế và chất lượng tốt, rất hài lòng.', 4, '2.jpg', N'Văn Thanh'),
(80, 4, N'Sản phẩm giao đúng thời gian, tôi sẽ giới thiệu cho bạn bè.', 5, '3.jpg', N'Trần Hà'),
(5, 6, N'Giá cả hợp lý, chất lượng ổn định.', 4, '4.jpg', N'Thị Thúy'),
(3, 7, N'Chất lượng sản phẩm rất tuyệt, phù hợp với giá tiền.', 5, '5.jpg', N'Hồng Lan'),
(70, 8, N'Giao hàng nhanh, sản phẩm giống như hình.', 5, '6.jpg', N'Vũ Hải'),
(60, 9, N'Sản phẩm ổn, nhưng thời gian giao hàng hơi chậm.', 3, '7.jpg', N'Trọng Nghĩa'),
(50, 10, N'Màu sắc đẹp, chất liệu thoải mái khi đeo.', 4, '8.jpg', N'Thiên Vũ'),
(35, 11, N'Đồng hồ rất bền, không bị xước sau thời gian sử dụng.', 5, '9.jpg', N'Long'),
(15, 12, N'Dịch vụ chăm sóc khách hàng chu đáo.', 4, '10.jpg', N'Tài Trần'),
(20, 13, N'Tôi rất thích kiểu dáng của sản phẩm này.', 5, '11.jpg', N'Ý Nhi'),
(30, 14, N'Thiết kế hiện đại, phù hợp với phong cách của tôi.', 5, '12.jpg', N'Lưu Vũ'),
(8, 15, N'Giá cả tốt, chất lượng ổn.', 4, '13.jpg', N'Trần Ngọc Anh'),
(11, 16, N'Đồng hồ nhìn đẹp hơn cả trong hình.', 5, '14.jpg', N'Văn Quý'),
(45, 17, N'Chất lượng dây đeo hơi kém, nhưng mặt đồng hồ rất ổn.', 3, '15.jpg', N'Hoàng Hải'),
(18, 18, N'Sản phẩm tuyệt vời, tôi sẽ mua thêm.', 5, '16.jpg', N'Lý Văn Hậu'),
(14, 19, N'Tôi thích màu sắc của đồng hồ này.', 4, '17.jpg', N'Ngô Danh'),
(7, 20, N'Nhận hàng đúng như quảng cáo, cảm ơn.', 5, '18.jpg', N'Nguyên Thanh'),
(9, 21, N'Tôi đã dùng được 1 tháng, sản phẩm vẫn hoạt động tốt.', 5, '19.jpg', N'Thùy Chi'),
(6, 22, N'Mặt kính không bị trầy xước, chất lượng đảm bảo.', 4, '20.jpg', N'Thái Huỳnh'),
(50, 23, N'Dịch vụ giao hàng nhanh, đóng gói cẩn thận.', 5, '21.jpg', N'Trần Não'),
(40, 24, N'Tôi hài lòng với sản phẩm, đáng đồng tiền.', 5, '22.jpg', N'Vũ Quý'),
(13, 25, N'Đồng hồ đẹp, nhưng dây đeo chưa thật sự chắc chắn.', 3, '23.jpg', N'Văn Huynh'),
(25, 26, N'Sản phẩm đúng mô tả, chất lượng tốt.', 4, '24.jpg', N'Nam Dương'),
(33, 27, N'Giao hàng nhanh chóng, chất lượng sản phẩm ổn định.', 5, '25.jpg', N'Tuấn Vũ'),
(29, 28, N'Chất liệu cao cấp, không gây kích ứng da.', 5, '26.jpg', N'Ý Như'),
(16, 29, N'Tôi sẽ mua thêm sản phẩm từ cửa hàng này.', 5, '27.jpg', N'Bảo Bảo'),
(21, 30, N'Chất lượng sản phẩm rất tốt, đóng gói cẩn thận.', 4, '28.jpg', N'Ngọc Lan'),
(70, 9, N'Sản phẩm ổn, nhưng thời gian giao hàng hơi chậm.', 3, '29.jpg', N'Vũ Thịnh'),

(2, 5, N'Chất lượng sản phẩm tốt, giao hàng đúng hẹn.', 5, '30.jpg', N' Hoàng Thái'),
(2, 8, N'Mẫu mã đẹp, rất vừa vặn khi đeo, tôi rất hài lòng.', 4, '31.jpg', N' Văn Long'),
(2, 12, N'Sản phẩm đẹp, nhưng có chút trầy xước ở phần mặt kính.', 3, '32.jpg', N'Hoàng Thái Kiệt'),
(17, 6, N'Chất liệu sản phẩm rất tốt, tôi sẽ giới thiệu cho bạn bè.', 5, '33.jpg', N'Vũ Quý'),
(17, 9, N'Giá cả hợp lý, nhưng sản phẩm bị trầy xước nhẹ ở phần mặt đồng hồ.', 4, '34.jpg', N'Lan Anh'),
(17, 14, N'Thiết kế đẹp, tuy nhiên dây đeo không quá chắc chắn.', 3, '35.jpg', N'Vũ Danh'),
(27, 5, N'Sản phẩm rất tuyệt vời, thiết kế đẹp, sử dụng thoải mái.', 5, '36.jpg', N'Thúy Trần'),
(27, 12, N'Chất liệu cao cấp, rất ưng ý với sản phẩm này.', 4, '37.jpg', N'Như Tiên'),
(27, 18, N'Mặt đồng hồ đẹp, tuy nhiên dây đeo có phần hơi rộng cho tay tôi.', 3, '38.jpg', N'Cúc Trần'),
(32, 4, N'Sản phẩm chất lượng tốt, nhưng thiết kế có thể cải thiện thêm.', 4, '39.jpg', N'Nữ Nguyễn'),
(32, 9, N'Mẫu mã đẹp, rất vừa vặn và dễ sử dụng.', 5, '40.jpg', N'Thúy Trần'),
(32, 14, N'Mặt kính của đồng hồ dễ bị trầy xước, nhưng nhìn chung là ổn.', 3, '41.jpg', N'Bảo Ngọc'),

(33, 2, N'Giá cả hợp lý, chất lượng tốt, tôi rất hài lòng.', 5, '42.jpg', N'Trần Tuấn'),
(33, 8, N'Sản phẩm rất đẹp, rất ưng ý, tôi sẽ giới thiệu cho bạn bè.', 5, '43.jpg', N'Văn Toàn'),
(33, 15, N'Chất liệu tốt, nhưng cần cải thiện dịch vụ giao hàng.', 4, '44.jpg', N'Văn Ngọc'),
(34, 3, N'Đồng hồ rất đẹp và bền, tôi đã dùng lâu mà không gặp vấn đề gì.', 5, '45.jpg', N'Hoàng Hải'),
(34, 7, N'Sản phẩm đúng như mô tả, nhưng giá hơi cao một chút.', 4, '46.jpg', N'Thanh Tuyền'),
(34, 10, N'Chất liệu rất tốt, đeo thoải mái, nhưng giao hàng hơi chậm.', 3, '47.jpg', N'Ngọc Nguyễn'),
(35, 5, N'Chất lượng sản phẩm rất tốt, giao hàng nhanh chóng.', 5, '48.jpg', N'Văn Vũ'),
(35, 11, N'Mẫu mã đẹp, nhưng giá có phần cao hơn so với thị trường.', 4, '49.jpg', N'Thắm Trần'),
(35, 18, N'Sản phẩm không giống hình lắm, nhưng vẫn sử dụng ổn.', 3, '50.jpg', N'Văn Toàn'),
(19, 4, N'Sản phẩm rất đẹp, nhưng tôi mong muốn có thêm lựa chọn màu sắc khác.', 4, '51.jpg', N'Thái Tú'),
(19, 7, N'Chất lượng sản phẩm tuyệt vời, rất hài lòng với sự lựa chọn của mình.', 5, '52.jpg', N'Văn Long'),
(19, 12, N'Giá hơi cao, nhưng bù lại chất lượng rất ổn.', 4, '53.jpg', N'Vũ Trần'),
(31, 5, N'Chất liệu sản phẩm rất tốt, nhưng kích thước không phù hợp với tôi.', 3, '54.jpg', N'Nguyên Ngọc'),
(31, 8, N'Sản phẩm tuyệt vời, đúng với mô tả, tôi rất hài lòng.', 5, '55.jpg', N'Danh Lê'),
(31, 11, N'Giá cả hơi cao nhưng chất lượng xứng đáng, tôi sẽ tiếp tục mua.', 4, '56.jpg', N'Hạnh Nguyễn');
  -- update số sao cho bảng product
UPDATE Product
SET AverageRating = (
    SELECT AVG(CAST(Rating AS FLOAT))  -- Tính trung bình điểm đánh giá (Rating)
    FROM Feedback
    WHERE Feedback.ProductID = Product.ProductID  -- Liên kết với sản phẩm cụ thể
)
WHERE ProductID IN (
    SELECT DISTINCT ProductID
    FROM Feedback  -- Chỉ cập nhật sản phẩm có phản hồi
);



--2 Bảng Order (Đơn hàng)
CREATE TABLE [Order] (
    OrderID INT PRIMARY KEY IDENTITY(1,1),    -- Mã đơn hàng (tự động tăng)
    OrderDate DATETIME DEFAULT GETDATE(),   -- Ngày đặt hàng
    CustomerID INT not null, 
	OrderStatus int , -- 0 là trong gio
					--	1 là đã tính tiền
	Discount_Code INT,
	Status NVARCHAR(50) DEFAULT 'Pending',
	-- Pending: chờ 
	-- Approved:xong
	-- Rejected : bỏ qua
    -- Ràng buộc khóa ngoại
	TotalPrice DECIMAL(18, 0),
	-- thong tin người nhận hàng
	ReceiverName NVARCHAR(100)  CHECK (ReceiverName NOT LIKE '%[0-9]%'),  -- Tên người nhận hàng
	--ReceiverEmail NVARCHAR(100),      -- email người nhận
	ReceiverGender NVARCHAR(10),-- Giới tính của người nhận
    ReceiverPhone NVARCHAR(20)  CHECK (LEN(ReceiverPhone) IN (10, 11) AND ReceiverPhone NOT LIKE '%[^0-9]%'),  -- Số điện thoại của người nhận
    ReceiverAddress NVARCHAR(255) ,  -- Địa chỉ của người nhận
    HouseNumber NVARCHAR(50),  -- Số nhà của người nhận
    Note NVARCHAR(255)  -- Chú thích cho người nhận
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
); 
-- tổng 171 đơn, 156 đơn mua, 15 đơn trong giỏ
-- năm 2023 91 đơn
INSERT INTO [Order] (OrderDate, CustomerID, OrderStatus, Status, TotalPrice, ReceiverName, ReceiverGender, ReceiverPhone, ReceiverAddress, HouseNumber, Note)
VALUES
('2023-01-05', 15, 1, 'Approved', 360000, N'Nguyễn Văn An', N'Nam', '0911223344', N'Hồ Chí Minh - Quận 1 - Phường Bến Thành', N'88 Lê Lợi', N'Ghi chú 67'),
('2023-01-20', 43, 1, 'Approved', 450000, N'Trần Thị Hồng', N'Nữ', '0933445566', N'Hồ Chí Minh - Quận 2 - Phường Thảo Điền', N'22 Nguyễn Cơ Thạch', N'Ghi chú 68'),
('2023-02-10', 18, 1, 'Approved', 520000, N'Lê Minh Quân', N'Nam', '0922883344', N'Hồ Chí Minh - Quận 3 - Phường 7', N'77 Điện Biên Phủ', N'Ghi chú 69'),
('2023-02-25', 28, 1, 'Approved', 370000, N'Nguyễn Thị Thanh Hằng', N'Nữ', '0912773344', N'Hồ Chí Minh - Quận 4 - Phường 13', N'98 Khánh Hội', N'Ghi chú 70'),
('2023-03-12', 33, 1, 'Approved', 660000, N'Phạm Văn Tuấn', N'Nam', '0932996655', N'Hồ Chí Minh - Quận 5 - Phường 1', N'54 Nguyễn Trãi', N'Ghi chú 71'),
('2023-03-28', 12, 1, 'Approved', 410000, N'Trương Thị Lan', N'Nữ', '0978225566', N'Hồ Chí Minh - Quận 6 - Phường 5', N'18 Bình Phú', N'Ghi chú 72'),
('2023-04-07', 60, 1, 'Approved', 550000, N'Lê Ngọc Sơn', N'Nam', '0944882233', N'Hồ Chí Minh - Quận 7 - Phường Tân Phong', N'45 Nguyễn Hữu Thọ', N'Ghi chú 73'),
('2023-04-20', 24, 1, 'Approved', 380000, N'Tran Thị Bích Ngọc', N'Nữ', '0987551122', N'Hồ Chí Minh - Quận 8 - Phường 6', N'29 Tạ Quang Bửu', N'Ghi chú 74'),
('2023-05-03', 45, 1, 'Approved', 470000, N'Bùi Văn Khánh', N'Nam', '0932113344', N'Hồ Chí Minh - Quận 9 - Phường Tăng Nhơn Phú B', N'66 Đỗ Xuân Hợp', N'Ghi chú 75'),
('2023-05-17', 17, 1, 'Approved', 520000, N'Phạm Thị Thuỷ', N'Nữ', '0912788899', N'Hồ Chí Minh - Quận 10 - Phường 15', N'24 Nguyễn Tri Phương', N'Ghi chú 76'),
('2023-06-02', 5, 1, 'Approved', 440000, N'Tô Văn Thanh', N'Nam', '0978221133', N'Hồ Chí Minh - Quận 11 - Phường 1', N'47 Lạc Long Quân', N'Ghi chú 77'),
('2023-06-18', 72, 1, 'Approved', 680000, N'Nguyễn Thị Tâm', N'Nữ', '0922997733', N'Hồ Chí Minh - Quận 12 - Phường Hiệp Thành', N'39 Nguyễn Ảnh Thủ', N'Ghi chú 78'),
('2023-07-01', 36, 1, 'Approved', 590000, N'Lê Minh Hoàng', N'Nam', '0912998877', N'Hồ Chí Minh - Quận Bình Thạnh - Phường 13', N'65 Phan Đăng Lưu', N'Ghi chú 79'),
('2023-07-22', 8, 1, 'Approved', 490000, N'Trần Thị Tuyết', N'Nữ', '0938442233', N'Hồ Chí Minh - Quận Tân Bình - Phường 10', N'19 Cộng Hoà', N'Ghi chú 80'),
('2023-08-05', 29, 1, 'Approved', 340000, N'Phan Văn Thành', N'Nam', '0912346677', N'Hồ Chí Minh - Quận Gò Vấp - Phường 17', N'102 Nguyễn Văn Lượng', N'Ghi chú 81'),
('2023-08-17', 51, 1, 'Approved', 710000, N'Tôn Thị Kim Hạnh', N'Nữ', '0978338844', N'Hồ Chí Minh - Quận Phú Nhuận - Phường 5', N'72 Đặng Văn Ngữ', N'Ghi chú 82'),
('2023-09-10', 40, 1, 'Approved', 570000, N'Nguyễn Văn Đức', N'Nam', '0922445566', N'Hồ Chí Minh - Quận Tân Phú - Phường Hiệp Tân', N'47 Hòa Bình', N'Ghi chú 83'),
('2023-09-23', 63, 1, 'Approved', 450000, N'Trương Thị Mai', N'Nữ', '0912556677', N'Hồ Chí Minh - Quận Bình Tân - Phường Bình Trị Đông B', N'15 Mã Lò', N'Ghi chú 84'),
('2023-10-06', 78, 1, 'Approved', 530000, N'Lê Minh Phúc', N'Nam', '0944556677', N'Hồ Chí Minh - Huyện Hóc Môn - Xã Đông Thạnh', N'90 Nguyễn Thị Sóc', N'Ghi chú 85'),
('2023-10-28', 11, 1, 'Approved', 390000, N'Nguyễn Thị Thu Hà', N'Nữ', '0932335566', N'Hồ Chí Minh - Huyện Củ Chi - Xã Tân Phú Trung', N'99 Quốc lộ 22', N'Ghi chú 86'),
('2023-01-15', 1, 1, 'Approved', 500000 , N'Nguyễn Thị Hoa', N'Nữ', '0987654321', N'Hồ Chí Minh - Thành phố Thủ Đức - Phường Tăng Nhơn Phú A', N'156 Nguyễn Văn Chí', N'Ghi chú 1'),
('2023-02-10', 2, 1, 'Approved', 250000 , N'Trần Thị Kim Thoa', N'Nữ', '0987654322', N'Khánh Hoà - Thành phố Cam Ranh - Phường Cam Phú ', N'18 Nguyễn Hữu Thọ', N'Ghi chú 2'),
('2023-03-05', 3, 1, 'Approved', 130000, N'Nguyễn Thị Duyên', N'Nữ', '0987654323', N'Bình Định - Thị xã An Nhơn - Xã Nhơn Mỹ', N'Thôn Thiết Tràng', N'Ghi chú 3'),
('2023-04-20', 4, 1, 'Approved', 340000 ,N'Phạm Văn Huynh', N'Nam', '0987654325', N'Hồ Chí Minh - Thành phố Thủ Đức - Phường An Phú', N'65 Lý Chính Thắng ', N'Ghi chú 5'),
('2023-05-13', 5, 1, 'Approved', 120000,  N'Lê Thị Hồng Ánh', N'Nữ', '0987654324', N'Hồ Chí Minh - Thành phố Thủ Đức - Phường Tăng Nhơn Phú A', N'06 Hoàng Diệu 2', N'Ghi chú 4'),
('2023-06-18', 6, 1, 'Approved', 230000,  N'Lê Văn Giang', N'Nam', '0987654326', N'Hà Nội - Quận Ba Đình - Phường Kim Mã', N'234 Đường 18', N'Ghi chú 6'),
('2023-07-25', 7, 1, 'Approved', 780000 ,  N'Nguyễn Thị Loan', N'Nữ', '0987654327',N'Hà Nội - Quận Hoàng Kiếm - Phường Hàng Mã', N'456 Đường 21',  N'Ghi chú 7'),
('2023-08-03', 8, 1, 'Approved', 560000 ,  N'Phạm Văn Nam', N'Nam', '0987654328', N'Quảng Ninh - Thành phố Hạ Long - Phường hà Khẩu', N'678 Đường 24', N'Ghi chú 8'),
('2023-09-12', 9, 1, 'Approved', 450000 ,  N'Lê Thị Phúc', N'Nữ', '0987654329',N'Hà Nội - Quận Ba Đình - Phường Kim Mã', N'789 Đường Nguyễn Hải',  N'Ghi chú 9'),
('2023-10-05', 10, 1, 'Approved', 670000,  N'Nguyễn Văn Hoàng', N'Nam', '0987654330', N'Hồ Chí Minh - Thành phố Thủ Đức - Phường Tăng Nhơn Phú B', N'890 Đường 385', N'Ghi chú 10'),
('2023-10-25', 11, 1, 'Approved', 720000 ,  N'Nguyễn Thị Thuý', N'Nữ', '0987654331',N'Quảng Nam - Thành phố Quảng Nam - Phường Tân Thạnh', N'321 Đường 33',  N'Ghi chú 11'),
('2023-11-15', 12, 1, 'Approved', 550000,   N'Phạm Văn ', N'Nam', '0987654332',N'Hà Nội - Quận Ba Đình - Phường Kim Mã', N'654 Đường 36', N'Ghi chú 12'),
('2023-12-02', 13, 1, 'Approved', 660000 , N'Phạm Thị Hồng', N'Nữ', '0987654340',N'Hồ Chí Minh - Quận 2 - Phường An Phú', N'02 Đường Nguyễn Hữu Cảnh' ,  N'Ghi chú 20'),
('2023-12-10', 14, 1, 'Approved', 490000 ,  N'Nguyễn Văn Báu', N'Nam', '0987654339',N'Hà Nội - Quận Ba Đình - Phường Hàng Hoa', N'654 Đường Hoàng Hoa Thám',  N'Ghi chú 19'),
('2023-12-15', 15, 1, 'Approved', 230000 ,  N'Phạm Thị Anh', N'Nữ', '0987654338',N'Hồ Chí Minh - Quận 1 - Phường Đa Kao', N'02 Đường Trần Quang Diệu' ,  N'Ghi chú 18'),
('2023-12-20', 16, 1, 'Approved', 800000,  N'Nguyễn Văn Hạnh', N'Nam', '0987654337',N'Bình Dương - Thành phố Dĩ An - Phường Đông Hoà', N'987 Đường Trần Hưng Đạo',  N'Ghi chú 17'),
('2023-12-22', 17, 1, 'Approved', 600000 ,  N'Phạm Thị Như Ý', N'Nữ', '0987654336',N'Bình Dương - Thành phố Dĩ An - Phường Đông Hoà', N'654 Đường Phạm Văn Chiêu',  N'Ghi chú 16'),
('2023-12-25', 18, 1, 'Approved', 250000 ,  N'Trần Thị Lan', N'Nam', '0987654335',N'Hà Nội - Quận Đống Đa - Phường Văn Miếu', N'21 Đường Võ Thái Học',  N'Ghi chú 15'),
('2023-12-28', 19, 1, 'Approved', 370000,  N'Nguyễn Văn Vũ', N'Nam', '0987654333', N'Hồ Chí Minh - Quận 1 - Phường Bến Nghé', N'29 Đường Nguyễn Huệ',  N'Ghi chú 13'),
('2023-12-30', 20, 1, 'Approved', 540000, N'Nguyễn Thị Hoa', N'Nữ', '0987654321', N'Hồ Chí Minh - Thành phố Thủ Đức - Phường Tăng Nhơn Phú A', N'156 Nguyễn Văn Chí', N'Ghi chú 1'),
('2023-02-01', 2, 1, 'Approved', 300000, N'Trần Văn Hùng', N'Nam', '0912345678', N'Hồ Chí Minh - Quận 1 - Phường Bến Nghé', N'123 Lê Lợi', N'Ghi chú 2'),
('2023-02-15', 3, 1, 'Approved', 450000, N'Lê Thị Hương', N'Nữ', '0978112233', N'Hồ Chí Minh - Quận 3 - Phường Võ Thị Sáu', N'45 Nguyễn Đình Chiểu', N'Ghi chú 3'),
('2023-03-05', 4, 1, 'Approved', 200000, N'Nguyễn Văn An', N'Nam', '0933445566', N'Hồ Chí Minh - Quận 5 - Phường 9', N'88 Trần Hưng Đạo', N'Ghi chú 4'),
('2023-03-20', 5, 1, 'Approved', 650000, N'Phạm Thị Mai', N'Nữ', '0922334455', N'Hồ Chí Minh - Thành phố Thủ Đức - Phường Linh Tây', N'20 Tô Ngọc Vân', N'Ghi chú 5'),
('2023-04-10', 6, 1, 'Approved', 700000, N'Bùi Minh Quang', N'Nam', '0944556677', N'Hồ Chí Minh - Quận 7 - Phường Tân Phong', N'56 Nguyễn Hữu Thọ', N'Ghi chú 6'),
('2023-04-15', 7, 1, 'Approved', 300000, N'Nguyễn Thị Lan', N'Nữ', '0911333444', N'Hồ Chí Minh - Quận 1 - Phường Đa Kao', N'15 Phạm Ngọc Thạch', N'Ghi chú 7'),
('2023-04-20', 8, 1, 'Approved', 250000, N'Lê Quang Long', N'Nam', '0933221100', N'Hồ Chí Minh - Quận 2 - Phường Thảo Điền', N'25 Nguyễn Văn Hưởng', N'Ghi chú 8'),
('2023-04-25', 9, 1, 'Approved', 600000, N'Trần Thị Thu', N'Nữ', '0978776655', N'Hồ Chí Minh - Quận 3 - Phường 7', N'78 Nam Kỳ Khởi Nghĩa', N'Ghi chú 9'),
('2023-05-01', 10, 1, 'Approved', 500000, N'Phạm Minh Hoàng', N'Nam', '0912778833', N'Hồ Chí Minh - Quận 4 - Phường 12', N'35 Nguyễn Tất Thành', N'Ghi chú 10'),
('2023-05-05', 11, 1, 'Approved', 550000, N'Ngô Thanh Hương', N'Nữ', '0988332211', N'Hồ Chí Minh - Quận 5 - Phường 4', N'55 An Dương Vương', N'Ghi chú 11'),
('2023-05-10', 12, 1, 'Approved', 720000, N'Bùi Văn Lộc', N'Nam', '0922445566', N'Hồ Chí Minh - Quận 6 - Phường 9', N'120 Hậu Giang', N'Ghi chú 12'),
('2023-05-15', 13, 1, 'Approved', 450000, N'Tạ Thị Lan', N'Nữ', '0932556677', N'Hồ Chí Minh - Quận 7 - Phường Tân Thuận', N'67 Huỳnh Tấn Phát', N'Ghi chú 13'),
('2023-05-20', 14, 1, 'Approved', 650000, N'Phan Minh Tuấn', N'Nam', '0978994433', N'Hồ Chí Minh - Quận 8 - Phường 16', N'101 Phạm Hùng', N'Ghi chú 14'),
('2023-05-25', 15, 1, 'Rejected', 800000, N'Trịnh Thị Dung', N'Nữ', '0911992277', N'Hồ Chí Minh - Quận 9 - Phường Tăng Nhơn Phú B', N'215 Man Thiện', N'Ghi chú 15'),
('2023-06-01', 16, 1, 'Approved', 550000, N'Huỳnh Minh Đức', N'Nam', '0944882233', N'Hồ Chí Minh - Quận 10 - Phường 2', N'150 Sư Vạn Hạnh', N'Ghi chú 16'),
('2023-06-05', 17, 1, 'Approved', 670000, N'Đặng Thị Phương', N'Nữ', '0933445522', N'Hồ Chí Minh - Quận 11 - Phường 5', N'66 3 Tháng 2', N'Ghi chú 17'),
('2023-06-10', 18, 1, 'Approved', 730000, N'Lý Thanh Tùng', N'Nam', '0912765489', N'Hồ Chí Minh - Quận 12 - Phường Tân Chánh Hiệp', N'77 Tân Chánh Hiệp', N'Ghi chú 18'),
('2023-06-15', 19, 1, 'Approved', 480000, N'Thái Ngọc Hoa', N'Nữ', '0988764532', N'Hồ Chí Minh - Quận Gò Vấp - Phường 10', N'90 Quang Trung', N'Ghi chú 19'),
('2023-06-20', 20, 1, 'Approved', 590000, N'Võ Minh Tâm', N'Nam', '0922345544', N'Hồ Chí Minh - Quận Bình Thạnh - Phường 17', N'130 Điện Biên Phủ', N'Ghi chú 20'),
('2023-06-25', 21, 1, 'Approved', 420000, N'Tô Thị Mai', N'Nữ', '0978675423', N'Hồ Chí Minh - Quận Phú Nhuận - Phường 13', N'88 Trường Sa', N'Ghi chú 21'),
('2023-07-01', 22, 1, 'Rejected', 380000, N'Trương Văn Cường', N'Nam', '0932765441', N'Hồ Chí Minh - Quận Tân Bình - Phường 15', N'100 Hoàng Hoa Thám', N'Ghi chú 22'),
('2023-07-05', 23, 1, 'Approved', 640000, N'Phan Thị Bích', N'Nữ', '0912554433', N'Hồ Chí Minh - Quận Tân Phú - Phường Phú Thọ Hòa', N'134 Lũy Bán Bích', N'Ghi chú 23'),
('2023-07-10', 24, 1, 'Approved', 500000, N'Lâm Thanh Phong', N'Nam', '0921997766', N'Hồ Chí Minh - Huyện Bình Chánh - Xã Bình Hưng', N'78 Nguyễn Văn Linh', N'Ghi chú 24'),
('2023-07-15', 25, 1, 'Approved', 550000, N'Nguyễn Văn Hào', N'Nam', '0912884499', N'Hồ Chí Minh - Huyện Hóc Môn - Xã Tân Xuân', N'230 Nguyễn Ảnh Thủ', N'Ghi chú 25'),
('2023-07-20', 26, 1, 'Approved', 610000, N'Tran Thị Hạnh', N'Nữ', '0988112200', N'Hồ Chí Minh - Huyện Củ Chi - Xã Tân Thông Hội', N'99 Quốc lộ 22', N'Ghi chú 26'),
('2023-01-12', 33, 1, 'Approved', 420000, N'Trần Thị Mai', N'Nữ', '0912778899', N'Hồ Chí Minh - Quận 1 - Phường Đa Kao', N'11 Trần Cao Vân', N'Ghi chú 87'),
('2023-01-25', 47, 1, 'Approved', 350000, N'Phạm Văn Hòa', N'Nam', '0933447788', N'Hồ Chí Minh - Quận 2 - Phường An Phú', N'55 Song Hành', N'Ghi chú 88'),
('2023-02-07', 65, 1, 'Approved', 600000, N'Nguyễn Thị Hiền', N'Nữ', '0978223344', N'Hồ Chí Minh - Quận 3 - Phường 6', N'29 Pasteur', N'Ghi chú 89'),
('2023-02-19', 39, 1, 'Approved', 480000, N'Lê Minh Tùng', N'Nam', '0922778899', N'Hồ Chí Minh - Quận 4 - Phường 8', N'102 Nguyễn Tất Thành', N'Ghi chú 90'),
('2023-03-05', 55, 1, 'Approved', 530000, N'Trương Thị Hà', N'Nữ', '0944889977', N'Hồ Chí Minh - Quận 5 - Phường 4', N'70 Lý Thường Kiệt', N'Ghi chú 91'),
('2023-03-28', 72, 1, 'Approved', 620000, N'Phạm Văn Sơn', N'Nam', '0932998877', N'Hồ Chí Minh - Quận 6 - Phường 9', N'34 Bình Phú', N'Ghi chú 92'),
('2023-04-15', 36, 1, 'Approved', 570000, N'Tôn Nữ Bích Ngọc', N'Nữ', '0922885566', N'Hồ Chí Minh - Quận 7 - Phường Tân Thuận Đông', N'78 Nguyễn Văn Linh', N'Ghi chú 93'),
('2023-04-22', 31, 1, 'Approved', 430000, N'Bùi Văn Đức', N'Nam', '0912345566', N'Hồ Chí Minh - Quận 8 - Phường 10', N'66 Tạ Quang Bửu', N'Ghi chú 94'),
('2023-05-10', 45, 1, 'Approved', 490000, N'Nguyễn Thị Thanh', N'Nữ', '0988337744', N'Hồ Chí Minh - Quận 9 - Phường Phước Long A', N'88 Đỗ Xuân Hợp', N'Ghi chú 95'),
('2023-05-25', 59, 1, 'Approved', 350000, N'Lê Văn Lâm', N'Nam', '0932994433', N'Hồ Chí Minh - Quận 10 - Phường 9', N'52 Ba Tháng Hai', N'Ghi chú 96'),
('2023-06-08', 40, 1, 'Approved', 470000, N'Nguyễn Thị Thanh Hà', N'Nữ', '0912778877', N'Hồ Chí Minh - Quận 11 - Phường 15', N'12 Minh Phụng', N'Ghi chú 97'),
('2023-06-20', 67, 1, 'Approved', 580000, N'Trần Văn Hải', N'Nam', '0922883322', N'Hồ Chí Minh - Quận 12 - Phường Thạnh Lộc', N'19 Quốc lộ 1A', N'Ghi chú 98'),
('2023-07-03', 34, 1, 'Approved', 620000, N'Nguyễn Thị Phượng', N'Nữ', '0978332211', N'Hồ Chí Minh - Quận Bình Thạnh - Phường 21', N'33 Xô Viết Nghệ Tĩnh', N'Ghi chú 99'),
('2023-07-17', 80, 1, 'Approved', 470000, N'Phạm Minh Khoa', N'Nam', '0932113322', N'Hồ Chí Minh - Quận Tân Bình - Phường 4', N'17 Cộng Hòa', N'Ghi chú 100'),
('2023-08-01', 53, 1, 'Approved', 590000, N'Tran Văn Vinh', N'Nam', '0912335567', N'Hồ Chí Minh - Quận Gò Vấp - Phường 12', N'77 Nguyễn Oanh', N'Ghi chú 101'),
('2023-08-23', 44, 1, 'Approved', 320000, N'Trần Thị Yến', N'Nữ', '0912998844', N'Hồ Chí Minh - Quận Phú Nhuận - Phường 2', N'22 Hoàng Văn Thụ', N'Ghi chú 102'),
('2023-09-12', 71, 1, 'Approved', 480000, N'Lê Văn Huy', N'Nam', '0944996677', N'Hồ Chí Minh - Quận Tân Phú - Phường Hòa Thạnh', N'30 Lũy Bán Bích', N'Ghi chú 103'),
('2023-09-25', 46, 1, 'Approved', 630000, N'Nguyễn Thị Hường', N'Nữ', '0932441122', N'Hồ Chí Minh - Quận Bình Tân - Phường Bình Hưng Hoà A', N'14 Tỉnh lộ 10', N'Ghi chú 104'),
('2023-10-04', 57, 1, 'Approved', 410000, N'Trương Minh Hoà', N'Nam', '0978771122', N'Hồ Chí Minh - Huyện Hóc Môn - Xã Trung Chánh', N'95 Phan Văn Hớn', N'Ghi chú 105'),
('2023-10-15', 38, 1, 'Approved', 540000, N'Lâm Thị Mỹ Hạnh', N'Nữ', '0912883344', N'Hồ Chí Minh - Huyện Củ Chi - Xã Phú Hoà Đông', N'41 Võ Văn Bích', N'Ghi chú 106'),
('2023-10-29', 69, 1, 'Rejected', 450000, N'Tô Văn Phát', N'Nam', '0912997766', N'Hồ Chí Minh - Huyện Bình Chánh - Xã Bình Hưng', N'59 Nguyễn Văn Linh', N'Ghi chú 107'),
('2023-11-05', 61, 1, 'Approved', 530000, N'Trần Thị Bảo', N'Nữ', '0932993322', N'Hồ Chí Minh - Quận 1 - Phường Bến Nghé', N'24 Lê Duẩn', N'Ghi chú 108'),
('2023-11-18', 79, 1, 'Approved', 490000, N'Nguyễn Văn Kiên', N'Nam', '0944558899', N'Hồ Chí Minh - Quận 2 - Phường Bình An', N'88 Song Hành', N'Ghi chú 109'),
('2023-11-22', 41, 1, 'Approved', 650000, N'Phạm Thị Lý', N'Nữ', '0912773344', N'Hồ Chí Minh - Quận 3 - Phường 3', N'77 Nam Kỳ Khởi Nghĩa', N'Ghi chú 110'),
('2023-12-03', 37, 1, 'Approved', 360000, N'Bùi Văn Dũng', N'Nam', '0932447788', N'Hồ Chí Minh - Quận 4 - Phường 15', N'90 Vĩnh Khánh', N'Ghi chú 111'),
('2023-12-17', 62, 1, 'Approved', 430000, N'Tôn Nữ Minh Châu', N'Nữ', '0922771133', N'Hồ Chí Minh - Quận 5 - Phường 12', N'58 Nguyễn Trãi', N'Ghi chú 112');


-- năm 2024  65 đơn
INSERT INTO [Order] (OrderDate, CustomerID, OrderStatus, Status, TotalPrice, ReceiverName, ReceiverGender, ReceiverPhone, ReceiverAddress, HouseNumber, Note)
VALUES
('2024-11-10', 5, 1, 'Approved', 350000, N'Nguyễn Văn Bình', N'Nam', '0934556677', N'Hồ Chí Minh - Quận 1 - Phường Bến Nghé', N'77 Đồng Khởi', N'Ghi chú 27'),
('2024-01-20', 18, 1, 'Approved', 450000, N'Trần Thị Kim Oanh', N'Nữ', '0922334455', N'Hồ Chí Minh - Quận 2 - Phường An Phú', N'65 Song Hành', N'Ghi chú 28'),
('2024-02-05', 13, 1, 'Approved', 620000, N'Phạm Minh Quân', N'Nam', '0911553322', N'Hồ Chí Minh - Quận 3 - Phường Võ Thị Sáu', N'90 Lý Chính Thắng', N'Ghi chú 29'),
('2024-11-18', 22, 1, 'Approved', 280000, N'Lê Thị Mỹ Linh', N'Nữ', '0978225566', N'Hồ Chí Minh - Quận 4 - Phường 13', N'45 Tôn Thất Thuyết', N'Ghi chú 30'),
('2024-03-02', 11, 1, 'Rejected', 500000, N'Ngô Văn Thành', N'Nam', '0944882233', N'Hồ Chí Minh - Quận 5 - Phường 7', N'102 An Dương Vương', N'Ghi chú 31'),
('2024-03-15', 7, 1, 'Approved', 530000, N'Trần Thị Lan Anh', N'Nữ', '0988552233', N'Hồ Chí Minh - Quận 6 - Phường 5', N'22 Hậu Giang', N'Ghi chú 32'),
('2024-03-22', 26, 1, 'Approved', 670000, N'Bùi Minh Trí', N'Nam', '0912884422', N'Hồ Chí Minh - Quận 7 - Phường Tân Phong', N'12 Nguyễn Hữu Thọ', N'Ghi chú 33'),
('2024-04-01', 15, 1, 'Approved', 410000, N'Tô Thị Bích Ngọc', N'Nữ', '0933445566', N'Hồ Chí Minh - Quận 8 - Phường 6', N'76 Phạm Thế Hiển', N'Ghi chú 34'),
('2024-11-17', 19, 1, 'Approved', 550000, N'Tạ Văn Phúc', N'Nam', '0922997733', N'Hồ Chí Minh - Quận 9 - Phường Hiệp Phú', N'53 Man Thiện', N'Ghi chú 35'),
('2024-04-28', 29, 1, 'Approved', 470000, N'Phan Thị Thu', N'Nữ', '0978335544', N'Hồ Chí Minh - Quận 10 - Phường 15', N'88 Lê Hồng Phong', N'Ghi chú 36'),
('2024-05-05', 3, 1, 'Approved', 390000, N'Nguyễn Hoàng Sơn', N'Nam', '0911223344', N'Hồ Chí Minh - Quận 11 - Phường 1', N'72 3 Tháng 2', N'Ghi chú 37'),
('2024-11-16', 25, 1, 'Approved', 630000, N'Bùi Thị Tuyết Mai', N'Nữ', '0922345567', N'Hồ Chí Minh - Quận 12 - Phường Tân Chánh Hiệp', N'91 Tân Chánh Hiệp', N'Ghi chú 38'),
('2024-06-10', 14, 1, 'Approved', 680000, N'Lý Ngọc Trâm', N'Nữ', '0932887744', N'Hồ Chí Minh - Quận Bình Tân - Phường Bình Hưng Hòa', N'120 Võ Văn Kiệt', N'Ghi chú 39'),
('2024-06-22', 21, 1, 'Approved', 300000, N'Trương Thanh Hằng', N'Nữ', '0978112233', N'Hồ Chí Minh - Quận Tân Bình - Phường 6', N'47 Cách Mạng Tháng 8', N'Ghi chú 40'),
('2024-07-01', 2, 1, 'Approved', 450000, N'Phạm Văn Tú', N'Nam', '0922445566', N'Hồ Chí Minh - Quận Gò Vấp - Phường 10', N'10 Nguyễn Oanh', N'Ghi chú 41'),
('2024-07-15', 16, 1, 'Approved', 570000, N'Lê Thị Bảo Trân', N'Nữ', '0912763322', N'Hồ Chí Minh - Quận Bình Thạnh - Phường 19', N'75 Nơ Trang Long', N'Ghi chú 42'),
('2024-08-03', 6, 1, 'Approved', 420000, N'Nguyễn Văn Huy', N'Nam', '0944331122', N'Hồ Chí Minh - Quận Tân Phú - Phường Tân Sơn Nhì', N'134 Độc Lập', N'Ghi chú 43'),
('2024-08-22', 28, 1, 'Approved', 510000, N'Trần Thị Thu Hoài', N'Nữ', '0922998844', N'Hồ Chí Minh - Huyện Bình Chánh - Xã Bình Hưng', N'69 Nguyễn Văn Linh', N'Ghi chú 44'),
('2024-09-15', 9, 1, 'Approved', 490000, N'Trần Văn Hùng', N'Nam', '0978221133', N'Hồ Chí Minh - Huyện Hóc Môn - Xã Xuân Thới Thượng', N'108 Lê Văn Khương', N'Ghi chú 45'),
('2024-10-02', 30, 1, 'Approved', 610000, N'Nguyễn Thị Thanh', N'Nữ', '0932445566', N'Hồ Chí Minh - Huyện Củ Chi - Xã Tân An Hội', N'80 Quốc lộ 22', N'Ghi chú 46'),
('2024-01-18', 17, 1, 'Rejected', 470000, N'Vũ Thị Bích', N'Nữ', '0912987654', N'Hồ Chí Minh - Quận 1 - Phường Tân Định', N'12 Võ Thị Sáu', N'Ghi chú 47'),
('2024-02-10', 4, 1, 'Approved', 380000, N'Phạm Văn Hậu', N'Nam', '0934123456', N'Hồ Chí Minh - Quận 2 - Phường Bình An', N'27 Lương Định Của', N'Ghi chú 48'),
('2024-03-05', 12, 1, 'Approved', 510000, N'Trần Thị Cúc', N'Nữ', '0978556677', N'Hồ Chí Minh - Quận 3 - Phường 8', N'66 Nam Kỳ Khởi Nghĩa', N'Ghi chú 49'),
('2024-03-25', 10, 1, 'Approved', 690000, N'Nguyễn Văn Minh', N'Nam', '0912447788', N'Hồ Chí Minh - Quận 4 - Phường 16', N'101 Hoàng Diệu', N'Ghi chú 50'),
('2024-04-10', 15, 1, 'Approved', 520000, N'Nguyễn Thị Hạnh', N'Nữ', '0944332244', N'Hồ Chí Minh - Quận 5 - Phường 2', N'59 Trần Hưng Đạo', N'Ghi chú 51'),
('2024-04-22', 27, 1, 'Approved', 630000, N'Bùi Thanh Tùng', N'Nam', '0922556677', N'Hồ Chí Minh - Quận 6 - Phường 1', N'135 Châu Văn Liêm', N'Ghi chú 52'),
('2024-05-15', 8, 1, 'Approved', 580000, N'Tran Thị Kim Hoa', N'Nữ', '0933227766', N'Hồ Chí Minh - Quận 7 - Phường Tân Phú', N'95 Nguyễn Thị Thập', N'Ghi chú 53'),
('2024-05-30', 3, 1, 'Approved', 440000, N'Lê Minh Quang', N'Nam', '0912885544', N'Hồ Chí Minh - Quận 8 - Phường 14', N'47 Phạm Hùng', N'Ghi chú 54'),
('2024-06-12', 24, 1, 'Approved', 370000, N'Tô Ngọc Mai', N'Nữ', '0978991234', N'Hồ Chí Minh - Quận 9 - Phường Long Thạnh Mỹ', N'25 Xa Lộ Hà Nội', N'Ghi chú 55'),
('2024-06-28', 20, 1, 'Approved', 560000, N'Nguyễn Văn Sơn', N'Nam', '0922778899', N'Hồ Chí Minh - Quận 10 - Phường 10', N'12 Nguyễn Tri Phương', N'Ghi chú 56'),
('2024-07-04', 30, 1, 'Approved', 340000, N'Phan Thị Thắm', N'Nữ', '0944338899', N'Hồ Chí Minh - Quận 11 - Phường 3', N'78 Hòa Hảo', N'Ghi chú 57'),
('2024-07-20', 6, 1, 'Approved', 670000, N'Lê Văn Tiến', N'Nam', '0912223344', N'Hồ Chí Minh - Quận 12 - Phường Thạnh Xuân', N'65 Quốc lộ 1A', N'Ghi chú 58'),
('2024-08-08', 16, 1, 'Approved', 290000, N'Nguyễn Thị Loan', N'Nữ', '0978995544', N'Hồ Chí Minh - Quận Bình Thạnh - Phường 11', N'110 Đinh Bộ Lĩnh', N'Ghi chú 59'),
('2024-08-22', 1, 1, 'Approved', 430000, N'Trương Văn Định', N'Nam', '0922883344', N'Hồ Chí Minh - Quận Gò Vấp - Phường 8', N'22 Lê Đức Thọ', N'Ghi chú 60'),
('2024-09-02', 9, 1, 'Approved', 520000, N'Lê Thị Thu', N'Nữ', '0912345533', N'Hồ Chí Minh - Quận Phú Nhuận - Phường 9', N'134 Phan Đăng Lưu', N'Ghi chú 61'),
('2024-09-18', 11, 1, 'Approved', 390000, N'Bùi Văn Bảo', N'Nam', '0932445567', N'Hồ Chí Minh - Quận Tân Phú - Phường Tân Sơn Nhì', N'40 Thoại Ngọc Hầu', N'Ghi chú 62'),
('2024-10-05', 2, 1, 'Approved', 310000, N'Trần Thị Hiền', N'Nữ', '0978332244', N'Hồ Chí Minh - Quận Bình Tân - Phường An Lạc', N'98 Kinh Dương Vương', N'Ghi chú 63'),
('2024-10-12', 25, 1, 'Approved', 570000, N'Phạm Minh Triết', N'Nam', '0911776677', N'Hồ Chí Minh - Quận Thủ Đức - Phường Linh Xuân', N'21 Quốc lộ 1K', N'Ghi chú 64'),
('2024-10-22', 7, 1, 'Approved', 500000, N'Tô Ngọc Thảo', N'Nữ', '0911234455', N'Hồ Chí Minh - Quận Thủ Đức - Phường Linh Trung', N'67 Xa lộ Hà Nội', N'Ghi chú 65'),
('2024-10-29', 5, 1, 'Approved', 610000, N'Lâm Minh Nhựt', N'Nam', '0932996655', N'Hồ Chí Minh - Quận 9 - Phường Phú Hữu', N'43 Đỗ Xuân Hợp', N'Ghi chú 66'),
('2024-01-10', 34, 1, 'Approved', 390000, N'Lê Văn Minh', N'Nam', '0912335566', N'Hồ Chí Minh - Quận 1 - Phường Bến Nghé', N'56 Lê Duẩn', N'Ghi chú 113'),
('2024-01-25', 46, 1, 'Rejected', 420000, N'Trần Thị Thu', N'Nữ', '0922884455', N'Hồ Chí Minh - Quận 2 - Phường Thảo Điền', N'78 Nguyễn Văn Hưởng', N'Ghi chú 114'),
('2024-02-07', 53, 1, 'Approved', 530000, N'Nguyễn Thị Liên', N'Nữ', '0932118899', N'Hồ Chí Minh - Quận 3 - Phường 7', N'90 Võ Thị Sáu', N'Ghi chú 115'),
('2024-02-20', 68, 1, 'Approved', 460000, N'Phạm Văn Thành', N'Nam', '0944885566', N'Hồ Chí Minh - Quận 4 - Phường 13', N'102 Nguyễn Tất Thành', N'Ghi chú 116'),
('2024-03-10', 72, 1, 'Approved', 570000, N'Nguyễn Thị Lan', N'Nữ', '0912776644', N'Hồ Chí Minh - Quận 5 - Phường 1', N'37 Hùng Vương', N'Ghi chú 117'),
('2024-03-29', 59, 1, 'Approved', 410000, N'Lê Thị Hồng', N'Nữ', '0978223344', N'Hồ Chí Minh - Quận 6 - Phường 10', N'11 Minh Phụng', N'Ghi chú 118'),
('2024-04-15', 80, 1, 'Approved', 650000, N'Trần Minh Tâm', N'Nam', '0922997733', N'Hồ Chí Minh - Quận 7 - Phường Tân Phú', N'45 Nguyễn Hữu Thọ', N'Ghi chú 119'),
('2024-04-25', 31, 1, 'Approved', 480000, N'Bùi Văn Hải', N'Nam', '0932998899', N'Hồ Chí Minh - Quận 8 - Phường 5', N'29 Tạ Quang Bửu', N'Ghi chú 120'),
('2024-05-10', 64, 1, 'Approved', 520000, N'Nguyễn Thị Tuyết', N'Nữ', '0912775544', N'Hồ Chí Minh - Quận 9 - Phường Phước Long B', N'23 Đỗ Xuân Hợp', N'Ghi chú 121'),
('2024-05-26', 37, 1, 'Approved', 610000, N'Lê Văn Thắng', N'Nam', '0922334455', N'Hồ Chí Minh - Quận 10 - Phường 12', N'77 Ba Tháng Hai', N'Ghi chú 122'),
('2024-06-05', 57, 1, 'Approved', 330000, N'Nguyễn Thị Tình', N'Nữ', '0938442233', N'Hồ Chí Minh - Quận 11 - Phường 14', N'19 Lạc Long Quân', N'Ghi chú 123'),
('2024-06-17', 40, 1, 'Approved', 580000, N'Tôn Nữ Kim Liên', N'Nữ', '0912779988', N'Hồ Chí Minh - Quận 12 - Phường Hiệp Thành', N'14 Nguyễn Ảnh Thủ', N'Ghi chú 124'),
('2024-07-01', 71, 1, 'Approved', 540000, N'Phạm Văn Quang', N'Nam', '0922773344', N'Hồ Chí Minh - Quận Bình Thạnh - Phường 13', N'33 Xô Viết Nghệ Tĩnh', N'Ghi chú 125'),
('2024-07-23', 38, 1, 'Approved', 470000, N'Lê Thị Nguyệt', N'Nữ', '0912443344', N'Hồ Chí Minh - Quận Tân Bình - Phường 11', N'22 Cộng Hòa', N'Ghi chú 126'),
('2024-08-07', 69, 1, 'Approved', 510000, N'Nguyễn Văn Bình', N'Nam', '0932991122', N'Hồ Chí Minh - Quận Gò Vấp - Phường 16', N'18 Lê Đức Thọ', N'Ghi chú 127'),
('2024-08-15', 45, 1, 'Approved', 430000, N'Phan Thị Bích', N'Nữ', '0922771122', N'Hồ Chí Minh - Quận Phú Nhuận - Phường 1', N'55 Trường Sa', N'Ghi chú 128'),
('2024-09-02', 65, 1, 'Approved', 490000, N'Trần Minh Hải', N'Nam', '0932448899', N'Hồ Chí Minh - Quận Tân Phú - Phường Sơn Kỳ', N'102 Lũy Bán Bích', N'Ghi chú 129'),
('2024-09-17', 43, 1, 'Approved', 370000, N'Trương Thị Như', N'Nữ', '0978335566', N'Hồ Chí Minh - Quận Bình Tân - Phường Bình Trị Đông A', N'24 Mã Lò', N'Ghi chú 130'),
('2024-10-05', 51, 1, 'Approved', 660000, N'Nguyễn Văn Thắng', N'Nam', '0912993344', N'Hồ Chí Minh - Huyện Hóc Môn - Xã Xuân Thới Đông', N'77 Trần Văn Mười', N'Ghi chú 131'),
('2024-10-21', 73, 1, 'Approved', 530000, N'Trần Văn Dũng', N'Nam', '0932335566', N'Hồ Chí Minh - Huyện Củ Chi - Xã Tân Thông Hội', N'19 Quốc lộ 22', N'Ghi chú 132'),
('2024-11-23', 47, 1, 'Pending', 390000, N'Phạm Thị Loan', N'Nữ', '0932996655', N'Hồ Chí Minh - Huyện Bình Chánh - Xã Bình Chánh', N'81 Đoàn Nguyễn Tuấn', N'Ghi chú 133'),
('2024-11-15', 39, 1, 'Pedding', 460000, N'Nguyễn Văn Duy', N'Nam', '0912773344', N'Hồ Chí Minh - Huyện Nhà Bè - Xã Phú Xuân', N'102 Nguyễn Bình', N'Ghi chú 134'),
('2024-11-02', 63, 1, 'Pending', 540000, N'Trương Thị Ngọc Lan', N'Nữ', '0938445566', N'Hồ Chí Minh - Huyện Cần Giờ - Xã Bình Khánh', N'55 Duyên Hải', N'Ghi chú 135'),
('2024-11-18', 78, 1, 'Pending', 500000, N'Trần Văn Bình', N'Nam', '0944556677', N'Hồ Chí Minh - Quận 5 - Phường 10', N'39 Trần Hưng Đạo', N'Ghi chú 136'),
('2024-11-27', 41, 1, 'Pending', 450000, N'Lê Thị Hương', N'Nữ', '0978113344', N'Hồ Chí Minh - Quận 7 - Phường Tân Phong', N'98 Nguyễn Văn Linh', N'Ghi chú 137');

-- 15 giỏ trải đều 15 người đầu tiên
INSERT INTO [Order] (OrderDate, CustomerID, OrderStatus, Status, TotalPrice)
VALUES
('2024-01-20', 1, 0, 'Pending', 380000),
('2024-02-18', 2, 0, 'Pending', 720000),
('2024-03-22', 3, 0, 'Pending', 160000),
('2024-04-12', 4, 0, 'Pending', 410000),
('2024-05-29', 5, 0, 'Pending', 930000),
('2024-06-30', 6, 0, 'Pending', 295000),
('2024-07-08', 7, 0, 'Pending', 520000),
('2024-08-14', 8, 0, 'Pending', 780000),
('2024-09-06', 9, 0, 'Pending', 640000),
('2024-10-13', 10, 0, 'Pending', 360000),
('2024-11-20', 11, 0, 'Pending', 290000),
('2024-10-05', 12, 0, 'Pending', 470000),
('2024-09-10', 13, 0, 'Pending', 540000),
('2024-11-15', 14, 0, 'Pending', 180000),
('2024-10-20', 15, 0, 'Pending', 750000);
-- coi lại giá của 2 bảng xem hợp lý chưa
CREATE TABLE OrderItem (
    OrderItemID INT PRIMARY KEY IDENTITY(1,1), -- Mã chi tiết đơn hàng (tự động tăng)
    OrderID INT,                               -- Mã đơn hàng (liên kết với bảng Order)
    ProductID INT,                             -- Mã sản phẩm (liên kết với bảng Product)
    Quantity INT NOT NULL,                     -- Số lượng sản phẩm
    UnitPrice DECIMAL(18, 0) default 0,         -- Giá sản phẩm * so lượng
    -- Ràng buộc khóa ngoại
    FOREIGN KEY (OrderID) REFERENCES [Order](OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID) 
);


INSERT INTO OrderItem (OrderID, ProductID, Quantity, UnitPrice)
VALUES 
(1, 1, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 1)), 
(1, 2, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 2)),
(2, 3, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 3)),  -- Olym Pianus Infinity với số lượng 1
(2, 4, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 4) * 2),
(3, 5, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 5)),   -- Orient Distinctive với số lượng 1
(3, 6, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 6)),
(4, 67, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 67)),  
(4, 18, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 28)),
(5, 16, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 16)), -- Sản phẩm 16 với số lượng 1
(5, 17, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 17)*3), -- Sản phẩm 17 với số lượng 3
(5, 18, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 18)*2), -- Sản phẩm 18 với số lượng 2
(5, 19, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 19)*4), -- Sản phẩm 19 với số lượng 4
(6, 20, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 20)), -- Sản phẩm 20 với số lượng 1
(6, 21, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 21)*3), -- Sản phẩm 21 với số lượng 3
(7, 22, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 22)*5), -- Sản phẩm 22 với số lượng 5
(7, 23, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 23)*2), -- Sản phẩm 23 với số lượng 2
(7, 24, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 24)*4), -- Sản phẩm 24 với số lượng 4
(8, 25, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 25)), -- Sản phẩm 25 với số lượng 1
(9, 5, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 5)*2),  -- Sản phẩm 5 với số lượng 2
(9, 6, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 6)*3),  -- Sản phẩm 6 với số lượng 3
(10, 7, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 7)),  -- Sản phẩm 7 với số lượng 1
(10, 8, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 8)*4),  -- Sản phẩm 8 với số lượng 4
(11, 9, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 9)*5),  -- Sản phẩm 9 với số lượng 5
(12, 10, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 10)*2), -- Sản phẩm 10 với số lượng 2
(13, 11, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 11)*3), -- Sản phẩm 11 với số lượng 3
(13, 12, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 12)), -- Sản phẩm 12 với số lượng 1
(13, 13, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 13)*4), -- Sản phẩm 13 với số lượng 4
(14, 14, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 14)*2), -- Sản phẩm 14 với số lượng 2
(14, 15, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 15)*5),
(15, 3, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 3)*2),  -- Sản phẩm 3 với số lượng 2
(16, 10, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 10)), -- Sản phẩm 10 với số lượng 1
(16, 12, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 12)*4), -- Sản phẩm 12 với số lượng 4
(17, 25, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 25)*3), -- Sản phẩm 25 với số lượng 3
(17, 35, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 35)*5), -- Sản phẩm 35 với số lượng 5
(18, 41, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 41)), -- Sản phẩm 41 với số lượng 1
(18, 46, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 46)*2), -- Sản phẩm 46 với số lượng 2
(18, 51, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 51)*4), -- Sản phẩm 51 với số lượng 4
(19, 53, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 53)*3), -- Sản phẩm 53 với số lượng 3
(20, 60, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 60)*5), -- Sản phẩm 60 với số lượng 5
(20, 62, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 62)*2), -- Sản phẩm 62 với số lượng 2
(21, 68, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 68)*3), -- Sản phẩm 68 với số lượng 3
(22, 72, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 72)), -- Sản phẩm 72 với số lượng 1
(23, 74, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 74)*4), -- Sản phẩm 74 với số lượng 4
(23, 78, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 78)*5), -- Sản phẩm 78 với số lượng 5
(24, 80, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 80)*2), -- Sản phẩm 80 với số lượng 2
(25, 7, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 7)*3),  -- Sản phẩm 7 với số lượng 3
(25, 17, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 17)), -- Sản phẩm 17 với số lượng 1
(26, 33, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 33)*4), -- Sản phẩm 33 với số lượng 4
(27, 42, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 42)*5), -- Sản phẩm 42 với số lượng 5
(28, 30, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 30)*2),
(29, 2, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 2)*3),   -- Sản phẩm 2 với số lượng 3
(29, 15, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 15)),  -- Sản phẩm 15 với số lượng 1
(30, 23, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 23)*4),  -- Sản phẩm 23 với số lượng 4
(31, 33, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 33)*2),  -- Sản phẩm 33 với số lượng 2
(31, 36, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 36)*5),  -- Sản phẩm 36 với số lượng 5
(32, 45, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 45)*3),  -- Sản phẩm 45 với số lượng 3
(32, 57, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 57)),  -- Sản phẩm 57 với số lượng 1
(33, 62, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 62)*4),  -- Sản phẩm 62 với số lượng 4
(33, 67, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 67)*2),  -- Sản phẩm 67 với số lượng 2
(34, 71, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 71)*5),  -- Sản phẩm 71 với số lượng 5
(35, 5, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 5)*3),    -- Sản phẩm 5 với số lượng 3
(36, 12, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 12)),  -- Sản phẩm 12 với số lượng 1
(37, 18, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 18)*4),  -- Sản phẩm 18 với số lượng 4
(37, 22, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 22)*2),  -- Sản phẩm 22 với số lượng 2
(38, 31, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 31)*5),  -- Sản phẩm 31 với số lượng 5
(39, 38, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 38)*3),  -- Sản phẩm 38 với số lượng 3
(39, 48, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 48)),  -- Sản phẩm 48 với số lượng 1
(40, 54, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 54)*4),  -- Sản phẩm 54 với số lượng 4
(40, 65, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 65)*2),  -- Sản phẩm 65 với số lượng 2
(41, 73, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 73)*5),  -- Sản phẩm 73 với số lượng 5
(42, 79, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 79)*3),
(43, 8, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 8)*3),    -- Sản phẩm 8 với số lượng 3
(44, 9, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 9)*2),    -- Sản phẩm 9 với số lượng 2
(44, 24, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 24)*5),   -- Sản phẩm 24 với số lượng 5
(45, 26, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 26)),   -- Sản phẩm 26 với số lượng 1
(46, 29, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 29)*4),   -- Sản phẩm 29 với số lượng 4
(46, 34, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 34)*3),   -- Sản phẩm 34 với số lượng 3
(46, 39, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 39)*2),   -- Sản phẩm 39 với số lượng 2
(47, 40, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 40)*5),   -- Sản phẩm 40 với số lượng 5
(47, 44, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 44)),   -- Sản phẩm 44 với số lượng 1
(48, 49, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 49)*4),   -- Sản phẩm 49 với số lượng 4
(49, 50, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 50)*3),   -- Sản phẩm 50 với số lượng 3
(50, 52, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 52)*2),   -- Sản phẩm 52 với số lượng 2
(50, 55, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 55)*5),   -- Sản phẩm 55 với số lượng 5
(51, 56, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 56)),   -- Sản phẩm 56 với số lượng 1
(52, 58, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 58)*4),   -- Sản phẩm 58 với số lượng 4
(53, 59, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 59)*3),   -- Sản phẩm 59 với số lượng 3
(53, 61, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 61)*2),   -- Sản phẩm 61 với số lượng 2
(54, 63, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 63)*5),   -- Sản phẩm 63 với số lượng 5
(55, 64, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 64)),   -- Sản phẩm 64 với số lượng 1
(56, 66, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 66)*4),   -- Sản phẩm 66 với số lượng 4
(57, 70, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 70)*3),   -- Sản phẩm 70 với số lượng 3
(58, 75, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 75)*2),   -- Sản phẩm 75 với số lượng 2
(59, 76, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 76)*5),   -- Sản phẩm 76 với số lượng 5
(60, 77, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 77)),   -- Sản phẩm 77 với số lượng 1
(60, 80, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 80)*4),   -- Sản phẩm 80 với số lượng 4
(61, 11, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 11)*3),   -- Sản phẩm 11 với số lượng 3
(62, 14, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 14)*2),   -- Sản phẩm 14 với số lượng 2
(63, 19, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 19)*5),   -- Sản phẩm 19 với số lượng 5
(64, 27, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 27)),   -- Sản phẩm 27 với số lượng 1
(64, 30, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 30)*4),   -- Sản phẩm 30 với số lượng 4\
(64, 1, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 1) * 2),   -- Sản phẩm 1 với số lượng 2
(65, 3, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 3) * 5),   -- Sản phẩm 3 với số lượng 5
(66, 4, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 4) * 1),   -- Sản phẩm 4 với số lượng 1
(67, 6, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 6) * 4),   -- Sản phẩm 6 với số lượng 4
(67, 7, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 7) * 3),   -- Sản phẩm 7 với số lượng 3
(68, 10, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 10) * 2), -- Sản phẩm 10 với số lượng 2
(69, 11, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 11) * 5), -- Sản phẩm 11 với số lượng 5
(70, 13, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 13) * 1), -- Sản phẩm 13 với số lượng 1
(70, 17, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 17) * 4), -- Sản phẩm 17 với số lượng 4
(71, 20, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 20) * 3), -- Sản phẩm 20 với số lượng 3
(72, 25, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 25) * 2), -- Sản phẩm 25 với số lượng 2
(73, 28, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 28) * 5), -- Sản phẩm 28 với số lượng 5
(74, 32, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 32) * 1), -- Sản phẩm 32 với số lượng 1
(74, 35, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 35) * 4), -- Sản phẩm 35 với số lượng 4
(75, 41, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 41) * 3), -- Sản phẩm 41 với số lượng 3
(76, 42, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 42) * 2), -- Sản phẩm 42 với số lượng 2
(77, 46, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 46) * 5), -- Sản phẩm 46 với số lượng 5
(78, 47, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 47) * 1), -- Sản phẩm 47 với số lượng 1
(79, 51, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 51) * 4), -- Sản phẩm 51 với số lượng 4
(80, 53, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 53) * 3), -- Sản phẩm 53 với số lượng 3
(81, 60, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 60) * 2), -- Sản phẩm 60 với số lượng 2
(81, 68, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 68) * 5), -- Sản phẩm 68 với số lượng 5
(82, 69, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 69) * 1), -- Sản phẩm 69 với số lượng 1
(83, 74, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 74) * 4), -- Sản phẩm 74 với số lượng 4
(84, 78, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 78) * 3), -- Sản phẩm 78 với số lượng 3
(85, 1, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 1) * 3),    -- Sản phẩm 1 với số lượng 3
(85, 5, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 5) * 2),    -- Sản phẩm 5 với số lượng 2
(86, 10, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 10) * 4),  -- Sản phẩm 10 với số lượng 4
(86, 15, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 15) * 1),  -- Sản phẩm 15 với số lượng 1
(87, 20, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 20) * 3),  -- Sản phẩm 20 với số lượng 3
(88, 25, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 25) * 5),  -- Sản phẩm 25 với số lượng 5
(88, 30, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 30) * 2),  -- Sản phẩm 30 với số lượng 2
(89, 32, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 32) * 4),  -- Sản phẩm 32 với số lượng 4
(90, 34, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 34) * 1),  -- Sản phẩm 34 với số lượng 1
(91, 38, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 38) * 3),  -- Sản phẩm 38 với số lượng 3
(92, 42, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 42) * 2),  -- Sản phẩm 42 với số lượng 2
(92, 44, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 44) * 5),  -- Sản phẩm 44 với số lượng 5
(93, 47, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 47) * 1),  -- Sản phẩm 47 với số lượng 1
(94, 52, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 52) * 4),  -- Sản phẩm 52 với số lượng 4
(95, 54, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 54) * 3),  -- Sản phẩm 54 với số lượng 3
(95, 58, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 58) * 5),  -- Sản phẩm 58 với số lượng 5
(96, 61, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 61) * 2),  -- Sản phẩm 61 với số lượng 2
(97, 63, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 63) * 1),  -- Sản phẩm 63 với số lượng 1
(98, 66, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 66) * 4),  -- Sản phẩm 66 với số lượng 4
(99, 68, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 68) * 3),  -- Sản phẩm 68 với số lượng 3
(100, 72, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 72) * 2),  -- Sản phẩm 72 với số lượng 2
(101, 74, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 74) * 5),  -- Sản phẩm 74 với số lượng 5
(102, 77, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 77) * 1),  -- Sản phẩm 77 với số lượng 1
(103, 79, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 79) * 3),  -- Sản phẩm 79 với số lượng 3
(104, 2, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 2) * 4),    -- Sản phẩm 2 với số lượng 4
(105, 3, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 3) * 2),    -- Sản phẩm 3 với số lượng 2
(106, 6, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 6) * 5),    -- Sản phẩm 6 với số lượng 5
(107, 8, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 8) * 1),    -- Sản phẩm 8 với số lượng 1
(108, 9, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 9) * 3),    -- Sản phẩm 9 với số lượng 3
(109, 12, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 12) * 4),   -- Sản phẩm 12 với số lượng 4
(110, 14, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 14) * 2),   -- Sản phẩm 14 với số lượng 2
(111, 16, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 16) * 5),   -- Sản phẩm 16 với số lượng 5
(112, 19, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 19) * 1),   -- Sản phẩm 19 với số lượng 1
(113, 21, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 21) * 4),   -- Sản phẩm 21 với số lượng 4
(114, 23, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 23) * 3),   -- Sản phẩm 23 với số lượng 3
(115, 27, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 27) * 2),   -- Sản phẩm 27 với số lượng 2
(116, 29, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 29) * 5),
(117, 1, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 1) * 4),    -- Sản phẩm 1 với số lượng 4
(118, 7, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 7) * 2),    -- Sản phẩm 7 với số lượng 2
(118, 10, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 10) * 5),  -- Sản phẩm 10 với số lượng 5
(119, 13, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 13) * 3),  -- Sản phẩm 13 với số lượng 3
(120, 16, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 16) * 1),  -- Sản phẩm 16 với số lượng 1
(121, 20, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 20) * 4),  -- Sản phẩm 20 với số lượng 4
(122, 21, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 21) * 2),  -- Sản phẩm 21 với số lượng 2
(123, 25, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 25) * 5),  -- Sản phẩm 25 với số lượng 5
(124, 28, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 28) * 3),  -- Sản phẩm 28 với số lượng 3
(125, 32, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 32) * 4),  -- Sản phẩm 32 với số lượng 4
(126, 35, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 35) * 1),  -- Sản phẩm 35 với số lượng 1
(127, 37, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 37) * 2),  -- Sản phẩm 37 với số lượng 2
(128, 41, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 41) * 5),  -- Sản phẩm 41 với số lượng 5
(129, 42, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 42) * 3),  -- Sản phẩm 42 với số lượng 3
(130, 46, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 46) * 4),  -- Sản phẩm 46 với số lượng 4
(131, 47, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 47) * 2),  -- Sản phẩm 47 với số lượng 2
(132, 51, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 51) * 1),  -- Sản phẩm 51 với số lượng 1
(133, 53, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 53) * 5),  -- Sản phẩm 53 với số lượng 5
(134, 60, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 60) * 3),  -- Sản phẩm 60 với số lượng 3
(135, 68, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 68) * 4),  -- Sản phẩm 68 với số lượng 4
(136, 69, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 69) * 1),  -- Sản phẩm 69 với số lượng 1
(137, 72, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 72) * 2),  -- Sản phẩm 72 với số lượng 2
(138, 74, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 74) * 5),  -- Sản phẩm 74 với số lượng 5
(139, 78, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 78) * 3),  -- Sản phẩm 78 với số lượng 3
(140, 3, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 3) * 4),    -- Sản phẩm 3 với số lượng 4
(141, 6, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 6) * 1),    -- Sản phẩm 6 với số lượng 1
(142, 12, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 12) * 2),  -- Sản phẩm 12 với số lượng 2
(143, 17, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 17) * 5),  -- Sản phẩm 17 với số lượng 5
(144, 30, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 30) * 3),  -- Sản phẩm 30 với số lượng 3
(145, 39, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 39) * 4),  -- Sản phẩm 39 với số lượng 4
(146, 55, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 55) * 1),  -- Sản phẩm 55 với số lượng 1
(147, 64, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 64) * 2),   -- Sản phẩm 64 với số lượng 2
(148, 1, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 1) * 2),   -- Sản phẩm 1 với số lượng 2
(149, 3, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 3) * 4),   -- Sản phẩm 3 với số lượng 4
(149, 7, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 7) * 1),   -- Sản phẩm 7 với số lượng 1
(150, 9, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 9) * 3),   -- Sản phẩm 9 với số lượng 3
(151, 13, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 13) * 5), -- Sản phẩm 13 với số lượng 5
(152, 16, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 16) * 2), -- Sản phẩm 16 với số lượng 2
(153, 20, 3, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 20) * 3), -- Sản phẩm 20 với số lượng 3
(154, 25, 4, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 25) * 4), -- Sản phẩm 25 với số lượng 4
(155, 32, 1, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 32) * 1), -- Sản phẩm 32 với số lượng 1
(156, 34, 5, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 34) * 5), -- Sản phẩm 34 với số lượng 5
(156, 39, 2, (SELECT Price * (1 - CAST(Discount AS DECIMAL(10,2)) / 100)  FROM Product WHERE ProductID = 39) * 2); -- Sản phẩm 39 với số lượng 2
-- trong giỏ 15 
INSERT INTO OrderItem (OrderID, ProductID, Quantity)
VALUES 
(157, 42, 3), -- Sản phẩm 42 với số lượng 3
(157, 14, 2),   -- Sản phẩm 14 với số lượng 2
(157, 16, 5),   -- Sản phẩm 16 với số lượng 5
(158, 19, 1),   -- Sản phẩm 19 với số lượng 1
(158, 21, 4), -- Sản phẩm 21 với số lượng 4
(159, 23, 3),   -- Sản phẩm 23 với số lượng 3
(159, 27, 2),  -- Sản phẩm 27 với số lượng 2
(160, 47, 4), -- Sản phẩm 47 với số lượng 4
(158, 51, 1), -- Sản phẩm 51 với số lượng 1
(158, 54, 5), -- Sản phẩm 54 với số lượng 5
(159, 60, 3), -- Sản phẩm 60 với số lượng 3
(159, 65, 4), -- Sản phẩm 65 với số lượng 4
(160, 69, 1), -- Sản phẩm 69 với số lượng 1
(160, 72, 5), -- Sản phẩm 72 với số lượng 5
(161, 78, 2), -- Sản phẩm 78 với số lượng 2
(161, 80, 3), -- Sản phẩm 80 với số lượng 3
(162, 2, 3),  -- Sản phẩm 2 với số lượng 3
(163, 74, 5),  -- Sản phẩm 74 với số lượng 5
(164, 77, 1),  -- Sản phẩm 77 với số lượng 1
(165, 79, 3),  -- Sản phẩm 79 với số lượng 3
(166, 2, 4),    -- Sản phẩm 2 với số lượng 4
(167, 3, 2),    -- Sản phẩm 3 với số lượng 2
(168, 6, 5),    -- Sản phẩm 6 với số lượng 5
(169, 8, 1),    -- Sản phẩm 8 với số lượng 1
(170, 9, 3),    -- Sản phẩm 9 với số lượng 3
(171, 12, 4);   -- Sản phẩm 12 với số lượng 4


-- Cập nhật TotalPrice cho các đơn hàng
UPDATE [Order] SET TotalPrice = (SELECT SUM(UnitPrice) FROM OrderItem WHERE OrderID = [Order].OrderID);








CREATE TABLE [dbo].[Voucher] (
    [Id]            INT             IDENTITY (1, 1) NOT NULL,
    [Code]          VARCHAR (50)    NOT NULL,
    [Type]          CHAR (1)        NOT NULL,
    [Value]         DECIMAL (10, 2) NOT NULL,
    [RemainingUses] INT             NOT NULL,
    [MinOrderValue] DECIMAL (10, 2) NOT NULL,
    [status]        INT             DEFAULT ((1)) NOT NULL,
    [ExpDate]       DATE            DEFAULT (dateadd(day,(7),getdate())) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([Code] ASC),
    CHECK ([type]='F ' OR [type]='P')		
); 


INSERT INTO [dbo].[Voucher] ([Code], [Type], [Value], [RemainingUses], [MinOrderValue], [status])
VALUES
('GG200K', 'F', 200000, 10, 6000000, 1),
('GG300K ', 'F', 300000, 10, 10000000, 1);





CREATE TABLE [dbo].[OTP] (
    [OTPID]         INT            IDENTITY (1, 1) NOT NULL,
	[CustomerID]    INT            NOT NULL,
    [OTPCode]       NVARCHAR (6)   NOT NULL,
    [ExpiresAt]     DATETIME       NOT NULL DEFAULT (DATEADD(MINUTE, 10, GETDATE())),
    PRIMARY KEY CLUSTERED ([OTPID] ASC),
    FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customer]([CustomerID]),
    CHECK ([OTPCode] LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]')
);
INSERT INTO [dbo].[OTP] ([CustomerID], [OTPCode])
VALUES 
(1, '123456'),
(2, '654321');



