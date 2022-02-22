/*
Friendly reminder just as with anything else we do here, this is a work in progress okay?
At no point will this ever be perfect thats just the nature of things. the closest thing we can do
is error free. say it with me, the closest thing. 

Let go do the real thing.

*/
Select
/*[report reuioremnts: student name, major, deg prog, grad date, 'if graduated', gpa(i/ii)]*/
    SPRIDEN.SPRIDEN_ID BANNER_ID,
    SPRIDEN.SPRIDEN_LAST_NAME LAST_NAME,
    SPRIDEN.SPRIDEN_FIRST_NAME FIRST_NAME,
    STVCLAS.STVCLAS_DESC STUDENT_CLASS,
    STVMAJR.STVMAJR_DESC PROGRAM_OF_STUDY,
    STVDEGC.STVDEGC_CODE DEGREE_PROGRAM,
    SGBSTDN.SGBSTDN_STYP_CODE REG_TYPE,
    SGBSTDN.SGBSTDN_STST_CODE STST_Code,
    SGBSTDN.SGBSTDN_TERM_CODE_ADMIT ADMIT_TERM,
    trunc(SHRTGPA.SHRTGPA_GPA,3) Semester_GPA,
    trunc(SHRLGPA.SHRLGPA_GPA,3) Cumulative_GPA,
    SGBSTDN.SGBSTDN_EXP_GRAD_DATE EXP_GRAD_DATE,
    STVCLAS.STVCLAS_SURROGATE_ID,
    SGBSTDN.SGBSTDN_LEVL_CODE,
    SPRIDEN.SPRIDEN_SEARCH_LAST_NAME

from
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = 202220--:parm_term_code_select.STVTERM_CODE

    join SPBPERS SPBPERS on SPBPERS.SPBPERS_PIDM = SPRIDEN.SPRIDEN_PIDM

    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
         and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)
         and SGBSTDN.SGBSTDN_STST_CODE = 'AS'
         and SGBSTDN.SGBSTDN_EXP_GRAD_DATE >= to_date('01/05/2022', 'DD/MM/YYYY') - 30
         and SGBSTDN.SGBSTDN_EXP_GRAD_DATE <= to_date('31/08/2022', 'DD/MM/YYYY') + 120

    left outer join GOREMAL GOREMAL on GOREMAL.GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GOREMAL.GOREMAL_EMAL_CODE = 'SU'
        and GOREMAL.GOREMAL_STATUS_IND = 'A'

    left outer join SHRTGPA SHRTGPA on SHRTGPA.SHRTGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SHRTGPA.SHRTGPA_TERM_CODE = STVTERM.STVTERM_CODE
        and SHRTGPA.SHRTGPA_GPA_TYPE_IND = 'I'

    left outer join SHRLGPA SHRLGPA on SHRLGPA.SHRLGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRLGPA.SHRLGPA_LEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE
         and SHRLGPA.SHRLGPA_GPA_TYPE_IND = 'I'
         and SHRLGPA.SHRLGPA_GPA is not null
         
    join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, STVTERM.STVTERM_CODE)

    join STVDEGC STVDEGC on STVDEGC.STVDEGC_CODE = SGBSTDN.SGBSTDN_DEGC_CODE_1

    join STVMAJR STVMAJR on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1

where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
and stvdegc.stvdegc_code not in ('AAS')
--$addfilter

--$beginorder

order by
      STVMAJR.STVMAJR_CODE, SHRLGPA.SHRLGPA_GPA desc, SPRIDEN.SPRIDEN_SEARCH_LAST_NAME

--$endorder
