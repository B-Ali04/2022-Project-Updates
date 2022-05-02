select 
iden.*

from 
    spriden iden
/* OMG the memories are back */

-- Identity and Personal Information (FERPA Protected)
    left outer join spraddr addr on addr.spraddr_pidm = iden.spriden_pidm
         and addr.spraddr_status_ind is null
         and addr.spraddr_version = (select max(spraddr_version)
                                    from spraddr addr1
                                    where addr1.spraddr_pidm = addr.spraddr_pidm
                                    and addr1.spraddr_status_ind is null)
        and addr.spraddr_surrogate_id = (select max(spraddr_surrogate_id)
                                    from spraddr addr1
                                    where addr1.spraddr_pidm = addr.spraddr_pidm
                                    and addr1.spraddr_status_ind is null)
                                                                                                
    left outer join sprtele tele on tele.sprtele_pidm = iden.spriden_pidm
         and tele.sprtele_surrogate_id = (select max(sprtele_surrogate_id)
                                    from sprtele tele1
                                    where tele1.sprtele_pidm = tele.sprtele_pidm
                                    and tele1.sprtele_status_ind is null)
                                
    left outer join goremal emal on emal.goremal_pidm = iden.spriden_pidm
         and emal.goremal_emal_code = 'SU'
     
    left outer join spbpers pers on pers.spbpers_pidm = iden.spriden_pidm

    left outer join goradid adid on adid.goradid_pidm = iden.spriden_pidm
         and adid.goradid_adid_code = 'SUID'
     
    left outer join sgradvr advr on advr.sgradvr_pidm = iden.spriden_pidm
         and advr.sgradvr_advr_pidm is not null
         and advr.sgradvr_surrogate_id = (select max(sgradvr_surrogate_id)
                                         from sgradvr advr1
                                         where advr1.sgradvr_pidm = iden.spriden_pidm
                                         and advr1.sgradvr_advr_pidm is not null
                                         and advr1.sgradvr_prim_ind = 'Y')

-- Term Assignment
    join stvterm term on term.stvterm_code = 202220

-- Student Information 
    left outer join sgbstdn stdn on stdn.sgbstdn_pidm = iden.spriden_pidm
         and stdn.sgbstdn_term_code_eff = fy_sgbstdn_eff_term(stdn.sgbstdn_pidm, term.stvterm_code)
         and stdn.sgbstdn_majr_code_1 not in ('SUS', 'UNDC', '0000', 'EHS')
         and stdn.sgbstdn_stst_code = 'AS'

     -- Registraion Details
    left outer join shrtgpa tgpa on tgpa.shrtgpa_pidm = iden.spriden_pidm
         and tgpa.shrtgpa_gpa_type_ind = 'I'
         and tgpa.shrtgpa_term_code = term.stvterm_code

    left outer join shrlgpa lgpa on lgpa.shrlgpa_pidm = iden.spriden_pidm
         and lgpa.shrlgpa_gpa_type_ind = 'I'
         and lgpa.shrlgpa_levl_code = stdn.sgbstdn_levl_code      
         
    left outer join saradap adap on adap.saradap_pidm = iden.spriden_pidm
         and adap.saradap_term_code_entry = (select max(saradap_term_code_entry)
                                            from saradap adap1
                                            where adap1.saradap_pidm = iden.spriden_pidm)

     -- Course Registration Details
    left outer join sfrstcr stcr on stcr.sfrstcr_pidm = iden.spriden_pidm
         and stcr.sfrstcr_term_code = term.stvterm_code

    left outer join ssbsect sect on sect.ssbsect_crn = stcr.sfrstcr_crn
         and sect.ssbsect_term_code = stcr.sfrstcr_term_code
     
    left outer join shrtckn tckn on tckn.shrtckn_pidm = iden.spriden_pidm
         and tckn.shrtckn_term_code = stcr.sfrstcr_term_code
         and tckn.shrtckn_crn = stcr.sfrstcr_crn
         
    left outer join scbcrse crse on crse.scbcrse_subj_code = sect.ssbsect_subj_code
         and crse.scbcrse_crse_numb = sect.ssbsect_crse_numb     
         and crse.scbcrse_eff_term = (select max(scbcrse_eff_term)
                                     from scbcrse crse1
                                     where crse1.scbcrse_subj_code = sect.ssbsect_subj_code
                                     and crse1.scbcrse_crse_numb = sect.ssbsect_crse_numb
                                     and crse1.scbcrse_eff_term <= term.stvterm_code)

-- Interal Details
    left outer join sgrsatt satt on satt.sgrsatt_pidm = iden.spriden_pidm
         and satt.sgrsatt_term_code_eff = term.stvterm_code
     
    left outer join shrttrm ttrm on ttrm.shrttrm_pidm = iden.spriden_pidm
         and ttrm.shrttrm_term_code = term.stvterm_code
     
    left outer join sirasgn asgn on asgn.sirasgn_pidm = iden.spriden_pidm 
         and asgn.sirasgn_term_code = stcr.sfrstcr_term_code  

           -- Degreeworks
    left outer join sfrwdrl wdrl on wdrl.sfrwdrl_pidm = iden.spriden_pidm
         and wdrl.sfrwdrl_term_code = (select max(sfrwdrl_term_code)
                                      from sfrwdrl wdrl1
                                      where wdrl1.sfrwdrl_pidm = iden.spriden_pidm)

    left outer join shrdgmr dgmr on dgmr.shrdgmr_pidm = iden.spriden_pidm
         and dgmr.shrdgmr_term_code_grad = term.stvterm_code
         and dgmr.shrdgmr_degs_code = 'GR'

    left outer join sordegr degr on degr.sordegr_pidm = iden.spriden_pidm

           -- External Affairs
    left outer join sgrvetn vetn on vetn.sgrvetn_pidm = iden.spriden_pidm
         and vetn.sgrvetn_term_code_va = term.stvterm_code

    left outer join sortest test on test.sortest_pidm = iden.spriden_pidm
         and test.sortest_surrogate_id = (select min(sortest_surrogate_id)             /* produces first record */
                                         from sortest test1
                                         where test1.sortest_pidm = iden.spriden_pidm)
     
-- Student Finances(Do not use simulatenously with Student Billing)
    left outer join rpratrm atrm on atrm.rpratrm_pidm = iden.spriden_pidm
         and atrm.rpratrm_term_code = term.stvterm_code
         and atrm.rpratrm_aidy_code = term.stvterm_fa_proc_yr
         and atrm.rpratrm_awst_code in ('A', 'WA', 'MA')
         and atrm.rpratrm_surrogate_id = (select min(rpratrm_surrogate_id)             /* produces first record */
                                         from rpratrm atrm1
                                         where atrm.rpratrm_term_code = term.stvterm_code
                                         and atrm1.rpratrm_aidy_code = term.stvterm_fa_proc_yr
                                         and atrm.rpratrm_awst_code in ('A', 'WA', 'MA'))

    left outer join rprawrd awrd on awrd.rprawrd_pidm = iden.spriden_pidm 
         and awrd.rprawrd_aidy_code = term.stvterm_fa_proc_yr
         and awrd.rprawrd_fund_code = atrm.rpratrm_fund_code
         and awrd.rprawrd_surrogate_id = (select min(rprawrd_surrogate_id)             /* produces first record */
                                         from rprawrd awrd1
                                         where awrd1.rprawrd_aidy_code = term.stvterm_fa_proc_yr
                                         and awrd1.rprawrd_fund_code = atrm.rpratrm_fund_code)

    left outer join rorstat stat on stat.rorstat_pidm = iden.spriden_pidm
         and stat.rorstat_aidy_code = term.stvterm_fa_proc_yr
--Student Billing (Do not use simulatenously with Student Fiances)
/*
    left outer join trvybill bill on bill.trvybill_pidm = iden.spriden_pidm
         and bill.trvybill_term_code = term.stvterm_code
    left outer join sprhold hold on hold.sprhold_pidm = iden.spriden_pidm
         and hold.sprhold_from_date >= term.stvterm_start_date
    */
-- Interal Descriptions
    left outer join stvvetc vetc on vetc.stvvetc_code = vetn.sgrvetn_vetc_code

    left outer join stvlevl levl on levl.stvlevl_code = stdn.sgbstdn_levl_code

    left outer join stvstyp styp on styp.stvstyp_code = stdn.sgbstdn_styp_code

    left outer join stvdept dept on dept.stvdept_code = stdn.sgbstdn_dept_code

    left outer join stvdegc degc on degc.stvdegc_code = stdn.sgbstdn_degc_code_1

    left outer join stvmajr majr on majr.stvmajr_code = stdn.sgbstdn_majr_code_1

    left outer join stvclas stvc on stvc.stvclas_code = f_class_calc_fnc(stdn.sgbstdn_pidm, stdn.sgbstdn_levl_code, term.stvterm_code)

    -- Anchor tables
    left outer join srvystu stu on stu.srvystu_pidm = iden.spriden_pidm
         and stu.srvystu_curric_1_major_code not in ('UNDC','SUS','VIS', '0000', 'EHS')
         and stu.srvystu_preterm_class_yr_code not in ('BG')
         and stu.srvystu_posterm_class_yr_code not in ('BG')
         and stu.srvystu_type_code not in ('X')
         and stu.srvystu_status_code = 'AS'
         and stu.srvystu_term_code = term.stvterm_code     
/*
-- Additional Report Sources
left outer join
*/
where
     iden.spriden_ntyp_code is null
     and iden.spriden_change_ind is null
     and exists(select * from sfrstcr r where r.sfrstcr_pidm = iden.spriden_pidm and r.sfrstcr_term_code = term.stvterm_code and r.sfrstcr_rsts_code like 'R%')
     
order by
     iden.spriden_search_last_name
     
     --runtime: 70.218 seconds
     --agg runtime: 195.964 seconds
     --single value runtime: 27.533 seconds
     --agg single value runtime: 30.268 seconds
