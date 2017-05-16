/*pro2*/
create or replace procedure populate_db
is
p_nm varchar2(30);
g_date date;
p_tp varchar2(10);
cursor input_cursor
is
	select* from patient_input
	order by general_ward_admission_date,patient_name;
begin
	open input_cursor;
	loop
		fetch input_cursor into p_nm,g_date,p_tp;
		exit when input_cursor%notfound;
		insert into general_ward values(p_nm,g_date,p_tp);
	end loop;
	close input_cursor;
end;
/
/*pro3*/
create or replace procedure populate_dr_schedule
is
s_date date;
diff number;
schedule_date number;
begin
	s_date:=to_date('01/01/05','MM/DD/YY');
	loop
		exit when extract(year from s_date)='2006';
		diff:=s_date-to_date('01/01/05','MM/DD/YY');
		schedule_date:=mod(diff,7);
		if schedule_date=0 then
			insert into dr_schedule values('James','GENERAL_WARD',s_date);
			insert into dr_schedule values('Robert','SCREENING_WARD',s_date);
			insert into dr_schedule values('Mike','PRE_SURGERY_WARD',s_date);
			insert into dr_schedule values('Adams','POST_SURGERY_WARD',s_date);
			insert into dr_schedule values('Tracey','Surgery',s_date);
		elsif schedule_date=1 then
			insert into dr_schedule values('James','GENERAL_WARD',s_date);
			insert into dr_schedule values('Robert','SCREENING_WARD',s_date);
			insert into dr_schedule values('Mike','PRE_SURGERY_WARD',s_date);
			insert into dr_schedule values('Adams','POST_SURGERY_WARD',s_date);
			insert into dr_schedule values('Tracey','Surgery',s_date);
			insert into dr_schedule values('Rick','Surgery',s_date);
		elsif schedule_date=2 then		
			insert into dr_schedule values('Robert','GENERAL_WARD',s_date);
			insert into dr_schedule values('Mike','SCREENING_WARD',s_date);
			insert into dr_schedule values('Adams','PRE_SURGERY_WARD',s_date);
			insert into dr_schedule values('Tracey','POST_SURGERY_WARD',s_date);
			insert into dr_schedule values('Rick','Surgery',s_date);
		elsif schedule_date=3 then
			insert into dr_schedule values('Mike','GENERAL_WARD',s_date);
			insert into dr_schedule values('Adams','SCREENING_WARD',s_date);
			insert into dr_schedule values('Tracey','PRE_SURGERY_WARD',s_date);
			insert into dr_schedule values('Rick','POST_SURGERY_WARD',s_date);
			insert into dr_schedule values('James','Surgery',s_date);
		elsif schedule_date=4 then
			insert into dr_schedule values('Adams','GENERAL_WARD',s_date);
			insert into dr_schedule values('Tracey','SCREENING_WARD',s_date);
			insert into dr_schedule values('Rick','PRE_SURGERY_WARD',s_date);
			insert into dr_schedule values('James','POST_SURGERY_WARD',s_date);
			insert into dr_schedule values('Robert','Surgery',s_date);
		elsif schedule_date=5 then
			insert into dr_schedule values('Tracey','GENERAL_WARD',s_date);
			insert into dr_schedule values('Rick','SCREENING_WARD',s_date);
			insert into dr_schedule values('James','PRE_SURGERY_WARD',s_date);
			insert into dr_schedule values('Robert','POST_SURGERY_WARD',s_date);
			insert into dr_schedule values('Mike','Surgery',s_date);
		else
			insert into dr_schedule values('Rick','SCREENING_WARD',s_date);
			insert into dr_schedule values('James','PRE_SURGERY_WARD',s_date);
			insert into dr_schedule values('Robert','POST_SURGERY_WARD',s_date);
			insert into dr_schedule values('Mike','Surgery',s_date);
			insert into dr_schedule values('Adams','GENERAL_WARD',s_date);
		end if;
		s_date:=s_date+1;
	end loop;
end;
/
/*pro4*/
create or replace procedure populate_surgeon_schedule
is
s_date date;
diff number;
week_diff number;
begin
	s_date:=to_date('01/01/05','MM/DD/YY');
	loop
		exit when extract(year from s_date)='2006';
		diff:=s_date-to_date('01/01/05','MM/DD/YY');
		week_diff:=mod(diff,7);
		if week_diff =1 or week_diff =2 or week_diff= 5 then
			insert into surgeon_schedule values('Dr.Smith',s_date);
			insert into surgeon_schedule values('Dr.Charles',s_date);
			insert into surgeon_schedule values('Dr.Taylor',s_date);
		else
			insert into surgeon_schedule values('Dr.Richards',s_date);
			insert into surgeon_schedule values('Dr.Gower',s_date);
			insert into surgeon_schedule values('Dr.Rutherford',s_date);
		end if;
	s_date:=s_date+1;
	end loop;
end;	
/
