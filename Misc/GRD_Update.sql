select
f_format_name(spriden_pidm, 'LFMI') Name,
spriden.spriden_id Banner_ID,
SFRSTCR.SFRSTCR_PIDM,
SFRSTCR.SFRSTCR_CRN,
SSBSECT.SSBSECT_SUBJ_CODE,
SSBSECT.SSBSECT_CRSE_NUMB,
SSBSECT.SSBSECT_TERM_CODE,
r.SFRSTCR_GRDE_CODE Previous_Grade,
r.TERM_CODE Previous_Term

from 
SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = 202240--:parm_term_code_select.STVTERM_CODE

    join GORADID GORADID on GORADID.GORADID_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GORADID.GORADID_ADID_CODE = 'SUID'

    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)
        and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
        and SGBSTDN.SGBSTDN_STST_CODE in ('AS')

left outer join SFRSTCR SFRSTCR on SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SFRSTCR.SFRSTCR_RSTS_CODE like 'R%'
         and SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
         
left outer join SSBSECT SSBSECT on SSBSECT.SSBSECT_CRN = SFRSTCR.SFRSTCR_CRN
     and SSBSECT.SSBSECT_TERM_CODE=  SFRSTCR.SFRSTCR_TERM_CODE

join REL_STUDENT_ACAD_HISTORY r on r.PIDM = SPRIDEN.SPRIDEN_PIDM
    and r.term_code != SFRSTCR.SFRSTCR_TERM_CODE
    and r.SUBJ_CODE = SSBSECT.SSBSECT_SUBJ_CODE
    and r.CRSE_NUMB = SSBSECT.SSBSECT_CRSE_NUMB
    
    join STVMAJR STVMAJR on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1
    join STVDEGC STVDEGC on STVDEGC.STVDEGC_CODE = SGBSTDN.SGBSTDN_DEGC_CODE_1
    join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, STVTERM.STVTERM_CODE)
    
where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
    and 
         exists(

         select *

         from SFRSTCR r

         where r.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
               and r.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
               and r.SFRSTCR_RSTS_CODE like 'R%'
               
            ) 

and r.GRDE_CODE = 'F'

order by spriden_search_last_name, r.term_code desc, ssbsect.ssbsect_subj_code, ssbsect.ssbsect_crse_numb