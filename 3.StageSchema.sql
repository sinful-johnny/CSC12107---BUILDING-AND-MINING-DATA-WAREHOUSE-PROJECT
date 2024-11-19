-- use master
-- go
drop database QLLopHoc_Stage
go

create database QLLopHoc_Stage
go

use QLLopHoc_Stage
go

-- select * from Stage_LopHoc
-- select * from Stage_Học_sinh
-- select * from Stage_MonHoc
-- select * from Stage_Diem


CREATE TABLE Stage_LopHoc (
    [Ma_lop] varchar(5) PRIMARY KEY,
    [Ten_lop] NVARCHAR(255) NOT NULL,
	createdAt datetime,
	updatedAt datetime
);


CREATE TABLE [Stage_Học_sinh] (
    [Mã_học_sinh] VARCHAR(5) PRIMARY KEY,
    [Họ_tên] NVARCHAR(255) NOT NULL,
    [Ngày_sinh] DATE NOT NULL,
    [Giới_tính] NVARCHAR(10) NOT NULL,
    [Malop] VARCHAR(5),
	createdAt datetime,
	updatedAt datetime
);

CREATE TABLE Stage_MonHoc (
    MaMH VARCHAR(5) PRIMARY KEY,
    TenMH NVARCHAR(255) NOT NULL,
    SoTC INT,
	createdAt datetime,
	updatedAt datetime
);

CREATE TABLE Stage_Diem (
    MaHS VARCHAR(5),
    MaMH VARCHAR(5),
    Diem DECIMAL(5,2),
    PRIMARY KEY (MaHS, MaMH),
	createdAt datetime,
	updatedAt datetime
);

select *
from Stage_Diem
