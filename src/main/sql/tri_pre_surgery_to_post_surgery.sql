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