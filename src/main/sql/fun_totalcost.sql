create or replace function totalcost(IN patient_tp varchar2,g_date date,s_date date,pr_date date,po_date date,dis_date date,s_count number, \
OUT total_cost number)

begin
	declare diff_cost number;

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