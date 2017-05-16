delimiter //
create or replace procedure populate_dr_schedule()
begin
	declare s_date date;
	declare diff number;
	declare schedule_date number;
	declare s_date:=to_date('01/01/05','MM/DD/YY');
	populate_dr: loop
		if extract(year from s_date )='2006' then
		leave popupate_dr;
		end if;
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
	end loop populate_dr;
end //
DELIMITER;