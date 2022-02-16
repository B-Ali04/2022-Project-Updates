Select
    SPRIDEN.SPRIDEN_ID BANNER_ID,
    SPRIDEN.SPRIDEN_LAST_NAME LAST_NAME,
    SPRIDEN.SPRIDEN_FIRST_NAME FIRST_NAME,
    STVCLAS.STVCLAS_DESC STUDENT_CLASS,
    STVMAJR.STVMAJR_DESC PROGRAM_OF_STUDY,
    STVDEGC.STVDEGC_CODE DEGREE_PROGRAM,
    SGBSTDN.SGBSTDN_STYP_CODE REG_TYPE,
    SGBSTDN.SGBSTDN_STST_CODE STST_Code,
    SGBSTDN.SGBSTDN_TERM_CODE_ADMIT ADMIT_TERM,
    SGBSTDN.SGBSTDN_EXP_GRAD_DATE EXP_GRAD_DATE,
    STVCLAS.STVCLAS_SURROGATE_ID,
    SGBSTDN.SGBSTDN_LEVL_CODE,
    SPRIDEN.SPRIDEN_SEARCH_LAST_NAME

from
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = :parm_term_code_select.STVTERM_CODE

    join SPBPERS SPBPERS on SPBPERS.SPBPERS_PIDM = SPRIDEN.SPRIDEN_PIDM

    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
         and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)
         and SGBSTDN.SGBSTDN_STST_CODE = 'AS'
         and SGBSTDN.SGBSTDN_EXP_GRAD_DATE >= to_date(:parm_degree_date_select.STVTERM_END_DATE) - 30
         and SGBSTDN.SGBSTDN_EXP_GRAD_DATE <= to_date(:parm_degree_date_select.STVTERM_END_DATE) + 120

    left outer join GOREMAL GOREMAL on GOREMAL.GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GOREMAL.GOREMAL_EMAL_CODE = 'SU'
        and GOREMAL.GOREMAL_STATUS_IND = 'A'

    join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, STVTERM.STVTERM_CODE)

    join STVDEGC STVDEGC on STVDEGC.STVDEGC_CODE = SGBSTDN.SGBSTDN_DEGC_CODE_1

    join STVMAJR STVMAJR on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1

where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
--$addfilter

--$beginorder

order by
      SPRIDEN.SPRIDEN_SEARCH_LAST_NAME

--$endorder