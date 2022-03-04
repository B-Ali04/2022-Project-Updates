select
shrtckn.shrtckn_subj_code || shrtckn.shrtckn_crse_numb Course_Key,
shrtckn.shrtckn_crn Ref_No,
sfrstcr.sfrstcr_credit_hr Credit_Hours,
f_format_name(SPRIDEN.SPRIDEN_PIDM, 'LFMI') Full_Name,
goradid.goradid_additional_id SUID,
STVCLAS.STVCLAS_CODE,
SHRTCKN.SHRTCKN_ACTIVITY_DATE Activity_Date
from
    SPRIDEN SPRIDEN

     join STVTERM STVTERM on STVTERM.STVTERM_CODE = :parm_untitled_listbox.STVTERM_CODE

     join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
          and SGBSTDN.SGBSTDN_STST_CODE = 'AS'
          and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)

    inner join SFRSTCR SFRSTCR on SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SFRSTCR.SFRSTCR_RSTS_CODE in ('RW', 'RE')
        and SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE

    inner join SSBSECT SSBSECT on SSBSECT.SSBSECT_CRN = SFRSTCR.SFRSTCR_CRN

            left outer join shrtckn shrtckn on shrtckn.shrtckn_pidm = spriden.spriden_pidm
         and shrtckn.shrtckn_term_code = stvterm.stvterm_code
         and shrtckn.shrtckn_crn = sfrstcr.sfrstcr_crn

left outer join goradid goradid on goradid.goradid_pidm = spriden.spriden_pidm
    and goradid.goradid_adid_code = 'SUID'

join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, STVTERM.STVTERM_CODE)

where
     SPRIDEN.spriden_ntyp_code is null
     and SPRIDEN.spriden_change_ind is null

     and (
         exists(

         select *

         from SFRSTCR r

         where r.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
               and r.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
               and r.SFRSTCR_RSTS_CODE like 'R%'
               and r.SFRSTCR_GMOD_CODE = 'Y'
        )
            and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('EHS', 'SUS','0000','VIS')
            )
            and SSBSECT.SSBSECT_GMOD_CODE = 'Y'
--$addfilter
--$beginorder
order by
    SSBSECT.SSBSECT_SUBJ_CODE,
    SSBSECT.SSBSECT_CRSE_NUMB,
    SPRIDEN.SPRIDEN_SEARCH_LAST_NAME,
    SPRIDEN.SPRIDEN_FIRST_NAME
--$endorder
