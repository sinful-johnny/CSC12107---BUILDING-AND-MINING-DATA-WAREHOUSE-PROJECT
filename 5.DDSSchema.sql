USE master
GO

IF DB_ID('QLLopHoc_DDS') IS NOT NULL
BEGIN
    ALTER DATABASE QLLopHoc_DDS
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE
    DROP DATABASE QLLopHoc_DDS
END
GO

CREATE DATABASE QLLopHoc_DDS
GO
USE QLLopHoc_DDS
GO

CREATE TABLE Dim_LopHoc (
    MaLop_SK INT NOT NULL IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
    MaLop_NK NVARCHAR(50) NOT NULL,            -- Natural Key
    TenLop NVARCHAR(255),                      -- Class name
    SiSo INT,                                  -- Number of students
    CreatedDate DATETIME DEFAULT GETDATE(),    -- Record creation date
    UpdatedDate DATETIME DEFAULT GETDATE()     -- Last update timestamp
);

-- Create Dim_HocSinh: Dimension table for students and their classes
CREATE TABLE Dim_HocSinh (
    MaHS_SK INT NOT NULL IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
    MaHS_NK NVARCHAR(50) NOT NULL,            -- Natural Key
    HoVaTen NVARCHAR(255),                    -- Student's full name
    NgaySinh DATE,                            -- Date of birth
    GioiTinh NVARCHAR(50),                    -- Gender
    MaLop_SK INT NOT NULL,                    -- Surrogate Key for LopHoc
    CreatedDate DATETIME DEFAULT GETDATE(),   -- Record creation date
    UpdatedDate DATETIME DEFAULT GETDATE(),   -- Last update timestamp
    CONSTRAINT FK_DimHocSinh_DimLopHoc FOREIGN KEY (MaLop_SK) REFERENCES Dim_LopHoc(MaLop_SK)
);

-- Create Dim_MonHoc: Dimension table for courses
CREATE TABLE Dim_MonHoc (
    MaMH_SK INT NOT NULL IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
    MaMH_NK NVARCHAR(50) NOT NULL,            -- Natural Key
    TenMH NVARCHAR(255),                      -- Subject name
    SoTC INT,                                 -- Number of credits
    CreatedDate DATETIME DEFAULT GETDATE(),   -- Record creation date
    UpdatedDate DATETIME DEFAULT GETDATE()    -- Last update timestamp
);

-- Create Fact_ThongKe: Fact table for statistics
CREATE TABLE Fact_ThongKe (
    ThongKe_SK INT NOT NULL IDENTITY(1,1) PRIMARY KEY, -- Fact table key
    MaHS_SK INT NOT NULL,                        -- Foreign key to Dim_HocSinh
    MaMH_SK INT NOT NULL,                         -- Foreign key to Dim_MonHoc
    DiemHS FLOAT,                     -- Class name for reporting
    SoLuongDauCuaMon INT,                                -- Number of failed students
    SoLuongRotCuaMon INT,                                -- Number of passed students
    SoLuongRotMonCuaLop INT,
    CONSTRAINT FK_Fact_ThongKe_Dim_HocSinh FOREIGN KEY (MaHS_SK) REFERENCES Dim_HocSinh(MaHS_SK),
    CONSTRAINT FK_Fact_ThongKe_Dim_MonHoc FOREIGN KEY (MaMH_SK) REFERENCES Dim_MonHoc(MaMH_SK)
);






--So luong rot, so luong dau
SELECT MH.MaMH_SK, 
       COALESCE(FailedStats.SoLuongRotCuaMon, 0) AS SoLuongRotCuaMon,
       (TotalStats.TotalStudents - COALESCE(FailedStats.SoLuongRotCuaMon, 0)) AS SoLuongDauCuaMon
FROM Dim_MonHoc MH
LEFT JOIN (
    SELECT MaMH_SK, COUNT(DISTINCT MaHS_SK) AS SoLuongRotCuaMon
    FROM Fact_ThongKe
    WHERE DiemHS < 5
    GROUP BY MaMH_SK
) AS FailedStats
ON MH.MaMH_SK = FailedStats.MaMH_SK
LEFT JOIN (
    SELECT MaMH_SK, COUNT(DISTINCT MaHS_SK) AS TotalStudents
    FROM Fact_ThongKe
    GROUP BY MaMH_SK
) AS TotalStats
ON MH.MaMH_SK = TotalStats.MaMH_SK;



--So luong rot mon X cua lop Y
SELECT TK.MaMH_SK, COUNT(DISTINCT TK.MaHS_SK) AS SoLuongRotMonCuaLop
    FROM Fact_ThongKe TK, Dim_MonHoc MH, Dim_HocSinh HS, Dim_LopHoc LH
    WHERE TK.DiemHS < 5
        AND TK.MaMH_SK = MH.MaMH_SK
        AND MH.TenMH = 'X'
        AND TK.MaHS_SK = HS.MaHS_SK
        AND HS.MaLop_SK = LH.MaLop_SK
        AND LH.TenLop = 'Y'
    GROUP BY TK.MaMH_SK