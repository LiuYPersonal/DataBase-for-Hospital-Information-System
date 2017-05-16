/*1*/
create or replace procedure pro_1
is
patient_nm varchar2(30);
patient_tp varchar2(10);
patient_count number;
g_patient_nm varchar2(30);
s_patient_nm varchar2(30);
pr_patient_nm varchar2(30);
po_patient_nm varchar2(30);
g_patient_tp varchar2(10);
s_patient_tp varchar2(10);
pr_patient_tp varchar2(10);
po_patient_tp varchar2(10);
s_count number;
g_date date;
s_date date;
pr_date date;
po_date date;
dis_date date;
patient_cursor sys_refcursor;
details_cursor sys_refcursor;
diff_cost number;
visit_length number;
total_cost number;
avg_stay number;
cursor g_cursor
is
select patient_name,patient_type,g_admission_Date from general_Ward;
cursor s_cursor
is 
select patient_name,patient_type,s_admission_Date from screening_Ward;
cursor pr_cursor
is
select patient_name,patient_type,pre_admission_Date from pre_surgery_WArd;
cursor po_cursor
is
select patient_name,patient_type,post_admission_Date,discharge_Date,scount from post_surgery_Ward;
begin
	dbms_output.put_line('name'||'     '||'No_of_visits'||'    '||'avg_stay'||'    '||'total_costs');
	open g_cursor;
	open s_cursor;
	open po_cursor;
	open pr_cursor;
	fetch g_cursor into g_patient_nm,g_patient_tp,g_date;
	fetch s_cursor into s_patient_nm,s_patient_tp,s_date;
	fetch pr_cursor into pr_patient_nm,pr_patient_tp,pr_date;
	fetch po_cursor into po_patient_nm,po_patient_tp,po_date,dis_date,s_count;
	loop
		exit when g_cursor%notfound;
		if g_patient_nm=s_patient_nm and s_patient_nm=po_patient_nm and g_patient_tp=s_patient_tp and g_patient_tp=po_patient_tp then
			if (g_date>=to_Date('1/1/05','MM/DD/YY') and g_date<=to_Date('12/31/05','MM/DD/YY'))or (dis_date>=to_Date('1/1/05','MM/DD/YY') and dis_date<=to_Date('12/31/05','MM/DD/YY')) or (g_date<=to_Date('1/1/05','MM/DD/YY') and dis_date>=to_Date('12/31/05','MM/DD/YY')) then		
				if g_patient_nm=pr_patient_nm and g_patient_tp=pr_patient_tp then
					insert into patient_info values(g_patient_nm,g_patient_tp,g_date,s_date,pr_Date,po_date,dis_date,s_count);
				else
					insert into patient_info values(g_patient_nm,g_patient_tp,g_date,s_date,null,po_Date,dis_date,s_count);
				end if;
			end if;	
			if g_patient_nm=pr_patient_nm and g_patient_tp=pr_patient_tp then
				fetch pr_cursor into pr_patient_nm,pr_patient_tp,pr_date;
			end if;	
			fetch g_cursor into g_patient_nm,g_patient_tp,g_date;
			fetch s_cursor into s_patient_nm,s_patient_tp,s_date;
			fetch po_cursor into po_patient_nm,po_patient_tp,po_date,dis_date,s_count;
		else
			exit;
		end if;
	end loop;
	open patient_cursor for
	select patient_name,count(*) from patient_info group by patient_name;
	loop
		fetch patient_cursor into patient_nm,patient_count;
		exit when patient_cursor%notfound;
		open details_cursor for 
		select patient_type,g_admission_date,s_admission_date,pr_admission_Date,po_admission_date,discharge_Date,scount from patient_info where patient_name=patient_nm;
		visit_length:=0; total_cost:=0;		
		for i in 1..patient_count loop
			fetch details_cursor into patient_tp,g_date,s_date,pr_date,po_date,dis_date,s_count;
				if g_date>=to_Date('1/1/05','MM/DD/YY') and dis_date<=to_Date('12/31/05','MM/DD/YY') then
					visit_length:=visit_length+dis_date-g_date;
				elsif g_date<to_Date('1/1/05','MM/DD/YY') and dis_date>=to_Date('1/1/05','MM/DD/YY') then
					visit_length:=visit_length+dis_date-to_date('1/1/05','MM/DD/YY');
				elsif g_date<=to_Date('12/31/05','MM/DD/YY') and dis_date>to_Date('12/31/05','MM/DD/YY') then
					visit_length:=visit_length+to_date('1/1/06','MM/DD/YY')-g_date;
				end if;
				total_cost:=total_cost+totalcost(patient_tp,g_date,s_date,pr_date,po_date,dis_date,s_count);
		end loop;
	avg_stay:=visit_length/patient_count;
	dbms_output.put_line(patient_nm||'         '||patient_count||'          '||avg_stay||'     '||total_cost);
	end loop;
	close g_cursor;
	close s_cursor;
	close po_cursor;
	close pr_cursor;
	commit;
end;
/
/*2*/
create or replace procedure pro_2
is
patient_count number;
patient_tp varchar2(10);
visit_count number;
total_cost number;
diff_cost number;
cost_patient number;
cost_visit number;
g_patient_nm varchar2(30);
s_patient_nm varchar2(30);
pr_patient_nm varchar2(30);
po_patient_nm varchar2(30);
g_patient_tp varchar2(10);
s_patient_tp varchar2(10);
pr_patient_tp varchar2(10);
po_patient_tp varchar2(10);
s_count number;
g_date date;
s_date date;
pr_date date;
po_date date;
dis_date date;
patient_cursor sys_refcursor;
cursor g_cursor
is
select patient_name,patient_type,g_admission_Date from general_Ward;
cursor s_cursor
is 
select patient_name,patient_type,s_admission_Date from screening_Ward;
cursor pr_cursor
is
select patient_name,patient_type,pre_admission_Date from pre_surgery_WArd;
cursor po_cursor
is
select patient_name,patient_type,post_admission_Date,discharge_Date,scount from post_surgery_Ward;
begin
	open g_cursor;
	open s_cursor;
	open po_cursor;
	open pr_cursor;
	fetch g_cursor into g_patient_nm,g_patient_tp,g_date;
	fetch s_cursor into s_patient_nm,s_patient_tp,s_date;
	fetch po_cursor into po_patient_nm,po_patient_tp,po_date,dis_date,s_count;
	fetch pr_cursor into pr_patient_nm,pr_patient_tp,pr_date;
	loop
		exit when g_cursor%notfound;
		if g_patient_nm=s_patient_nm and s_patient_nm=po_patient_nm and g_patient_tp=s_patient_tp and g_patient_tp=po_patient_tp then
			if (g_date>=to_Date('1/1/05','MM/DD/YY') and g_date<=to_Date('12/31/05','MM/DD/YY'))or (dis_date>=to_Date('1/1/05','MM/DD/YY') and dis_date<=to_Date('12/31/05','MM/DD/YY')) or (g_date<=to_Date('1/1/05','MM/DD/YY') and dis_date>=to_Date('12/31/05','MM/DD/YY')) then		
				if g_patient_nm=pr_patient_nm and g_patient_tp=pr_patient_tp then
					insert into patient_info values(g_patient_nm,g_patient_tp,g_date,s_date,pr_Date,po_date,dis_date,s_count);
				else
					insert into patient_info values(g_patient_nm,g_patient_tp,g_date,s_date,null,po_Date,dis_date,s_count);
				end if;
			end if;	
			if g_patient_nm=pr_patient_nm and g_patient_tp=pr_patient_tp then
				fetch pr_cursor into pr_patient_nm,pr_patient_tp,pr_date;
			end if;	
			fetch g_cursor into g_patient_nm,g_patient_tp,g_date;
			fetch s_cursor into s_patient_nm,s_patient_tp,s_date;
			fetch po_cursor into po_patient_nm,po_patient_tp,po_date,dis_date,s_count;
		else
			exit;
		end if;
	end loop;
	select count(*) into visit_count from patient_info;
	select count(*) into patient_count from (select patient_name from patient_info group by patient_name);
	open patient_cursor for
	select patient_type,g_admission_date,s_admission_date,pr_admission_Date,po_admission_date,discharge_Date,scount from patient_info;
	total_cost:=0;
	loop
		fetch patient_cursor into patient_tp,g_date,s_date,pr_date,po_date,dis_date,s_count;
		exit when patient_cursor%notfound;
		total_cost:=total_cost+totalcost(patient_tp,g_date,s_date,pr_date,po_date,dis_date,s_count);
	end loop;
	cost_patient:=total_cost/patient_count;
	cost_visit:=total_cost/visit_count;
	dbms_output.put_line('Total cost '||'    '||'cost per patient'||'      '||'cost per visit');
	dbms_output.put_line(total_cost||'           '||cost_patient||'          '||cost_visit);
	close patient_cursor;
	close g_cursor;
	close s_cursor;
	close po_cursor;
	close pr_cursor;
	commit;
end; 
/

/*3*/
create or replace procedure pro_3
is
patient_nm varchar2(30);
patient_count number;
patient_tp varchar2(10);
visit_length number;
avg_stay number;
g_patient_nm varchar2(30);
s_patient_nm varchar2(30);
pr_patient_nm varchar2(30);
po_patient_nm varchar2(30);
g_patient_tp varchar2(10);
s_patient_tp varchar2(10);
pr_patient_tp varchar2(10);
po_patient_tp varchar2(10);
s_count number;
g_date date;
s_date date;
pr_date date;
po_date date;
dis_date date;
g_date_d date;
dis_date_d date;
patient_cursor sys_refcursor;
details_cursor sys_refcursor;
bob_cursor sys_refcursor;
cursor g_cursor
is
select patient_name,patient_type,g_admission_Date from general_Ward;
cursor s_cursor
is 
select patient_name,patient_type,s_admission_Date from screening_Ward;
cursor pr_cursor
is
select patient_name,patient_type,pre_admission_Date from pre_surgery_WArd;
cursor po_cursor
is
select patient_name,patient_type,post_admission_Date,discharge_Date,scount from post_surgery_Ward;
begin
	open g_cursor;
	open s_cursor;
	open po_cursor;
	open pr_cursor;
	fetch g_cursor into g_patient_nm,g_patient_tp,g_date;
	fetch s_cursor into s_patient_nm,s_patient_tp,s_date;
	fetch po_cursor into po_patient_nm,po_patient_tp,po_date,dis_date,s_count;
	fetch pr_cursor into pr_patient_nm,pr_patient_tp,pr_date;
	loop
		exit when g_cursor%notfound;
		if g_patient_nm=s_patient_nm and s_patient_nm=po_patient_nm and g_patient_tp=s_patient_tp and g_patient_tp=po_patient_tp then
			if (g_date>=to_Date('1/1/05','MM/DD/YY') and g_date<=to_Date('12/31/05','MM/DD/YY'))or (dis_date>=to_Date('1/1/05','MM/DD/YY') and dis_date<=to_Date('12/31/05','MM/DD/YY')) or (g_date<=to_Date('1/1/05','MM/DD/YY') and dis_date>=to_Date('12/31/05','MM/DD/YY')) then		
				if g_patient_nm=pr_patient_nm and g_patient_tp=pr_patient_tp then
					insert into patient_info values(g_patient_nm,g_patient_tp,g_date,s_date,pr_Date,po_date,dis_date,s_count);
				else
					insert into patient_info values(g_patient_nm,g_patient_tp,g_date,s_date,null,po_Date,dis_date,s_count);
				end if;
			end if;	
			if g_patient_nm=pr_patient_nm and g_patient_tp=pr_patient_tp then
				fetch pr_cursor into pr_patient_nm,pr_patient_tp,pr_date;
			end if;	
			fetch g_cursor into g_patient_nm,g_patient_tp,g_date;
			fetch s_cursor into s_patient_nm,s_patient_tp,s_date;
			fetch po_cursor into po_patient_nm,po_patient_tp,po_date,dis_date,s_count;
		else
			exit;
		end if;
	end loop;
	open bob_cursor for
	select g_admission_date,discharge_date from patient_info where patient_name='Bob';
	for i in 1..2 loop
		fetch bob_cursor into g_date,dis_date;
	end loop;
	dbms_output.put_line('Bob'||'     '||g_date);
	dbms_output.put_line('Patient name'||'     '||'Average_stay');
	open patient_cursor for
		select patient_name,count(*) from patient_info where g_admission_date=g_date and discharge_date<=dis_date and patient_name<>'Bob' group by patient_name;
	loop
		fetch patient_cursor into patient_nm,patient_count;
		exit when patient_cursor%notfound;
		open details_cursor for
		select g_admission_date,discharge_date from patient_info where patient_name=patient_nm and g_admission_date=g_date and discharge_date<=dis_date;
		visit_length:=0;
		loop
			fetch details_cursor into g_date_d,dis_date_d;
			exit when details_cursor%notfound;
			visit_length:=visit_length+dis_date_d-g_date_d;
		end loop;
		avg_stay:=visit_length/patient_count;
		dbms_output.put_line(patient_nm||'     '||avg_stay);
	end loop;
	commit;
end;
/
/*4*/
create or replace procedure pro_4
is
startdate date;
enddate date;
surgery_count number;
surgery_name varchar2(30);
surgery_nm varchar2(30);
patient_tp varchar2(10);
po_date date;
dis_date date;
date_tmp date;
s_count number;
date_cursor sys_refcursor;
result_cursor sys_refcursor;
surgeon_cursor sys_refcursor;
cursor patient_cursor
is
select post_admission_date,discharge_date,scount,patient_type from post_surgery_Ward where (post_admission_date>=to_date('1/1/05','MM/DD/YY') and post_admission_date<to_date('1/1/06','MM/DD/YY')) or (post_admission_date<to_date('1/1/05','MM/DD/YY') and discharge_date>=to_date('1/3/05','MM/DD/YY'));
begin
	open patient_cursor;
	loop
		fetch patient_cursor into po_date,dis_date,s_count,patient_tp;
		exit when patient_cursor%notfound;
		if po_date<to_date('1/1/05','MM/DD/YY') then
			if patient_tp='General' then
				select name into surgery_name from surgeon_schedule where surgery_Date=dis_date-2 and (name='Dr.Smith' or name='Dr.Richards');
			elsif patient_tp='Cardiac' then
				select name into surgery_name from surgeon_schedule where surgery_Date=dis_date-2 and (name='Dr.Charles' or name='Dr.Gower');
			else
				select name into surgery_name from surgeon_schedule where surgery_Date=dis_date-2 and (name='Dr.Taylor' or name='Dr.Rutherford');
			end if;
			insert into surgery_date values(dis_date-2,surgery_name);
		else 
			if patient_tp='General' then
				select name into surgery_name from surgeon_schedule where surgery_Date=po_date and (name='Dr.Smith' or name='Dr.Richards');
			elsif patient_tp='Cardiac' then
				select name into surgery_name from surgeon_schedule where surgery_Date=po_date and (name='Dr.Charles' or name='Dr.Gower');
			else
				select name into surgery_name from surgeon_schedule where surgery_Date=po_date and (name='Dr.Taylor' or name='Dr.Rutherford');
			end if;
			insert into surgery_date values(po_date,surgery_name);
			if s_count=2 then 
				if po_date+2<=to_date('12/31/05','MM/DD/YY') then
					if patient_tp='General' then
						select name into surgery_name from surgeon_schedule where surgery_Date=po_date+2 and (name='Dr.Smith' or name='Dr.Richards');
					elsif patient_tp='Cardiac' then
						select name into surgery_name from surgeon_schedule where surgery_Date=po_date+2 and (name='Dr.Charles' or name='Dr.Gower');
					else
						select name into surgery_name from surgeon_schedule where surgery_Date=po_date+2 and (name='Dr.Taylor' or name='Dr.Rutherford');
					end if;
					insert into surgery_date values(po_date+2,surgery_name);
				end if;
			end if;
		end if;
	end loop;
	close patient_cursor;
	open date_cursor for
	select* from surgery_date order by surgery_date asc;
	fetch date_cursor into startdate,surgery_name;
	enddate:=startdate;
	date_tmp:=startdate;
	insert into surgeon_count values('Dr.Smith',0);
	insert into surgeon_count values('Dr.Charles',0);
	insert into surgeon_count values('Dr.Richards',0);
	insert into surgeon_count values('Dr.Gower',0);
	insert into surgeon_count values('Dr.Taylor',0);
	insert into surgeon_count values('Dr.Rutherford',0);
	if surgery_name='Dr.Smith' then 
		update surgeon_count  set s_count=s_count+1 where name='Dr.Smith';
	elsif surgery_name='Dr.Charles' then
		update surgeon_count set s_count=s_count+1 where name='Dr.Charles';
	elsif surgery_name='Dr.Richards' then
		update surgeon_count set s_count=s_count+1 where name='Dr.Richards';
	elsif surgery_name='Dr.Gower' then
		update surgeon_count set s_count=s_count+1 where name='Dr.Gower';
	elsif surgery_name='Dr.Taylor' then
		update surgeon_count set s_count=s_count+1 where name='Dr.Taylor';
	else
		update surgeon_count set s_count=s_count+1 where name='Dr.Rutherford';
	end if;
	loop
		fetch date_cursor into date_tmp,surgery_name;
		exit when date_cursor%notfound;
		if date_tmp=enddate then 
			if surgery_name='Dr.Smith' then 
				update surgeon_count  set s_count=s_count+1 where name='Dr.Smith';
			elsif surgery_name='Dr.Charles' then
				update surgeon_count set s_count=s_count+1 where name='Dr.Charles';
			elsif surgery_name='Dr.Richards' then
				update surgeon_count set s_count=s_count+1 where name='Dr.Richards';
			elsif surgery_name='Dr.Gower' then
				update surgeon_count set s_count=s_count+1 where name='Dr.Gower';
			elsif surgery_name='Dr.Taylor' then
				update surgeon_count set s_count=s_count+1 where name='Dr.Taylor';
			else
				update surgeon_count set s_count=s_count+1 where name='Dr.Rutherford';
			end if;
		elsif date_tmp=enddate+1 then 
			enddate:=enddate+1;
			if surgery_name='Dr.Smith' then 
				update surgeon_count  set s_count=s_count+1 where name='Dr.Smith';
			elsif surgery_name='Dr.Charles' then
				update surgeon_count set s_count=s_count+1 where name='Dr.Charles';
			elsif surgery_name='Dr.Richards' then
				update surgeon_count set s_count=s_count+1 where name='Dr.Richards';
			elsif surgery_name='Dr.Gower' then
				update surgeon_count set s_count=s_count+1 where name='Dr.Gower';
			elsif surgery_name='Dr.Taylor' then
				update surgeon_count set s_count=s_count+1 where name='Dr.Taylor';
			else
				update surgeon_count set s_count=s_count+1 where name='Dr.Rutherford';
			end if;
		else
			open surgeon_cursor for
			select name,s_count from surgeon_count 
			where s_count=(select max(s_count) from surgeon_count);
			loop
				fetch surgeon_cursor into surgery_nm,surgery_count;
				exit when surgeon_cursor%notfound;
				insert into surgery_interval values(startdate,enddate,surgery_count,surgery_nm);
			end loop;
			update surgeon_count set s_count=0;
			startdate:=date_tmp;
			enddate:=date_tmp;
			if surgery_name='Dr.Smith' then 
				update surgeon_count  set s_count=s_count+1 where name='Dr.Smith';
			elsif surgery_name='Dr.Charles' then
				update surgeon_count set s_count=s_count+1 where name='Dr.Charles';
			elsif surgery_name='Dr.Richards' then
				update surgeon_count set s_count=s_count+1 where name='Dr.Richards';
			elsif surgery_name='Dr.Gower' then
				update surgeon_count set s_count=s_count+1 where name='Dr.Gower';
			elsif surgery_name='Dr.Taylor' then
				update surgeon_count set s_count=s_count+1 where name='Dr.Taylor';
			else
				update surgeon_count set s_count=s_count+1 where name='Dr.Rutherford';
			end if;
		end if;
	end loop;
	open surgeon_cursor for
	select name,s_count from surgeon_count 
	where s_count=(select max(s_count) from surgeon_count);
	loop
		fetch surgeon_cursor into surgery_nm,surgery_count;
		exit when surgeon_cursor%notfound;
		insert into surgery_interval values(startdate,enddate,surgery_count,surgery_nm);
	end loop;
	dbms_output.put_line('Start date'||'      '||'End date'||'      '||'Surgery count'||'       '||'Surgeon name');
	open result_cursor for
	select* from surgery_interval order by no_surgery desc,start_date desc;
	loop
		fetch result_cursor into startdate,enddate,surgery_count,surgery_name;
		exit when result_cursor%notfound;
		dbms_output.put_line(startdate||'      '||enddate||'      '||surgery_count||'       '||surgery_name);
	end loop;
	close result_cursor;
	close date_cursor;
	close surgeon_cursor;

end;
/
/*5*/
create or replace procedure pro_5
is
startdate date;
enddate date;
surgery_count number;
surgery_name varchar2(30);
surgery_nm varchar2(30);
patient_tp varchar2(10);
po_date date;
dis_date date;
date_tmp date;
s_count number;
date_cursor sys_refcursor;
cursor patient_cursor
is
select post_admission_date,discharge_date,scount,patient_type from post_surgery_Ward where post_admission_date>=to_date('4/1/05','MM/DD/YY') and post_admission_date<=to_date('4/30/05','MM/DD/YY');
begin
	open patient_cursor;
	loop
		fetch patient_cursor into po_date,dis_date,s_count,patient_tp;
		exit when patient_cursor%notfound;
		if patient_tp='General' then
			select name into surgery_name from surgeon_schedule where surgery_Date=po_date and (name='Dr.Smith' or name='Dr.Richards');
		elsif patient_tp='Cardiac' then
			select name into surgery_name from surgeon_schedule where surgery_Date=po_date and (name='Dr.Charles' or name='Dr.Gower');
		else
			select name into surgery_name from surgeon_schedule where surgery_Date=po_date and (name='Dr.Taylor' or name='Dr.Rutherford');
		end if;
		insert into surgery_date values(po_date,surgery_name);
		if s_count=2 then 
			if po_date+2<=to_date('4/31/05','MM/DD/YY') then
				if patient_tp='General' then
					select name into surgery_name from surgeon_schedule where surgery_Date=po_date+2 and (name='Dr.Smith' or name='Dr.Richards');
				elsif patient_tp='Cardiac' then
					select name into surgery_name from surgeon_schedule where surgery_Date=po_date+2 and (name='Dr.Charles' or name='Dr.Gower');
				else
					select name into surgery_name from surgeon_schedule where surgery_Date=po_date+2 and (name='Dr.Taylor' or name='Dr.Rutherford');
				end if;
				insert into surgery_date values(po_date+2,surgery_name);
			end if;
		end if;
	end loop;
	close patient_cursor;
	open date_cursor for
	select distinct surgery_Date from surgery_date where surgeon='Dr.Gower' or surgeon='Dr.Taylor' order by surgery_date asc;
	startdate:=to_date('4/1/05','MM/DD/YY');
	fetch date_cursor into date_tmp;
	enddate:=date_tmp-1;
	dbms_output.put_line('Start date'||'      '||'End date');
	dbms_output.put_line(startdate||'      '||enddate);
	startdate:=date_tmp+1;
	enddate:=date_tmp+1;
	loop
		fetch date_cursor into date_tmp;
		exit when date_cursor%notfound;
		if date_tmp=startdate then
			startdate:=date_tmp+1;
		elsif date_tmp=startdate+1 then
			startdate:=startdate+1;
		else
			enddate:=date_tmp-1;
			dbms_output.put_line(startdate||'      '||enddate);
		end if;
	end loop;
	dbms_output.put_line(startdate||'      '||to_date('4/30/05','MM/DD/YY'));
	close date_cursor;
end;
/
/*6*/
create or replace procedure pro_6
is
patient_nm varchar2(30);
patient_tp varchar2(10);
total_cost number;
g_patient_nm varchar2(30);
s_patient_nm varchar2(30);
pr_patient_nm varchar2(30);
po_patient_nm varchar2(30);
g_patient_tp varchar2(10);
s_patient_tp varchar2(10);
pr_patient_tp varchar2(10);
po_patient_tp varchar2(10);
s_count number;
g_date date;
s_date date;
pr_date date;
po_date date;
dis_date date;
g_date_d date;
dis_date_d date;
second_date date;
patient_cursor sys_refcursor;
details_cursor sys_refcursor;
bob_cursor sys_refcursor;
cursor g_cursor
is
select patient_name,patient_type,g_admission_Date from general_Ward;
cursor s_cursor
is 
select patient_name,patient_type,s_admission_Date from screening_Ward;
cursor pr_cursor
is
select patient_name,patient_type,pre_admission_Date from pre_surgery_WArd;
cursor po_cursor
is
select patient_name,patient_type,post_admission_Date,discharge_Date,scount from post_surgery_Ward;
begin
	open g_cursor;
	open s_cursor;
	open po_cursor;
	open pr_cursor;
	fetch g_cursor into g_patient_nm,g_patient_tp,g_date;
	fetch s_cursor into s_patient_nm,s_patient_tp,s_date;
	fetch po_cursor into po_patient_nm,po_patient_tp,po_date,dis_date,s_count;
	fetch pr_cursor into pr_patient_nm,pr_patient_tp,pr_date;
	loop
		exit when g_cursor%notfound;
		if g_patient_nm=s_patient_nm and s_patient_nm=po_patient_nm and g_patient_tp=s_patient_tp and g_patient_tp=po_patient_tp then
			if (g_date>=to_Date('1/1/05','MM/DD/YY') and g_date<=to_Date('12/31/05','MM/DD/YY'))or (dis_date>=to_Date('1/1/05','MM/DD/YY') and dis_date<=to_Date('12/31/05','MM/DD/YY')) or (g_date<=to_Date('1/1/05','MM/DD/YY') and dis_date>=to_Date('12/31/05','MM/DD/YY')) then		
				if g_patient_nm=pr_patient_nm and g_patient_tp=pr_patient_tp then
					insert into patient_info values(g_patient_nm,g_patient_tp,g_date,s_date,pr_Date,po_date,dis_date,s_count);
				else
					insert into patient_info values(g_patient_nm,g_patient_tp,g_date,s_date,null,po_Date,dis_date,s_count);
				end if;
			end if;	
			if g_patient_nm=pr_patient_nm and g_patient_tp=pr_patient_tp then
				fetch pr_cursor into pr_patient_nm,pr_patient_tp,pr_date;
			end if;	
			fetch g_cursor into g_patient_nm,g_patient_tp,g_date;
			fetch s_cursor into s_patient_nm,s_patient_tp,s_date;
			fetch po_cursor into po_patient_nm,po_patient_tp,po_date,dis_date,s_count;
		else
			exit;
		end if;
	end loop;
	open bob_cursor for
	select g_admission_Date,po_admission_date from patient_info where patient_name='Bob';
	for i in 1..3 loop
		fetch bob_cursor into g_date,po_date;
	end loop;
	dbms_output.put_line('Bob'||'     '||g_date);
	dbms_output.put_line('Patient name'||'      '||'Total_cost');
	second_date:=po_date+2;
	open details_cursor for
	select patient_name, patient_type, g_admission_date, s_admission_date, pr_admission_Date, po_admission_date, discharge_Date, scount 
	from patient_info 
	where discharge_date>=second_date and discharge_date<second_date+3 and patient_name<>'Bob';
	loop
		fetch details_cursor into patient_nm,patient_tp,g_date,s_date,pr_date,po_date,dis_date,s_count;
		exit when details_cursor%notfound;
		total_cost:=totalcost(patient_tp,g_date,s_date,pr_date,po_date,dis_date,s_count);
		dbms_output.put_line(patient_nm||'     '||total_cost);
	end loop;
	commit;
end;
/
/*7*/
create or replace procedure pro_7
is
patient_nm varchar2(30);
surgeon_nm varchar2(30);
assist_nm varchar2(30);
patient_cursor sys_refcursor;
po_date date;
second_date date;
s_count number;
begin
	open patient_cursor for
	select patient_name, post_admission_date,scount
	from post_surgery_Ward
	where patient_type='Cardiac' 
	and ((post_admission_Date>=to_date('4/9/05','MM/DD/YY') and post_admission_Date<=to_date('4/15/05','MM/DD/YY')) 
	or(post_admission_Date>=to_date('4/7/05','MM/DD/YY') and post_admission_Date<=to_date('4/13/05','MM/DD/YY')));
	dbms_output.put_line('Patient name'||'      '||'Post admission date'||'   '||'Surgeon name'||'    '||'Assistant name');	
	loop
		fetch patient_cursor into patient_nm,po_date,s_count;
		exit when patient_cursor%notfound;
		if s_count=2 then
			if po_date>=to_date('4/9/05','MM/DD/YY') and po_Date<=to_date('4/15/05','MM/DD/YY') then
				if po_date=to_date('4/10/05','MM/DD/YY') then
					select name into surgeon_nm from surgeon_schedule where (name='Dr.Charles' or name='Dr.Gower') and surgery_date=po_date;
					dbms_output.put_line(patient_nm||'         '||po_date||'     '||surgeon_nm||'       '||'Tracey  Rick');
				else
					select name into surgeon_nm from surgeon_schedule where (name='Dr.Charles' or name='Dr.Gower') and surgery_date=po_date;
					select name into assist_nm from dr_schedule where ward='Surgery' and duty_date=po_date;
					dbms_output.put_line(patient_nm||'         '||po_date||'     '||surgeon_nm||'       '||assist_nm);
				end if;
			end if;
			second_date:=po_date+2;
			if second_date>=to_date('4/9/05','MM/DD/YY') and second_Date<=to_date('4/15/05','MM/DD/YY') then
				if second_date=to_date('4/10/05','MM/DD/YY') then
					select name into surgeon_nm from surgeon_schedule where (name='Dr.Charles' or name='Dr.Gower') and surgery_date=second_date;
					dbms_output.put_line(patient_nm||'         '||second_date||'     '||surgeon_nm||'       '||'Tracey Rick');
				else
					select name into surgeon_nm from surgeon_schedule where (name='Dr.Charles' or name='Dr.Gower') and surgery_date=second_date;
					select name into assist_nm from dr_schedule where ward='Surgery' and duty_date=second_date;
					dbms_output.put_line(patient_nm||'         '||second_date||'     '||surgeon_nm||'       '||assist_nm);
				end if;
			end if;
		else
			if po_date=to_date('4/10/05','MM/DD/YY') then
				select name into surgeon_nm from surgeon_schedule where (name='Dr.Charles' or name='Dr.Gower') and surgery_date=po_date;
				dbms_output.put_line(patient_nm||'         '||po_date||'     '||surgeon_nm||'       '||'Tracey Rick');
			else
				select name into surgeon_nm from surgeon_schedule where (name='Dr.Charles' or name='Dr.Gower') and surgery_date=po_Date;
				select name into assist_nm from dr_schedule where ward='Surgery' and duty_date=po_date;
				dbms_output.put_line(patient_nm||'         '||po_date||'     '||surgeon_nm||'       '||assist_nm);
			end if;	
		end if;
	end loop;
end;
/
