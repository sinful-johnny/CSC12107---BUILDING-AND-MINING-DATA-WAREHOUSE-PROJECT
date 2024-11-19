use QLLopHoc_Stage_Error
go

CREATE TABLE Stage_LopHoc_Error (
    id_Stage_LopHoc_Error int not null identity(1,1) PRIMARY KEY,
    [Ma_lop] varchar(5),
    [Ten_lop] NVARCHAR(255) NOT NULL,
    id_rule_violated int,
    createdAt datetime
);


CREATE TABLE [Stage_Học_sinh_Error] (
    [id_Stage_Học_sinh_Error] int not null identity(1,1) PRIMARY KEY,
    [Mã_học_sinh] VARCHAR(5),
    [Họ_tên] NVARCHAR(255) NOT NULL,
    [Ngày_sinh] DATE NOT NULL,
    [Giới_tính] NVARCHAR(10) NOT NULL,
    [Malop] VARCHAR(5),
    id_rule_violated int,
    createdAt datetime
);

select *
from [Stage_Học_sinh_Error]

update [Stage_Học_sinh_Error]
set id_rule_violated = 1

CREATE TABLE Stage_MonHoc_Error (
    id_Stage_MonHoc_Error int not null identity(1,1) PRIMARY KEY,
    MaMH VARCHAR(5),
    TenMH VARCHAR(255) NOT NULL,
    id_rule_violated int,
    createdAt datetime
);

CREATE TABLE Stage_Diem_Error (
    id_Stage_Diem_Error int not null identity(1,1) PRIMARY KEY,
    MaHS VARCHAR(5),
    MaMH VARCHAR(5),
    Diem DECIMAL(5,2),
    id_rule_violated int,
    createdAt datetime
);