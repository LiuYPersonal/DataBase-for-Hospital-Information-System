set serveroutput on
/* create global tempory tables for results */
create global temporary table patient_info
( patient_name varchar2(30),
  patient_type varchar2(10),
  g_admission_date date,
  s_admission_date date,
  pr_admission_date date,
  po_admission_date date,
  discharge_date date,
  scount number
);
create global temporary table surgery_interval
( start_date date,
  end_Date date,
  No_surgery number,
  name varchar2(30)
);
create global temporary table surgery_Date
(surgery_date date,
 surgeon varchar2(30)
);
create global temporary table surgeon_count
(name varchar2(30),
 s_count number);
create or replace procedure pro_verify
is
flag number;
begin
	flag:=Schedule_Verify();
	dbms_output.put_line(flag);
end;
/
/* Populate the tables and trigger triggers. */
exec DBMS_OUTPUT.PUT_LINE('populate Patient_chart')
@populate
/* Execute procedure to populate other tables */
exec DBMS_OUTPUT.PUT_LINE('populate Ward tables')
exec populate_db

/* Display populate results */
exec DBMS_OUTPUT.PUT_LINE('Display complete schedule for each patient')
select* from general_ward;
select* from screening_ward;
select* from pre_surgery_ward;
select* from post_surgery_ward;

exec DBMS_OUTPUT.PUT_LINE('Display Dr_schedule table')
exec populate_dr_schedule
select* from dr_schedule;

exec DBMS_OUTPUT.PUT_LINE('Display Surgeon schedule table')
exec populate_surgeon_schedule
select* from surgeon_schedule;
/* Execture procedures */
exec DBMS_OUTPUT.PUT_LINE('Verify the table')
exec pro_verify

/* Create a view */
exec DBMS_OUTPUT.PUT_LINE('Display Patient_surgery_view')
create table type_surgeon
( patient_type varchar2(10),
  surgeon varchar2(30)
);
insert into type_surgeon values('Cardiac','Dr.Charles');
insert into type_surgeon values('Cardiac','Dr.Gower');
insert into type_surgeon values('Neuro','Dr.Taylor');
insert into type_surgeon values('Neuro','Dr.Rutherford');
insert into type_surgeon values('General','Dr.Smith');
insert into type_surgeon values('General','Dr.Richards');
create view Patient_Surgery_view as
select p.patient_name,p.post_admission_date,s.name
from post_surgery_ward p, surgeon_schedule s,type_surgeon t
where p.post_admission_date=s.surgery_date and p.patient_type=t.patient_type and s.name=t.surgeon;
add
select p.patient_name,p.post_admission_date+2,s.name
from post_surgery_ward p, surgeon_schedule s,type_surgeon t
where p.scount=2 and p.post_admission_date=s.surgery_date and p.patient_type=t.patient_type and s.name=t.surgeon;
select* from patient_surgery_view;
drop view patient_surgery;
drop type_surgeon;

/* Execute procedures */
exec DBMS_OUTPUT.PUT_LINE('Query #1')
exec pro_1
exec DBMS_OUTPUT.PUT_LINE('Query #2')
exec pro_2
exec DBMS_OUTPUT.PUT_LINE('Query #3')
exec pro_3
exec DBMS_OUTPUT.PUT_LINE('Query #4')
exec pro_4
exec DBMS_OUTPUT.PUT_LINE('Query #5')
exec pro_5
exec DBMS_OUTPUT.PUT_LINE('Query #6')
exec pro_6
exec DBMS_OUTPUT.PUT_LINE('Query #7')
exec pro_7

drop pro_verify;
drop table patient_info;
drop table surgery_interval;
drop table surgery_date;
drop table surgeon_count;
