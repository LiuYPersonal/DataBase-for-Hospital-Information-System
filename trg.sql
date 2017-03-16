/*1*/
create or replace trigger trg_gen
before insert on general_ward
for each row
declare
count_1 number;
general_cursor sys_refcursor;
patient_nm varchar2(20);
patient_tp varchar2(10);
bed_n number;
i number;
type array is varray(5) of number;
array_bed array:=array(1,2,3,4,5);
j number;
begin
	j:=3;
	loop
	select count(*) into count_1 from 
	(select s.patient_name,s.patient_type from screening_ward s where s.s_admission_date<=:new.g_admission_date+j
	minus
	select pr.patient_name,pr.patient_type from pre_surgery_ward pr where pr.pre_admission_date<=:new.g_admission_date+j
	minus
	(select po.patient_name,po.patient_type 
	from post_surgery_ward po where po.post_admission_date<=:new.g_admission_date+j
	minus
	select pr.patient_name,pr.patient_type
	from pre_surgery_ward pr where pr.pre_admission_date<=:new.g_admission_date+j));
	if count_1<5 then
		if count_1=0 then 
			insert into screening_ward values(:new.patient_name,:new.g_admission_date+j,1,:new.patient_type);
			exit;
		else
			open general_cursor for
			select s.patient_name,s.patient_type from screening_ward s where s.s_admission_date<=:new.g_admission_date+j
			minus
			select pr.patient_name,pr.patient_type from pre_surgery_ward pr where pr.pre_admission_date<=:new.g_admission_date+j
			minus
			(select po.patient_name,po.patient_type 
			from post_surgery_ward po where po.post_admission_date<=:new.g_admission_date+j
			minus
			select pr.patient_name,pr.patient_type
			from pre_surgery_ward pr where pr.pre_admission_date<=:new.g_admission_date+j);
			loop
				fetch general_cursor into patient_nm,patient_tp;
				exit when general_cursor%notfound;
				select s.bed_no into bed_n
				from screening_ward s
				where s.patient_name=patient_nm and s.patient_type=patient_tp and s.s_admission_date=
				(select max(s2.s_admission_Date) from screening_ward s2 
				where s2.patient_name=patient_nm and s2.patient_type=patient_tp and s2.s_admission_date<=:new.g_admission_date+j);
				for i in 1..5 loop
					if bed_n=i then
					array_bed(i):=0;
					end if;
				end loop;
			end loop;
			for i in 1..5 loop
				if array_bed(i)!=0 then
					insert into screening_Ward values(:new.patient_name,:new.g_admission_date+j,array_bed(i),:new.patient_type);
					close general_cursor;
					exit;
				end if;
			end loop;
			exit;
		end if;
	else j:=j+1;
	end if;
	end loop;
end;
/
/*2*/
create or replace trigger trg_scr
before insert on screening_ward
for each row
declare
count_1 number;
count_stable number;
scr_cursor_pre sys_refcursor;
type array is varray(4) of number;
array_bed array:=array(1,2,3,4);
i number;
j number;
patient_nm varchar2(20);
patient_tp varchar2(10);
bed_n number;
TP number;
BP_tmp number;
begin
	j:=3;
	loop
	if j>3 then
		count_stable:=0;
		for i in 1..4 loop
			select p.Temperature,p.BP into TP,BP_tmp
			from patient_chart p
			where p.pdate=:new.s_admission_date+j-i and p.patient_name=:new.patient_name;
			if TP>=97 and TP<=100 and BP_tmp>=110 and BP_tmp<=140 then
				count_stable:=count_stable+1;
			end if;
		end loop;
		if count_stable = 4 then
			insert into post_surgery_ward values(:new.patient_name,:new.s_admission_date+j,null,1,:new.patient_type);
			exit;
		end if;
	end if;
	select count(*) into count_1 from
	(select pr.patient_name,pr.patient_type from pre_surgery_ward pr where pr.pre_admission_date<=:new.s_admission_date+j
	minus
	select po.patient_name,po.patient_type from post_surgery_ward po where po.post_admission_date<=:new.s_admission_date+j);
	if count_1=0 then
		insert into pre_surgery_ward values(:new.patient_name,:new.s_admission_Date+j,1,:new.patient_type);
		insert into post_surgery_ward values(:new.patient_name,:new.s_admission_Date+j+2,null,1,:new.patient_type);
		exit;
	elsif count_1<4 then
		open scr_cursor_pre for
		select pr.patient_name,pr.patient_type from pre_surgery_ward pr where pr.pre_admission_date<=:new.s_admission_date+j
		minus
		select po.patient_name,po.patient_type from post_surgery_ward po where po.post_admission_date<=:new.s_admission_date+j;
		loop
			fetch scr_cursor_pre into patient_nm,patient_tp;
			exit when scr_cursor_pre%notfound;
			select pre.bed_no into bed_n
			from pre_surgery_ward pre
			where pre.patient_name=patient_nm and pre.patient_type=patient_tp and pre.pre_admission_Date=
			(select max(pre2.pre_admission_date) from pre_surgery_ward pre2
			where pre2.patient_name=patient_nm and pre2.patient_type=patient_tp and pre2.pre_admission_date<=:new.s_admission_Date+j);
			for i in 1..4 loop
				if bed_n=i then 
					array_bed(i):=0;
				end if;
			end loop;
		end loop;
		for i in 1..4 loop
			if array_bed(i)!=0 then
			insert into pre_surgery_ward values(:new.patient_name,:new.s_admission_date+j,array_bed(i),:new.patient_type);
			insert into post_surgery_ward values(:new.patient_name,:new.s_admission_date+j+2,null,1,:new.patient_type);
			close scr_cursor_pre;
			exit;
			end if;
		end loop;
		exit;
	else j:=j+1;
	end if;
	exit when j=10;
	end loop;
end;
/
/*3*/
create or replace trigger trg_post
after insert on post_surgery_ward
declare
TP number;
BP_tmp number;
patient_nm varchar2(20);
post_date date;
patient_tp varchar2(20);
i number;
flag number;
begin
	select patient_name,post_admission_date,patient_type into patient_nm, post_date,patient_tp from post_surgery_ward where discharge_date is null; 
	if patient_tp ='General' then
		update post_surgery_ward set discharge_date=Post_date+2 
		where patient_name=patient_nm and post_admission_date=post_date;
	elsif patient_tp='Cardiac' then
		flag:=0;
		for i in 1..2 loop
			select p.BP into BP_tmp from patient_chart p
			where p.patient_name=patient_nm and p.pdate=post_date+i-1;
			if BP_tmp<110 or BP_tmp>140 then
				flag:=1;
			end if;
		end loop;
		if flag=1 then 
			update post_surgery_ward set scount=2,discharge_date=Post_date+4 
			where patient_name=patient_nm and post_admission_date=post_date;
		else 
			update post_surgery_ward set discharge_date=Post_date+2 
			where patient_name=patient_nm and post_admission_date=post_date;
		end if;
	else 
		flag:=0;
		for i in 1..2 loop
			select p.temperature,p.BP into TP,BP_tmp from patient_chart p
			where p.patient_name=patient_nm and p.pdate=post_date+i-1;
			if BP_tmp<110 or BP_tmp>140 or TP<97 or TP>100 then
				flag:=1;
			end if;
		end loop;
		if flag=1 then 
			update post_surgery_ward set scount=2,discharge_date=Post_date+4 
			where patient_name=patient_nm and post_admission_date=post_date;
		else 
			update post_surgery_ward set discharge_date=Post_date+2 
			where patient_name=patient_nm and post_admission_date=post_date;
		end if;
	end if;	
end;
/

