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