/*patient*/
drop table patient_chart;
drop table Patient_input;
drop table DR_Schedule;
drop table surgeon_schedule;
drop table general_ward;
drop table screening_ward;
drop table pre_surgery_ward;
drop table post_surgery_ward;

create table patient_chart
(
	Patient_Name varchar2(30),
	Pdate date,
	Temperature number,
	BP number,
	constraint pk_Patient primary key (Patient_Name,Pdate)
);
create table Patient_input
(
	Patient_Name varchar2(30),
	General_ward_admission_date date,
	Patient_Type varchar2(10),
	constraint pk_Input primary key (Patient_Name,General_ward_admission_date)
);
/*doctor*/
create table DR_Schedule
(
	Name varchar2(30),
	Ward varchar2(20),
	Duty_date date,
	constraint pk_DR primary key (Name,Duty_date)
);
create table surgeon_schedule
(
	Name varchar2(30),
	Surgery_Date date,
	constraint pk_Sur primary key (Name,Surgery_Date)
);

/*ward*/
create table general_ward
(
	Patient_Name varchar2(30),
	G_Admission_Date date,
	Patient_Type varchar2(10),
	constraint pk_Ge primary key (Patient_Name,G_Admission_Date)
);
create table screening_ward
(
	Patient_Name varchar2(30),
	S_Admission_Date date,
	Bed_No number,
	Patient_Type varchar2(10),
	constraint pk_screening primary key (Patient_Name,S_Admission_Date)
);
create table pre_surgery_ward
(
	Patient_Name varchar2(30),
	Pre_admission_Date date,
	Bed_No number,
	Patient_Type varchar2(10),
	constraint pk_Pre primary key (Patient_Name,Pre_admission_Date)
);
create table post_surgery_ward
(
	Patient_Name varchar2(30),
	Post_Admission_date date,
	Discharge_Date date,
	Scount number,
	Patient_type varchar2(10),
	constraint pk_Post primary key (Patient_Name,Post_Admission_date)
);
