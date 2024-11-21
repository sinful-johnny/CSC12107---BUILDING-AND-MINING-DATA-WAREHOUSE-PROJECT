CREATE TABLE Stage_LopHoc (
    Ma_lop VARCHAR2(5) PRIMARY KEY,
    Ten_lop NVARCHAR2(255) NOT NULL,
    createdAt TIMESTAMP,
    updatedAt TIMESTAMP
);
CREATE TABLE Stage_Học_sinh (
    Mã_học_sinh VARCHAR2(5) PRIMARY KEY,
    Họ_tên NVARCHAR2(255) NOT NULL,
    Ngày_sinh DATE NOT NULL,
    Giới_tính NVARCHAR2(10) NOT NULL,
    Malop VARCHAR2(5),
    createdAt TIMESTAMP,
    updatedAt TIMESTAMP
);
CREATE TABLE Stage_MonHoc (
    MaMH VARCHAR2(5) PRIMARY KEY,
    TenMH NVARCHAR2(255) NOT NULL,
    SoTC NUMBER,
    createdAt TIMESTAMP,
    updatedAt TIMESTAMP
);
CREATE TABLE Stage_Diem (
    MaHS VARCHAR2(5),
    MaMH VARCHAR2(5),
    Diem NUMBER(5,2),
    PRIMARY KEY (MaHS, MaMH),
    createdAt TIMESTAMP,
    updatedAt TIMESTAMP
);
