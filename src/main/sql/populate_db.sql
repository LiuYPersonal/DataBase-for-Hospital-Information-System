DELIMITER //
create or replace procedure populate_db()

begin
	declare p_nm varchar2(30);
	declare g_date date;
	declare p_tp varchar2(10);
	declare input_cursor cursor for
		select* from patient_input
		order by general_ward_admission_date,patient_name;

	open input_cursor;
	populate_gen: loop
		fetch input_cursor into p_nm,g_date,p_tp;
		if input_cursor%notfound then
		leave popupate_gen;
		end if;
		insert into general_ward values(p_nm,g_date,p_tp);
	end loop populate_gen;
	close input_cursor;
end //
DELIMITER;
