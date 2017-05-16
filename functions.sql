/*fun5*/
create or replace function Schedule_Verify
return number
is
s_date date;
s_name sys_refcursor;
diff number;
schedule_date number;
flag number;
type_name varchar2(20);
wrong_name varchar2(20);
ward_count number;
duty_count number;
consecutive_count number;
type array is varray(6) of varchar2(20);
array_dr array:=array('James','Robert','Mike','Adams','Tracey','Rick');
type array2 is varray(5) of varchar2(30);
array_ward array2:=array2('GENERAL_WARD','SCREENING_WARD','PRE_SURGERY_WARD','POST_SURGERY_WARD','Surgery');
i number;
j number;
begin
	s_date:=to_date('01/01/05','MM/DD/YY');
	flag:=0;
	loop /*verifying surgeon_schedule table*/
		exit when extract(year from s_date)='2006';
		diff:=s_date-to_date('01/01/05','MM/DD/YY');
		schedule_date:=mod(diff,7);
		if schedule_date=1 or schedule_date=2 or schedule_date=5 then   /*if the surgeon work on the wrong day*/
			open s_name for			
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
			if type_name is null then dbms_output.put_line('No Neuro doctor on '||s_date); flag:=1; end if;
			if s_name%found then
				loop
					fetch s_name into wrong_name;
					exit when s_name%notfound;
					dbms_output.put_line(wrong_name);
				end loop;
				dbms_output.put_line('should not work on'||s_date);
				flag:=1;
			end if;
		else
			open s_name for			
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
			if type_name is null then dbms_output.put_line('No Neuro doctor on '||s_date); flag:=1; end if;	
			if s_name%found then
				loop
					fetch s_name into wrong_name;
					exit when s_name%notfound;
					dbms_output.put_line(wrong_name);
				end loop;
				dbms_output.put_line('should not work on'||s_date);
				flag:=1;
			end if;
		end if;
		s_date:=s_date+1;
	end loop;
	s_date:=to_date('01/01/05','MM/DD/YY');	
	loop
		exit when extract(year from s_date)='2006';/*each ward has exactly one junior on duty*/	
		select count(*) into ward_count from dr_schedule where ward='GENERAL_WARD' and Duty_date=s_date; 
		if ward_count !=1 then dbms_output.put_line(ward_count||'doctors work at genreral ward on'||s_date); flag:=1; end if;
		select count(*) into ward_count from dr_schedule where ward='SCREENING_WARD' and Duty_date=s_date;
		if ward_count !=1 then dbms_output.put_line(ward_count||'doctors work at screening ward on'||s_date); flag:=1; end if;
		select count(*) into ward_count from dr_schedule where ward='PRE_SURGERY_WARD' and Duty_date=s_date;
		if ward_count !=1 then dbms_output.put_line(ward_count||'doctors work at pre surgery ward on'||s_date); flag:=1; end if;
		select count(*) into ward_count from dr_schedule where ward='POST_SURGERY_WARD' and Duty_date=s_date;
		if ward_count !=1 then dbms_output.put_line(ward_count||'doctors work at post surgery ward on'||s_date); flag:=1; end if;

		diff:=s_date-to_date('01/01/05','MM/DD/YY'); /*each doctor works 6 days perweek*/
		schedule_date:=mod(diff,7);
		if schedule_date = 0 then 
			select count(*) into duty_count from dr_schedule where name='James' and Duty_date >=s_date and Duty_date<s_date+7;
			if duty_count!=6 then dbms_output.put_line('James works for'||duty_count||'days for the week starts from'||s_date);flag:=1; end if;
			select count(*) into duty_count from dr_schedule where name='Robert' and Duty_date >=s_date and Duty_date<s_date+7;
			if duty_count!=6 then dbms_output.put_line('Robert works for'||duty_count||'days for the week starts from'||s_date);flag:=1; end if;
			select count(*) into duty_count from dr_schedule where name='Mike' and Duty_date >=s_date and Duty_date<s_date+7;
			if duty_count!=6 then dbms_output.put_line('Mike works for'||duty_count||'days for the week starts from'||s_date);flag:=1; end if;
			select count(*) into duty_count from dr_schedule where name='Adams' and Duty_date >=s_date and Duty_date<s_date+7;
			if duty_count!=6 then dbms_output.put_line('Adams works for'||duty_count||'days for the week starts from'||s_date);flag:=1; end if;
			select count(*) into duty_count from dr_schedule where name='Tracey' and Duty_date >=s_date and Duty_date<s_date+7;
			if duty_count!=6 then dbms_output.put_line('Tracey works for'||duty_count||'days for the week starts from'||s_date);flag:=1; end if;
			select count(*) into duty_count from dr_schedule where name='Rick' and Duty_date >=s_date and Duty_date<s_date+7;
			if duty_count!=6 then dbms_output.put_line('Rick works for'||duty_count||'days for the week starts from'||s_date);flag:=1; end if;
		end if;
		for i in 1..6 loop  /*no doctor can work in the same ward for 3 consecutive days*/
			for j in 1..5 loop
				select count(*) into consecutive_count from dr_schedule 
				where name=array_dr(i) and ward=array_ward(j) and Duty_date>=s_date and Duty_Date<s_date+3;
				if consecutive_count=3 then
					dbms_output.put_line(array_dr(i)||'works at'||array_ward(j)||'for 3 consecutive days starts from'||s_date);
					flag:=1;
				end if;
			end loop;
		end loop;
		s_date:=s_date+1;
	end loop;
	if flag=0 then 
		dbms_output.put_line('No error in surgeon_schedule and dr_schedule');
	end if;
	return flag;
end;
/

/*fun6*/
create or replace function totalcost(patient_tp varchar2,g_date date,s_date date,pr_date date,po_date date,dis_date date,s_count number)
return number
is
diff_cost number;
total_cost number;
begin
		if g_date>=to_Date('1/1/05','MM/DD/YY') and dis_date<=to_Date('12/31/05','MM/DD/YY') then
			if pr_date is not null then
				if patient_tp='Cardiac' then
					total_cost:=0.8*50*3+0.70*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(pr_date-s_date-2)+0.95*90*2+0.75*3500+0.7*3500*(s_count-1)+0.9*80*(dis_date-po_date);
				elsif patient_tp='Neuro' then
					total_cost:=0.8*50*3+0.70*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(pr_date-s_date-2)+0.95*90*2+0.85*5000+0.8*5000*(s_count-1)+0.9*80*(dis_date-po_date);
				else 
					total_cost:=+0.8*50*3+0.70*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(pr_date-s_date-2)+0.95*90*2+0.65*2500+0.9*80*(dis_date-po_date);
				end if;
			else
				if patient_tp='Cardiac' then
					total_cost:=0.8*50*3+0.70*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(po_date-s_date-2)+0.75*3500+0.7*3500*(s_count-1)+0.9*80*(dis_date-po_date);
				elsif patient_tp='Neuro' then
					total_cost:=0.8*50*3+0.70*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(po_date-s_date-2)+0.85*5000+0.8*5000*(s_count-1)+0.9*80*(dis_date-po_date);
				else 
					total_cost:=0.8*50*3+0.70*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(po_date-s_date-2)+0.65*2500+0.9*80*(dis_date-po_date);
				end if;
			end if;
		elsif g_date<to_Date('1/1/05','MM/DD/YY') and dis_date>=to_Date('1/1/05','MM/DD/YY') then
			if pr_date is not null then
			if s_date<to_Date('1/1/05','MM/DD/YY') then
				if pr_Date<to_Date('1/1/05','MM/DD/YY') then
					if po_date<to_Date('1/1/05','MM/DD/YY') then
						if patient_tp='Cardiac' then
							if s_count=1 then
								total_cost:=0.75*3500+0.9*80*(dis_date-to_Date('1/1/05','MM/DD/YY'));
							else
								if to_Date('1/1/05','MM/DD/YY')-po_date =1 then
									total_cost:=0.75*3500+0.7*3500+0.9*80*(dis_date-to_Date('1/1/05','MM/DD/YY'));
								else
									total_cost:=0.7*3500+0.9*80*(dis_date-to_Date('1/1/05','MM/DD/YY'));
								end if;
							end if;
						elsif patient_tp='Neuro' then
							if s_count=1 then
								total_cost:=0.85*3500+0.9*80*(dis_date-to_Date('1/1/05','MM/DD/YY'));
							else
								if to_Date('1/1/05','MM/DD/YY')-po_date =1 then
									total_cost:=0.85*5000+0.8*5000+0.9*80*(dis_date-to_Date('1/1/05','MM/DD/YY'));
								else
									total_cost:=0.8*5000+0.9*80*(dis_date-to_Date('1/1/05','MM/DD/YY'));
								end if;
							end if;
						else
							total_cost:=0.65*2500+0.9*80*(dis_date-to_Date('1/1/05','MM/DD/YY'));
						end if;	
					else
						if patient_tp='Cardiac' then
							total_cost:=0.95*90*(po_date-to_Date('1/1/05','MM/DD/YY'))+0.75*3500+0.7*3500*(s_count-1)+0.9*80*(dis_date-po_date);
						elsif patient_tp='Neuro' then
							total_cost:=0.95*90*(po_date-to_Date('1/1/05','MM/DD/YY'))+0.85*5000+0.8*5000*(s_count-1)+0.9*80*(dis_date-po_date);
						else 
							total_cost:=0.95*90*(po_date-to_Date('1/1/05','MM/DD/YY'))+0.65*2500+0.9*80*(dis_date-po_date);
						end if;							
					end if;
				else
					if to_Date('1/1/05','MM/DD/YY')-s_date<2 then
						diff_cost:=0.85*70*(to_Date('1/1/05','MM/DD/YY')-s_date);
					else
						diff_cost:=0.85*70*(to_Date('1/1/05','MM/DD/YY')-s_date)+0.75*70*(to_Date('1/1/05','MM/DD/YY')-s_date-2);
					end if;
					if patient_tp='Cardiac' then
						total_cost:=0.85*70*2+0.75*70*(pr_date-s_date-2)+0.95*90*2+0.75*3500+0.7*3500*(s_count-1)+0.9*80*(dis_date-po_date)-diff_cost;
					elsif patient_tp='Neuro' then
						total_cost:=0.85*70*2+0.75*70*(pr_date-s_date-2)+0.95*90*2+0.85*5000+0.8*5000*(s_count-1)+0.9*80*(dis_date-po_date)-diff_cost;
					else 
						total_cost:=0.85*70*2+0.75*70*(pr_date-s_date-2)+0.95*90*2+0.65*2500+0.9*80*(dis_date-po_date)-diff_cost;
					end if;
				end if;
			else
				if to_Date('1/1/05','MM/DD/YY')-g_date<3 then
					diff_cost:=0.8*50*(to_Date('1/1/05','MM/DD/YY')-g_date);
				else
					diff_cost:=0.8*50*(to_Date('1/1/05','MM/DD/YY')-g_date)+0.7*50*(to_Date('1/1/05','MM/DD/YY')-g_date-3);
				end if;
				if patient_tp='Cardiac' then
					total_cost:=0.8*50*3+0.70*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(pr_date-s_date-2)+0.95*90*2+0.75*3500+0.7*3500*(s_count-1)+0.9*80*(dis_date-po_date)-diff_cost;
				elsif patient_tp='Neuro' then
					total_cost:=0.8*50*3+0.70*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(pr_date-s_date-2)+0.95*90*2+0.85*5000+0.8*5000*(s_count-1)+0.9*80*(dis_date-po_date)-diff_cost;
				else 
					total_cost:=0.8*50*3+0.70*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(pr_date-s_date-2)+0.95*90*2+0.65*2500+0.9*80*(dis_date-po_date)-diff_cost;
				end if;
			end if;
			else
			if s_date<to_Date('1/1/05','MM/DD/YY') then
					if po_date<to_Date('1/1/05','MM/DD/YY') then
						if patient_tp='Cardiac' then
							if s_count=1 then
								total_cost:=0.75*3500+0.9*80*(dis_date-to_Date('1/1/05','MM/DD/YY'));
							else
								if to_Date('1/1/05','MM/DD/YY')-po_date =1 then
									total_cost:=0.75*3500+0.7*3500+0.9*80*(dis_date-to_Date('1/1/05','MM/DD/YY'));
								else
									total_cost:=0.7*3500+0.9*80*(dis_date-to_Date('1/1/05','MM/DD/YY'));
								end if;
							end if;
						elsif patient_tp='Neuro' then
							if s_count=1 then
								total_cost:=0.85*3500+0.9*80*(dis_date-to_Date('1/1/05','MM/DD/YY'));
							else
								if to_Date('1/1/05','MM/DD/YY')-po_date =1 then
									total_cost:=0.85*5000+0.8*5000+0.9*80*(dis_date-to_Date('1/1/05','MM/DD/YY'));
								else
									total_cost:=0.8*5000+0.9*80*(dis_date-to_Date('1/1/05','MM/DD/YY'));
								end if;
							end if;
						else
							total_cost:=0.65*2500+0.9*80*(dis_date-to_Date('1/1/05','MM/DD/YY'));
						end if;	
					else
						diff_cost:=0.95*90*(to_Date('1/1/05','MM/DD/YY')-po_date);
						if patient_tp='Cardiac' then
							total_cost:=0.75*3500+0.7*3500*(s_count-1)+0.9*80*(dis_date-po_date)-diff_cost;
						elsif patient_tp='Neuro' then
							total_cost:=0.85*5000+0.8*5000*(s_count-1)+0.9*80*(dis_date-po_date)-diff_cost;
						else 
							total_cost:=0.65*2500+0.9*80*(dis_date-po_date)-diff_cost;
						end if;							
					end if;
			else
				if to_Date('1/1/05','MM/DD/YY')-g_date<3 then
					diff_cost:=0.8*50*(to_Date('1/1/05','MM/DD/YY')-g_date);
				else
					diff_cost:=0.8*50*(to_Date('1/1/05','MM/DD/YY')-g_date)+0.7*50*(to_Date('1/1/05','MM/DD/YY')-g_date-3);
				end if;
				if patient_tp='Cardiac' then
					total_cost:=0.8*50*3+0.70*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(po_date-s_date-2)+0.75*3500+0.7*3500*(s_count-1)+0.9*80*(dis_date-po_date)-diff_cost;
				elsif patient_tp='Neuro' then
					total_cost:=0.8*50*3+0.70*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(po_date-s_date-2)+0.85*5000+0.8*5000*(s_count-1)+0.9*80*(dis_date-po_date)-diff_cost;
				else 
					total_cost:=0.8*50*3+0.70*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(po_date-s_date-2)+0.65*2500+0.9*80*(dis_date-po_date)-diff_cost;
				end if;
			end if;
			end if;
		elsif g_date<=to_Date('12/31/05','MM/DD/YY') and dis_date>to_Date('12/31/05','MM/DD/YY') then
			if patient_tp is not null then
			if po_date>to_Date('12/31/05','MM/DD/YY') then
				if pr_Date>to_Date('12/31/05','MM/DD/YY') then
					if s_date>to_Date('12/31/05','MM/DD/YY') then
						if to_date('1/1/06','MM/DD/YY')-g_date<3 then
							total_cost:=0.8*50*(to_date('1/1/06','MM/DD/YY')-g_date);
						else
							total_cost:=0.8*50*(to_date('1/1/06','MM/DD/YY')-g_date)+0.7*50*(to_date('1/1/06','MM/DD/YY')-g_date-3);
						end if;
					else
						if to_date('1/1/05','MM/DD/YY')-s_date<2 then
							total_cost:=0.8*50*(s_date-g_date)+0.7*50*(s_date-g_date-3)+0.85*70*(to_date('1/1/06','MM/DD/YY')-s_date);
						else
							total_cost:=0.8*50*(s_date-g_date)+0.7*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(to_date('1/1/06','MM/DD/YY')-s_date-2);
						end if;							
					end if;
				else
					total_cost:=0.8*50*(s_date-g_date)+0.7*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(pr_date-s_date-2)+0.95*90*(to_date('1/1/06','MM/DD/YY')-pr_date);
				end if;
			else
				if to_date('1/1/06','MM/DD/YY')-po_Date<=2 then
					if patient_tp='Cardiac' then
						total_cost:=0.8*50*3+0.70*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(pr_date-s_date-2)+0.95*90*2+0.75*3500+0.9*80*(to_date('1/1/06','MM/DD/YY')-po_date);
					elsif patient_tp='Neuro' then
						total_cost:=0.8*50*3+0.70*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(pr_date-s_date-2)+0.95*90*2+0.85*5000+0.9*80*(to_date('1/1/06','MM/DD/YY')-po_date);
					else 
						total_cost:=0.8*50*3+0.70*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(pr_date-s_date-2)+0.95*90*2+0.65*2500+0.9*80*(to_date('1/1/06','MM/DD/YY')-po_date);
					end if;
				else
					if patient_tp='Cardiac' then
						total_cost:=0.8*50*3+0.70*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(pr_date-s_date-2)+0.95*90*2+0.75*3500+0.7*3500*(s_count-1)+0.9*80*(to_date('1/1/06','MM/DD/YY')-po_date);
					elsif patient_tp='Neuro' then
						total_cost:=0.8*50*3+0.70*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(pr_date-s_date-2)+0.95*90*2+0.85*5000+0.8*5000*(s_count-1)+0.9*80*(to_date('1/1/06','MM/DD/YY')-po_date);
					else 
						total_cost:=0.8*50*3+0.70*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(pr_date-s_date-2)+0.95*90*2+0.65*2500+0.9*80*(to_date('1/1/06','MM/DD/YY')-po_date);
					end if;
				end if;
			end if;
			else
			if po_date>to_Date('12/31/05','MM/DD/YY') then
				if s_date>to_Date('12/31/05','MM/DD/YY') then
					if to_date('12/31/05','MM/DD/YY')-g_date<3 then
						total_cost:=0.8*50*(to_date('1/1/06','MM/DD/YY')-g_date);
					else
						total_cost:=0.8*50*(to_date('1/1/06','MM/DD/YY')-g_date)+0.7*50*(to_date('1/1/06','MM/DD/YY')-g_date-3);
					end if;
				else
					if to_date('1/1/06','MM/DD/YY')-s_date<2 then
						total_cost:=0.8*50*(to_date('1/1/06','MM/DD/YY')-g_date)+0.7*50*(s_date-g_date-3)+0.85*70*(to_date('1/1/06','MM/DD/YY')-s_date);
					else
						total_cost:=0.8*50*(to_date('1/1/06','MM/DD/YY')-g_date)+0.7*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(to_date('1/1/06','MM/DD/YY')-s_date-2);
					end if;							
				end if;
			else
				if to_date('1/1/06','MM/DD/YY')-po_Date<=2 then
					if patient_tp='Cardiac' then
						total_cost:=0.8*50*3+0.70*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(po_date-s_date-2)+0.75*3500+0.9*80*(to_date('1/1/06','MM/DD/YY')-po_date);
					elsif patient_tp='Neuro' then
						total_cost:=0.8*50*3+0.70*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(po_date-s_date-2)+0.85*5000+0.9*80*(to_date('1/1/06','MM/DD/YY')-po_date);
					else 
						total_cost:=0.8*50*3+0.70*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(po_date-s_date-2)+0.65*2500+0.9*80*(to_date('1/1/06','MM/DD/YY')-po_date);
					end if;
				else
					if patient_tp='Cardiac' then
						total_cost:=0.8*50*3+0.70*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(po_date-s_date-2)+0.75*3500+0.7*3500*(s_count-1)+0.9*80*(to_date('1/1/06','MM/DD/YY')-po_date);
					elsif patient_tp='Neuro' then
						total_cost:=0.8*50*3+0.70*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(po_date-s_date-2)+0.85*5000+0.8*5000*(s_count-1)+0.9*80*(to_date('1/1/06','MM/DD/YY')-po_date);
					else 
						total_cost:=0.8*50*3+0.70*50*(s_date-g_date-3)+0.85*70*2+0.75*70*(po_date-s_date-2)+0.65*2500+0.9*80*(to_date('1/1/06','MM/DD/YY')-po_date);
					end if;
				end if;
			end if;
			end if;
		end if;
	return total_cost;
end;
/
