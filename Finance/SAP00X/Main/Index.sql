select
    SPRIDEN.SPRIDEN_ID Banner_ID,
    SPRIDEN.SPRIDEN_LAST_NAME Last_Name,
    SPRIDEN.SPRIDEN_FIRST_NAME First_Name,
    RORSAPR.RORSAPR_SAPR_CODE SAP_CODE,
    RORSAPR.RORSAPR_TERM_CODE SAP_TERM,
    SHRTGPA.SHRTGPA_LEVL_CODE Student_Level,
    SGBSTDN.SGBSTDN_DEGC_CODE_1 Degree_Code,
    GOREMAL.GOREMAL_EMAIL_ADDRESS SU_Email_Address,
    GOREMAL2.GOREMAL_EMAIL_ADDRESS Personal_Email_Address,
    SRVYSTU.SRVYSTU_ENTRY_TERM_CODE Term_Code_Addmitted,
    SHRTGPA.SHRTGPA_HOURS_ATTEMPTED Semester_Hours_Attempted,
    SHRTGPA.SHRTGPA_HOURS_EARNED Semester_Hours_Earned,
    trunc(SHRTGPA.SHRTGPA_GPA,3) Semester_GPA,
    SHRLGPA.SHRLGPA_HOURS_ATTEMPTED Cumulative_Hours_Attempted,
    SHRLGPA.SHRLGPA_HOURS_EARNED Cumulative_Hours_Earned,
    trunc(SHRLGPA.SHRLGPA_GPA,3) Cumulative_GPA,
    SHRLGPA2.SHRLGPA_HOURS_EARNED Transfered_credits,
    SPRADDR.SPRADDR_STREET_LINE1 Street_1,
    SPRADDR.SPRADDR_STREET_LINE2 Street_2,
    SPRADDR.SPRADDR_CITY City,
    SPRADDR.SPRADDR_STAT_CODE State,
    substr(SPRADDR.SPRADDR_ZIP,1,5) Zip_Code,
    CASE
    WHEN EXISTS(SELECT 1 FROM RPRATRM RPRATRM WHERE RPRATRM.RPRATRM_PIDM = SPRIDEN.SPRIDEN_PIDM
      AND RPRATRM.RPRATRM_TERM_CODE = STVTERM_CODE
      AND RPRATRM.RPRATRM_AIDY_CODE = STVTERM.STVTERM_FA_PROC_YR
      AND RPRATRM.RPRATRM_FUND_CODE IN ('FSUB', 'FUSB', 'FPLS', 'FPELL', 'FFWS', 'FSEOG', 'FGPLS')
      AND RPRATRM.RPRATRM_AWST_CODE IN ( 'A', 'WA', 'MA')) THEN 'Y'
    ELSE 'N'
    END Accepted_Aid

from
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = :Parm_Term_Code_Select.STVTERM_CODE

    left outer join GOREMAL GOREMAL on GOREMAL.GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GOREMAL.GOREMAL_EMAL_CODE = 'SU'
        and GOREMAL.GOREMAL_STATUS_IND = 'A'

    left outer join GOREMAL GOREMAL2 on GOREMAL2.GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GOREMAL2.GOREMAL_EMAL_CODE = 'PERS'
        and GOREMAL2.GOREMAL_STATUS_IND = 'A'
        and GOREMAL2.GOREMAL_SURROGATE_ID = (
        select MAX(GOREMAL_SURROGATE_ID) from GOREMAL g
        where g.GOREMAL_PIDM = GOREMAL2.GOREMAL_PIDM
        and g.GOREMAL_EMAL_CODE = 'PERS'
        and g.GOREMAL_STATUS_IND = 'A'
        )

    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)
         and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
         and SGBSTDN.SGBSTDN_STST_CODE = 'AS'

    left outer join SHRTGPA SHRTGPA on SHRTGPA.SHRTGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRTGPA_TERM_CODE = STVTERM.STVTERM_CODE
         and SHRTGPA.SHRTGPA_GPA_TYPE_IND = 'I'

    left outer join SHRLGPA SHRLGPA on SHRLGPA.SHRLGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRLGPA.SHRLGPA_LEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE
         and SHRLGPA.SHRLGPA_GPA_TYPE_IND = 'I'
         and SHRLGPA.SHRLGPA_GPA is not null

    left outer join SHRLGPA SHRLGPA2 on SHRLGPA2.SHRLGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRLGPA2.SHRLGPA_LEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE
         and SHRLGPA2.SHRLGPA_GPA_TYPE_IND = 'T'
         and SHRLGPA2.SHRLGPA_GPA is not null

    left outer join SPRADDR SPRADDR on SPRADDR.SPRADDR_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SPRADDR.SPRADDR_ATYP_CODE in ('PR')
         and SPRADDR.SPRADDR_STATUS_IND is null
         and SPRADDR.SPRADDR_VERSION = (
             select max(SPRADDR_VERSION)
             from SPRADDR SPRADDR1
             where SPRADDR1.SPRADDR_PIDM = SPRADDR.SPRADDR_PIDM
             and SPRADDR1.SPRADDR_ATYP_CODE in ('PR')
             and SPRADDR1.SPRADDR_STATUS_IND is null)
        and SPRADDR.SPRADDR_SURROGATE_ID = (
             select max(SPRADDR_SURROGATE_ID)
             from SPRADDR SPRADDR1
             where SPRADDR1.SPRADDR_PIDM = SPRADDR.SPRADDR_PIDM
             and SPRADDR1.SPRADDR_ATYP_CODE in ('PR')
             and SPRADDR1.SPRADDR_STATUS_IND is null)

    left outer join SHRTTRM SHRTTRM on SHRTTRM.SHRTTRM_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRTTRM.SHRTTRM_TERM_CODE = STVTERM.STVTERM_CODE

-- consider removal
    left outer join SARADAP SARADAP on SARADAP.SARADAP_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SARADAP.SARADAP_APST_CODE = 'D'
         and SARADAP.SARADAP_TERM_CODE_ENTRY = (
         select max(SARADAP_TERM_CODE_ENTRY) from SARADAP s
         where S.SARADAP_PIDM = SARADAP.SARADAP_PIDM
         )

    left outer join RORSAPR RORSAPR on RORSAPR.RORSAPR_PIDM = SPRIDEN.SPRIDEN_PIDM
         and RORSAPR.RORSAPR_TERM_CODE = (
         select max(RORSAPR_TERM_CODE) from RORSAPR r
         where r.RORSAPR_PIDM = RORSAPR.RORSAPR_PIDM
         )

    left outer join srvystu srvystu on srvystu.srvystu_pidm = spriden.spriden_pidm
         and srvystu_Term_Code = stvterm.stvterm_code
         and srvystu_status_code = 'AS'
         and srvystu_preterm_class_yr_code not in ('BG')
         and srvystu_posterm_class_yr_code not in ('BG')
         and srvystu_type_code not in ('X')
         and srvystu_curric_1_major_code not in ('UNDC','SUS','VIS','0000')

where
      SPRIDEN.SPRIDEN_NTYP_CODE is null
      and SPRIDEN.SPRIDEN_CHANGE_IND is null
      and exists( select * from SFRSTCR where SFRSTCR_PIDM = SPRIDEN_PIDM and SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE and SFRSTCR_RSTS_CODE = 'RE')

order by
      SPRIDEN.SPRIDEN_LAST_NAME