select * from code_value where display like 'Resident';

select * from encounter e
where e.encntr_type_cd = 49848542 
and e.depart_dt_tm is null
and e.location_cd = 46686151
and rownum <= 15;
