--drop database QLLopHoc_Metadata
--go

create database QLLopHoc_Metadata
go

use QLLopHoc_Metadata
go

CREATE TABLE Package
(
    package_id INT NOT NULL IDENTITY(0,1) PRIMARY KEY,
    package_name NVARCHAR(255),
    description NVARCHAR(255),
    schedule VARCHAR(255)
);

CREATE TABLE Status 
(
    status_id INT NOT NULL IDENTITY(0,1) PRIMARY KEY,
    status_name VARCHAR(50)
);

CREATE TABLE Source
(
    source_id INT NOT NULL IDENTITY(0,1) PRIMARY KEY,
    source_name NVARCHAR(255),
    source_file NVARCHAR(255),
);

CREATE TABLE data_flows 
(
    data_flow_id INT NOT NULL IDENTITY(0,1) PRIMARY KEY,
    data_flow_name NVARCHAR(255),
    description NVARCHAR(255),
    source_id INT,
    transformation VARCHAR(255),
    package_id int,
    status_id int,
    CET DATETIME,
    LSET DATETIME,

    CONSTRAINT FK_DataFlows_Source
    FOREIGN KEY (source_id) REFERENCES [Source](source_id),

    CONSTRAINT FK_DataFlows_Status
    FOREIGN KEY (status_id) REFERENCES [Status](status_id),

    CONSTRAINT FK_DataFlows_Package
    FOREIGN KEY (package_id) REFERENCES [Package](package_id),
);

go

INSERT INTO Source(source_name, source_file) values
('LopHocCsv', 'LopHoc.csv'),
('HocSinhCsv', 'HocSinh.csv'),
('MonHocCsv', 'MonHoc.csv'),
('DiemCsv', 'Diem.csv');
go

INSERT INTO Source(source_name, source_file) values
('Stage_LopHoc', 'QLLopHoc_Stage.Stage_LopHoc'),
(N'[Stage_Học_sinh]', N'QLLopHoc_Stage.[Stage_Học_sinh]'),
('Stage_MonHoc', 'QLLopHoc_Stage.Stage_MonHoc'),
('Stage_Diem', 'QLLopHoc_Stage.Stage_Diem');
go

INSERT INTO Status(status_name) values
('Unknown'),
('Success'),
('Failed'),
('In progress');
go

INSERT INTO Package(package_name, description) values
('ETL_Source_Stage', 'ETL Source to Stage'),
('ETL_Stage_NDS', 'ETL Stage to NDS');
go
--delete from data_flows;
INSERT INTO data_flows(data_flow_name, description, CET, LSET, status_id, source_id, package_id) values
('csv to Stage_LopHoc', '', '1753-01-01 00:00:00.000', '1753-01-01 00:00:00.000'	, 0, (select top 1 source_id from Source where source_name = 'LopHocCsv')	, (select top 1 package_id from Package where package_name = 'ETL_Source_Stage')),
(N'csv to Stage_Học_Sinh', '', '1753-01-01 00:00:00.000', '1753-01-01 00:00:00.000'	, 0, (select top 1 source_id from Source where source_name = 'HocSinhCsv')	, (select top 1 package_id from Package where package_name = 'ETL_Source_Stage')),
('csv to Stage_MonHoc', '', '1753-01-01 00:00:00.000', '1753-01-01 00:00:00.000'	, 0, (select top 1 source_id from Source where source_name = 'MonHocCsv')	, (select top 1 package_id from Package where package_name = 'ETL_Source_Stage')),
('csv to Stage_Diem', '', '1753-01-01 00:00:00.000', '1753-01-01 00:00:00.000'		, 0, (select top 1 source_id from Source where source_name = 'DiemCsv')		, (select top 1 package_id from Package where package_name = 'ETL_Source_Stage'));
go

INSERT INTO data_flows(data_flow_name, description, CET, LSET, status_id, source_id, package_id) values
('Stage_LopHoc to LopHoc_NDS', '', '1753-01-01 00:00:00.000', '1753-01-01 00:00:00.000'	, 0, (select top 1 source_id from Source where source_name = 'Stage_LopHoc')	, (select top 1 package_id from Package where package_name = 'ETL_Stage_NDS')),
(N'Stage_Học_Sinh to HocSinh_NDS', '', '1753-01-01 00:00:00.000', '1753-01-01 00:00:00.000'	, 0, (select top 1 source_id from Source where source_name = N'[Stage_Học_sinh]')	, (select top 1 package_id from Package where package_name = 'ETL_Stage_NDS')),
('Stage_MonHoc to MonHoc_NDS', '', '1753-01-01 00:00:00.000', '1753-01-01 00:00:00.000'	, 0, (select top 1 source_id from Source where source_name = 'Stage_MonHoc')	, (select top 1 package_id from Package where package_name = 'ETL_Stage_NDS')),
('Stage_Diem to Diem_NDS', '', '1753-01-01 00:00:00.000', '1753-01-01 00:00:00.000'		, 0, (select top 1 source_id from Source where source_name = 'Stage_Diem')		, (select top 1 package_id from Package where package_name = 'ETL_Stage_NDS'));
go

select * from Source;
select* from Status;
select * from Package;
select * from data_flows;

CREATE TABLE RuleType
(
    rule_type_id VARCHAR(5) PRIMARY KEY,
    rule_type_name VARCHAR(255)
);

CREATE TABLE RuleCategory
(
    rule_cat_id VARCHAR(5) PRIMARY KEY,
    rule_cat_name VARCHAR(255)
);

CREATE TABLE RuleRisk
(
    rule_risk_level INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    rule_risk_name VARCHAR(255)
);

CREATE TABLE RuleStatus
(
    rule_status_id varchar(5) PRIMARY KEY,
    rule_status VARCHAR(255)
);

CREATE TABLE RuleAction
(
    rule_action_id varchar(5) PRIMARY KEY,
    rule_action VARCHAR(255)
);

CREATE TABLE DQRules
(
    rule_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    rule_name VARCHAR(255),
    description VARCHAR(255),
    rule_type_id varchar(5) not null,
    rule_cat_id varchar(5) not null,
    rule_risk_level int,
    rule_status_id varchar(5),
    rule_action_id varchar(5),
    createdAt datetime,
    updatedAt datetime,

    CONSTRAINT FK_DQRules_RuleType
    FOREIGN KEY (rule_type_id) REFERENCES [RuleType](rule_type_id),

    CONSTRAINT FK_DQRules_RuleCategory
    FOREIGN KEY (rule_cat_id) REFERENCES [RuleCategory](rule_cat_id),

    CONSTRAINT FK_DQRules_RuleRisk
    FOREIGN KEY (rule_risk_level) REFERENCES [RuleRisk](rule_risk_level),

    CONSTRAINT FK_DQRules_RuleStatus
    FOREIGN KEY (rule_status_id) REFERENCES [RuleStatus](rule_status_id),

    CONSTRAINT FK_DQRules_RuleAction
    FOREIGN KEY (rule_action_id) REFERENCES [RuleAction](rule_action_id),
);

CREATE TABLE DWUsers
(
    user_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    user_name VARCHAR(100),
    department varchar(100),
    [role] varchar(100),
    email_address varchar(100),
    phone_number varchar(20),
    group_id int,
    is_active BIT DEFAULT 1,
    createdAt datetime,
    updatedAt datetime
);

CREATE TABLE DQNotification
(
    noti_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    rule_id INT NOT NULL,
    user_id INT NOT NULL,
    noti_type VARCHAR(50), -- e.g., "Email", "SMS", etc.
    is_active BIT DEFAULT 1, -- Indicates if the notification is currently active
    createdAt datetime,
    updatedAt datetime,

    CONSTRAINT FK_DQNotification_DQRules
    FOREIGN KEY (rule_id) REFERENCES DQRules(rule_id),

    CONSTRAINT FK_DQNotification_DWUsers
    FOREIGN KEY (user_id) REFERENCES DWUsers(user_id)
);

-- Insert data into RuleType
INSERT INTO RuleType (rule_type_id, rule_type_name)
VALUES 
('RT01', 'Referential Integrity'),
('RT02', 'Duplicate Data Check'),
('RT03', 'Range Check'),
('RT04', 'Null Value Check'),
('RT05', 'Aggregation Validation'),
('RT06', 'Consistency Check');

-- Insert data into RuleCategory
INSERT INTO RuleCategory (rule_cat_id, rule_cat_name)
VALUES
('RC01', 'Mapping Validation'),
('RC02', 'Data Completeness'),
('RC03', 'Range Validation'),
('RC04', 'Consistency Validation');

-- Insert data into RuleRisk
INSERT INTO RuleRisk (rule_risk_name)
VALUES 
('Low'),
('Medium'),
('High'),
('Critical'),
('Catastrophic');

-- Insert data into RuleStatus
INSERT INTO RuleStatus (rule_status_id, rule_status)
VALUES 
('A', 'Active'),
('D', 'Decommissioned');

-- Insert data into RuleAction
INSERT INTO RuleAction (rule_action_id, rule_action)
VALUES 
('R', 'Reject'),
('A', 'Allow'),
('F', 'Fix');

-- Insert data into DQRules
INSERT INTO DQRules (rule_name, description, rule_type_id, rule_cat_id, rule_risk_level, rule_status_id, rule_action_id, createdAt, updatedAt)
VALUES
-- Rule 1: Referential Integrity - Mapping Validation
('Validate Student-Class Mapping', 'Ensure malop in HocSinh exists in LopHoc.', 
 'RT01', 'RC01', 3, 'A', 'R', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- Rule 2: Duplicate Data Check - Data Completeness
('Check Duplicate Students', 'Ensure no duplicate MaHS in nHocSinh.', 
 'RT02', 'RC02', 4, 'A', 'F', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- Rule 3: Range Check - Range Validation
('Validate Score Range', 'Ensure Diem in Diem table is between 0 and 10.', 
 'RT03', 'RC03', 5, 'A', 'R', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- Rule 4: Null Value Check - Data Completeness
('Validate Non-Null Student Attributes', 'Ensure HoTen, NgaySinh, and GioiTinh in HocSinh are not null.', 
 'RT04', 'RC02', 4, 'A', 'R', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- Rule 5: Aggregation Validation - Consistency Validation
('Validate Class Size', 'Check if siso in LopHoc_NDS matches the number of students in the class.', 
 'RT05', 'RC04', 3, 'A', 'F', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- Rule 6: Consistency Check - Consistency Validation
('Check Course Credit Consistency', 'Ensure SoTC in MonHoc_NDS is consistent across records.', 
 'RT06', 'RC04', 2, 'A', 'F', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- Rule 7: Referential Integrity - Mapping Validation
('Validate Course-Student Mapping', 'Ensure MaMH in Diem exists in MonHoc.', 
 'RT01', 'RC01', 3, 'A', 'R', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- Rule 8: Null Value Check - Data Completeness
('Ensure Class Attributes are Not Null', 'Verify that attributes in LopHoc_NDS are non-null.', 
 'RT04', 'RC02', 4, 'A', 'R', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- Rule 9: Duplicate Data Check - Data Completeness
('Check Duplicate Classes', 'Ensure no duplicate MaLop in LopHoc.', 
 'RT02', 'RC02', 3, 'A', 'F', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- Rule 10: Range Check - Range Validation
('Validate Class Capacity', 'Ensure siso in LopHoc_NDS is between 10 and 50.', 
 'RT03', 'RC03', 5, 'A', 'R', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

 -- Rule 11: Range Check - Range Validation
('Validate format of MaHS', 'MaHS must be in "HS[0-9][0-9]" format.', 
 'RT03', 'RC03', 5, 'A', 'R', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert data into DWUsers
INSERT INTO DWUsers (user_name, department, [role], email_address, phone_number, group_id, is_active, createdAt, updatedAt)
VALUES
('John Smith', 'IT', 'Data Engineer', 'john.smith@example.com', '123-456-7890', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Jane Doe', 'Analytics', 'Analyst', 'jane.doe@example.com', '987-654-3210', 2, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Alice Johnson', 'Quality Assurance', 'QA Specialist', 'alice.johnson@example.com', '555-123-4567', 3, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert data into DQNotification
INSERT INTO DQNotification (rule_id, user_id, noti_type, is_active, createdAt, updatedAt)
VALUES
(1, 1, 'Email', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, 2, 'SMS', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(6, 3, 'Email', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);