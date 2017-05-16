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