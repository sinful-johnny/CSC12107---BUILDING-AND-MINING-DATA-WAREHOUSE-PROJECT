-- drop database QLLopHoc_NDS
-- go


create database QLLopHoc_NDS
go

use QLLopHoc_NDS
go


-- Create LopHoc_NDS table
CREATE TABLE LopHoc_NDS (
    MaLop_SK INT NOT NULL IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
    MaLop_NK VARCHAR(5) NOT NULL,            -- Natural Key
    [tên lớp] NVARCHAR(255),                      -- Class name
    siso INT,                                  -- Number of students
    createdDate DATETIME DEFAULT GETDATE(),    -- Record creation date
    UpdatedDate DATETIME DEFAULT GETDATE()     -- Last update timestamp
);

-- Create HocSinh_NDS table
CREATE TABLE HocSinh_NDS (
    MaHS_SK INT NOT NULL IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
    MaHS_NK VARCHAR(5) NOT NULL,            -- Natural Key
    Hovaten NVARCHAR(255),                    -- Student's full name
    ngaySinh DATE,                            -- Date of birth
    gioitinh NVARCHAR(50),                    -- Gender
    malopSK INT NOT NULL,                    -- Surrogate Key for LopHoc
    createdDate DATETIME DEFAULT GETDATE(),   -- Record creation date
    UpdatedDate DATETIME DEFAULT GETDATE(),   -- Last update timestamp
    CONSTRAINT FK_HocSinh_LopHoc FOREIGN KEY (malopSK) REFERENCES LopHoc_NDS(MaLop_SK)
);

-- Create MonHoc_NDS table
CREATE TABLE MonHoc_NDS (
    MaMH_SK INT NOT NULL IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
    MaMH_NK VARCHAR(5) NOT NULL,            -- Natural Key
    TenMH NVARCHAR(255),                      -- Subject name
    SoTC INT,                                 -- Number of credits
    createdDate DATETIME DEFAULT GETDATE(),   -- Record creation date
    UpdatedDate DATETIME DEFAULT GETDATE()    -- Last update timestamp
);

-- Create Diem_NDS table
CREATE TABLE Diem_NDS (
    MaHS_SK INT NOT NULL,                     -- Surrogate Key for HocSinh
    MaMH_SK INT NOT NULL,                     -- Surrogate Key for MonHoc
    diem FLOAT,                               -- Score
    createdDate DATETIME DEFAULT GETDATE(),   -- Record creation date
    UpdatedDate DATETIME DEFAULT GETDATE(),   -- Last update timestamp
    PRIMARY KEY (MaHS_SK, MaMH_SK),           -- Composite Primary Key
    CONSTRAINT FK_Diem_HocSinh FOREIGN KEY (MaHS_SK) REFERENCES HocSinh_NDS(MaHS_SK),
    CONSTRAINT FK_Diem_MonHoc FOREIGN KEY (MaMH_SK) REFERENCES MonHoc_NDS(MaMH_SK)
);