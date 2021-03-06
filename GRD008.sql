select

    SPRIDEN_LAST_NAME Last_Name,
    SPRIDEN_FIRST_NAME First_Name,
    GORADID.GORADID_ADDITIONAL_ID SUID,
    SFRSTCR.SFRSTCR_GRDE_CODE Letter_Grade,
    shrtckn_subj_code, shrtckn_crse_numb,
    SSBSECT1.SSBSECT_SICAS_CAMP_COURSE_ID s1,
    SSBSECT.SSBSECT_SICAS_CAMP_COURSE_ID s2,
    ssbsect1.ssbsect_Term_code c1,
    ssbsect.ssbsect_Term_code c2
    
    
from
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE > 202020--:parm_term_code_select.STVTERM_CODE

    join GORADID GORADID on GORADID.GORADID_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GORADID.GORADID_ADID_CODE = 'SUID'

    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)
        and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
        and SGBSTDN.SGBSTDN_STST_CODE in ('AS')

    join SFRSTCR SFRSTCR on SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SFRSTCR.SFRSTCR_RSTS_CODE in ('RW', 'RE')
        and SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE

    left outer join SHRTCKN SHRTCKN on SHRTCKN.SHRTCKN_PIDM = SFRSTCR.SFRSTCR_PIDM
        and SHRTCKN.SHRTCKN_TERM_CODE = SFRSTCR.SFRSTCR_TERM_CODE
        and SHRTCKN.SHRTCKN_CRN = SFRSTCR.SFRSTCR_CRN

    join STVMAJR STVMAJR on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1
    join STVDEGC STVDEGC on STVDEGC.STVDEGC_CODE = SGBSTDN.SGBSTDN_DEGC_CODE_1
    join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, STVTERM.STVTERM_CODE)



    left outer join SSBSECT SSBSECT on SSBSECT.SSBSECT_CRN = SFRSTCR.SFRSTCR_CRN
        and SSBSECT.SSBSECT_TERM_CODE = STVTERM.STVTERM_CODE
/*
    join SFRSTCR SFRSTCR1 on SFRSTCR1.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SFRSTCR1.SFRSTCR_RSTS_CODE in ('RW', 'RE')
*/
    left outer join ssbsect ssbsect1 on ssbsect1.ssbsect_term_code != ssbsect.ssbsect_term_code and SSBSECT1.SSBSECT_SICAS_CAMP_COURSE_ID = SSBSECT.SSBSECT_SICAS_CAMP_COURSE_ID
         and SSBSECT1.SSBSECT_CRN = SFRSTCR.SFRSTCR_CRN
where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
        and exists(
        select *
        from SFRSTCR SFRSTCR
        where SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
        and SFRSTCR.SFRSTCR_RSTS_CODE in ('RE','RW')
        )   
        
        and SSBSECT1.SSBSECT_SICAS_CAMP_COURSE_ID = SSBSECT.SSBSECT_SICAS_CAMP_COURSE_ID
--        and sfrstcr_grde_code in ('F','IF')
        and (ssbsect1.ssbsect_term_code like '%%%%40' or (ssbsect1.ssbsect_term_code like '%%%%20'))
        and (ssbsect.ssbsect_term_code like '%%%%40' or (ssbsect.ssbsect_term_code like '%%%%20'))
--$addfilter
--$beginorder

order by
    SPRIDEN.SPRIDEN_LAST_NAME
--$endorder

