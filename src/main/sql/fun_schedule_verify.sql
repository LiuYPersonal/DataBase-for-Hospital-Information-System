delimiter //
create or replace function Schedule_Verify (OUT flag number)
begin
	declare s_date date;
	declare s_name sys_refcursor;
	declare s_name1 cursor for
		select name
			from surgeon_schedule
			where surgery_date=s_date and (name = 'Dr.Richards' or name='Dr.Gower' or name='Dr.Rutherford');
			select count(*) into type_name	/*at least one cardiac and neuro surgeon is on duty*/	
			from surgeon_schedule
			where surgery_date=s_date and name='Dr.Charles';
			if type_name is null then dbms_output.put_line('No Cardiac doctor on '||s_date); flag:=1; end if;
			select count(*) into type_name
			from surgeon_schedule
			where surgery_date=s_date and name='Dr.Taylor';
	declare s_name2 cursor for
		select name
			from surgeon_schedule
			where surgery_date=s_date and (name = 'Dr.Smith' or name='Dr.Charles' or name='Dr.Taylor');	
			select count(*) into type_name
			from surgeon_schedule
			where surgery_date=s_date and name='Dr.Gower';
			if type_name is null then dbms_output.put_line('No Cardiac doctor on '||s_date); flag:=1; end if;
			select count(*) into type_name
			from surgeon_schedule
			where surgery_date=s_date and name='Dr.Richards';
			
	declare diff number;
	declare schedule_date number;
	declare type_name varchar2(20);
	declare wrong_name varchar2(20);
	declare ward_count number;
	declare duty_count number;
	declare consecutive_count number;
	
	CREATE TEMPORARY TABLE array_dr (idx INT, name VARCHAR(20));
	INSERT INTO array_dr VALUES (1,'James'),(2,'Robert'),(3,'Mike'),(4,'Adams'),(5,'Tracey'),(6,'Rick');
	CREATE TEMPORARY TABLE array_ward (idx INT, ward VARCHAR(30));
	INSERT into array_ward values (1,'GENERAL_WARD'),(2,'SCREENING_WARD'),(3,'PRE_SURGERY_WARD'),(4,'POST_SURGERY_WARD'),(5,'Surgery');
	declare i number;
	declare j number;
	declare s_date:=to_date('01/01/05','MM/DD/YY');
	declare flag:=0;
	verify_sch: loop /*verifying surgeon_schedule table*/
		if extract(year from s_date)='2006' then
		leave verify_sch;
		end if;
		diff:=s_date-to_date('01/01/05','MM/DD/YY');
		schedule_date:=mod(diff,7);
		if schedule_date=1 or schedule_date=2 or schedule_date=5 then   /*if the surgeon work on the wrong day*/
			open s_name1;		
			if type_name is null then dbms_output.put_line('No Neuro doctor on '||s_date); flag:=1; end if;
			if s_name1%found then
				tmp:loop
					fetch s_name1 into wrong_name;
					if s_name1%notfound then
						leave tmp;
					end if;
				end loop tmp;
				flag:=1;
			end if;
			close s_name1;
		else
			open s_name2;			
			if type_name is null then dbms_output.put_line('No Neuro doctor on '||s_date); flag:=1; end if;	
			if s_name2%found then
				tmp: loop
					fetch s_name2 into wrong_name;
					if s_name2%notfound then
					leave tmp;
					end if;
				end loop tmp;
				flag:=1;
			end if;
		end if;
		s_date:=s_date+1;
	end loop verify_sch;
	s_date:=to_date('01/01/05','MM/DD/YY');	
	veryfy_dr:loop
		if extract(year from s_date)='2006' then /*each ward has exactly one junior on duty*/
		leave veryfy_dr;
		end if;
		
		select count(*) into ward_count from dr_schedule where ward='GENERAL_WARD' and Duty_date=s_date; 
		if ward_count !=1 then flag:=1; end if;
		select count(*) into ward_count from dr_schedule where ward='SCREENING_WARD' and Duty_date=s_date;
		if ward_count !=1 then flag:=1; end if;
		select count(*) into ward_count from dr_schedule where ward='PRE_SURGERY_WARD' and Duty_date=s_date;
		if ward_count !=1 then flag:=1; end if;
		select count(*) into ward_count from dr_schedule where ward='POST_SURGERY_WARD' and Duty_date=s_date;
		if ward_count !=1 then flag:=1; end if;

		diff:=s_date-to_date('01/01/05','MM/DD/YY'); /*each doctor works 6 days perweek*/
		schedule_date:=mod(diff,7);
		if schedule_date = 0 then 
			select count(*) into duty_count from dr_schedule where name='James' and Duty_date >=s_date and Duty_date<s_date+7;
			if duty_count!=6 then flag:=1; end if;
			select count(*) into duty_count from dr_schedule where name='Robert' and Duty_date >=s_date and Duty_date<s_date+7;
			if duty_count!=6 then flag:=1; end if;
			select count(*) into duty_count from dr_schedule where name='Mike' and Duty_date >=s_date and Duty_date<s_date+7;
			if duty_count!=6 then flag:=1; end if;
			select count(*) into duty_count from dr_schedule where name='Adams' and Duty_date >=s_date and Duty_date<s_date+7;
			if duty_count!=6 then flag:=1; end if;
			select count(*) into duty_count from dr_schedule where name='Tracey' and Duty_date >=s_date and Duty_date<s_date+7;
			if duty_count!=6 then flag:=1; end if;
			select count(*) into duty_count from dr_schedule where name='Rick' and Duty_date >=s_date and Duty_date<s_date+7;
			if duty_count!=6 then flag:=1; end if;
		end if;
		i:=1;
		j:=1;
		tmp1: loop  /*no doctor can work in the same ward for 3 consecutive days*/
			if i>6 then
				leave tmp1;
			end if;
			tmp2: loop
				if j>5 then
					leave tmp2;
				end if;			
				select count(*) into consecutive_count 
				from dr_schedule, array_dr, array_ward
				where name = array_dr.name and array_dr.idx=i
					  and ward=array_ward.ward and array_ward=j and Duty_date>=s_date and Duty_Date<s_date+3;
				if consecutive_count=3 then
					flag:=1;
				end if;
			j:=j+1;
			end loop tmp2;
			j:=1;
			i:=i+1;
		end loop tmp1;
		s_date:=s_date+1;
	end loop veryfy_dr;
	return flag;
end //
delimiter;