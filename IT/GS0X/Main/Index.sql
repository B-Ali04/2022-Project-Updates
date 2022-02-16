Select
    SPRIDEN.SPRIDEN_ID Banner_ID,
    f_format_name(SPRIDEN.SPRIDEN_PIDM, 'LFMI') Student_Name,
    GORADID.GORADID_ADDITIONAL_ID SU_ID,
    STVCLAS.STVCLAS_CODE Student_Class,
    SGBSTDN.SGBSTDN_DEGC_CODE_1 Degree_Program,

    SHRTGPA.SHRTGPA_HOURS_ATTEMPTED Semester_HC,
    SHRTGPA.SHRTGPA_HOURS_EARNED Semester_HP,
    SHRTGPA.SHRTGPA_QUALITY_POINTS Semester_Grd_Pts,
    trunc(SHRTGPA.SHRTGPA_GPA,3) Semester_GPA,

    SHRLGPA.SHRLGPA_HOURS_ATTEMPTED Cumulative_HC,
    SHRLGPA.SHRLGPA_HOURS_EARNED Cumulative_HP,
    SHRLGPA.SHRLGPA_QUALITY_POINTS Cumulative_Grd_Pts,
    trunc(SHRLGPA.SHRLGPA_GPA,3) Cumulative_GPA,

    SPRIDEN.SPRIDEN_SEARCH_LAST_NAME,
    STVCLAS.STVCLAS_SURROGATE_ID
    
from
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = :parm_term_code_select.STVTERM_CODE

    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)
         and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
         and SGBSTDN.SGBSTDN_LEVL_CODE = 'UG'
         and SGBSTDN.SGBSTDN_STST_CODE = 'AS'

    join GORADID GORADID on GORADID.GORADID_PIDM = SPRIDEN.SPRIDEN_PIDM
         and GORADID.GORADID_ADID_CODE = 'SUID'

    left outer join SHRTGPA SHRTGPA on SHRTGPA.SHRTGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SHRTGPA.SHRTGPA_TERM_CODE = STVTERM.STVTERM_CODE
        and SHRTGPA.SHRTGPA_GPA_TYPE_IND = 'I'

    left outer join SHRLGPA SHRLGPA on SHRLGPA.SHRLGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRLGPA.SHRLGPA_LEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE
         and SHRLGPA.SHRLGPA_GPA_TYPE_IND = 'I'
         and SHRLGPA.SHRLGPA_GPA is not null

    join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE,STVTERM.STVTERM_CODE)

where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
    and exists(
        select *
        from SFRSTCR SFRSTCR
        where SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
        and SFRSTCR.SFRSTCR_RSTS_CODE in ('RE','RW'))

--$addfilter

--$beginorder

order by
    STVCLAS.STVCLAS_SURROGATE_ID, SPRIDEN.SPRIDEN_SEARCH_LAST_NAME

--$endorder