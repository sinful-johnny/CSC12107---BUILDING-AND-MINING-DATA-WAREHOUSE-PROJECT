create table lophoc_nds (
   malop_sk    number
      generated by default on null as identity
   primary key,  -- Surrogate Key with auto-increment
   malop_nk    varchar2(5) not null,  -- Natural Key
   tên_lớp     nvarchar2(255),  -- Class name
   siso        number,  -- Number of students
   createddate timestamp default current_timestamp,  -- Record creation date
   updateddate timestamp default current_timestamp  -- Last update timestamp
);
@task
create table hocsinh_nds (
   mahs_sk     number
      generated by default on null as identity
   primary key,  -- Surrogate Key with auto-increment
   mahs_nk     varchar2(5) not null,  -- Natural Key
   hovaten     nvarchar2(255),  -- Student's full name
   ngaysinh    date,  -- Date of birth
   gioitinh    nvarchar2(50),  -- Gender
   malopsk     number not null,  -- Surrogate Key for LopHoc
   createddate timestamp default current_timestamp,  -- Record creation date
   updateddate timestamp default current_timestamp,  -- Last update timestamp
   constraint fk_hocsinh_lophoc foreign key ( malopsk )
      references lophoc_nds ( malop_sk )
);

create table monhoc_nds (
   mamh_sk     number
      generated by default on null as identity
   primary key,  -- Surrogate Key with auto-increment
   mamh_nk     varchar2(5) not null,  -- Natural Key
   tenmh       nvarchar2(255),  -- Subject name
   sotc        number,  -- Number of credits
   createddate timestamp default current_timestamp,  -- Record creation date
   updateddate timestamp default current_timestamp  -- Last update timestamp
);

create table diem_nds (
   mahs_sk     number not null,  -- Surrogate Key for HocSinh
   mamh_sk     number not null,  -- Surrogate Key for MonHoc
   diem        number,  -- Score
   createddate timestamp default current_timestamp,  -- Record creation date
   updateddate timestamp default current_timestamp,  -- Last update timestamp
   primary key ( mahs_sk,
                 mamh_sk ),  -- Composite Primary Key
   constraint fk_diem_hocsinh foreign key ( mahs_sk )
      references hocsinh_nds ( mahs_sk ),
   constraint fk_diem_monhoc foreign key ( mamh_sk )
      references monhoc_nds ( mamh_sk )
);