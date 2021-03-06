Select
    SPRIDEN.SPRIDEN_ID Banner_ID,
    SPRIDEN.SPRIDEN_LAST_NAME Last_Name,
    SPRIDEN.SPRIDEN_FIRST_NAME First_Name,
    STVCLAS.STVCLAS_DESC Student_Class,
    STVMAJR.STVMAJR_DESC Program_Of_Study,
    STVDEGC.STVDEGC_CODE Degree_Program,
    SGBSTDN.SGBSTDN_STYP_CODE Reg_Type,
    SGBSTDN.SGBSTDN_STST_CODE STST_Code,
    trunc(SHRTGPA.SHRTGPA_GPA,3) Semester_GPA,
    trunc(SHRLGPA.SHRLGPA_GPA,3) Cumulative_GPA,
    SGBSTDN.SGBSTDN_EXP_GRAD_DATE Exp_Grad_Date,
    case
        when SGRSATT.SGRSATT_ATTS_CODE in ('LHON','UHON', 'HONR') then 'Honors Student'
        else ''
    end Honors_Student,
    GOREMAL.GOREMAL_EMAIL_ADDRESS Email_Address
    
from
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = :parm_term_code_select.STVTERM_CODE

    left outer join GOREMAL GOREMAL on GOREMAL.GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GOREMAL.GOREMAL_EMAL_CODE = 'SU'
        and GOREMAL.GOREMAL_STATUS_IND = 'A'

    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
         and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)
         and SGBSTDN.SGBSTDN_STST_CODE = 'AS'

    left outer join SHRTGPA SHRTGPA on SHRTGPA.SHRTGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRTGPA.SHRTGPA_GPA_TYPE_IND = 'I'
         and SHRTGPA.SHRTGPA_LEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE
         and SHRTGPA.SHRTGPA_TERM_CODE = STVTERM.STVTERM_CODE
        
    left outer join SHRLGPA SHRLGPA on SHRLGPA.SHRLGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRLGPA.SHRLGPA_GPA_TYPE_IND = 'I'
         and SHRLGPA.SHRLGPA_LEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE

    left outer join SGRSATT SGRSATT on SGRSATT.SGRSATT_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGRSATT.SGRSATT_TERM_CODE_EFF = STVTERM.STVTERM_CODE
         and SGRSATT.SGRSATT_ATTS_CODE in ('LHON','UHON', 'HONR')

    join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, STVTERM.STVTERM_CODE)

    join STVDEGC STVDEGC on STVDEGC.STVDEGC_CODE = SGBSTDN.SGBSTDN_DEGC_CODE_1

    join STVMAJR STVMAJR on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1

where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
    and exists(
        select * from SFRSTCR SFRSTCR
        where SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
              and SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
              and SFRSTCR.SFRSTCR_RSTS_CODE in ('RE','RW')
    )

--$addfilter

--$beginorder

order by
    SPRIDEN.SPRIDEN_SEARCH_LAST_NAME

--$endorder