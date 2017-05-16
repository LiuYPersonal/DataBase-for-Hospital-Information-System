delimiter //
create or replace procedure populate_surgeon_schedule
begin
	declare s_date date;
	declare diff number;
	declare week_diff number;
	declare s_date:=to_date('01/01/05','MM/DD/YY');
	populate_sch: loop
		if extract(year from s_date)='2006' then
		leave populate_sch;
		end if;
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
	end loop populate_sch;
end //
DELIMITER;