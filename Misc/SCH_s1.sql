Select
    SPRIDEN.SPRIDEN_ID Banner_ID,
    SPRIDEN.SPRIDEN_LAST_NAME Last_Name,
    SPRIDEN.SPRIDEN_FIRST_NAME First_Name,
    f_format_name(SPRIDEN_PIDM, 'LFMI') Full_Name,


--    SGBSTDN.SGBSTDN_EXP_GRAD_DATE Expected_Grad_Date,
--    SHRDGMR.SHRDGMR_GRAD_DATE Actual_Grad_Date,    
/*
    case
      when SHRDGMR.SHRDGMR_GRAD_DATE is null then SGBSTDN.SGBSTDN_EXP_GRAD_DATE
        ELSE to_date(SHRDGMR.SHRDGMR_GRAD_DATE, 'MM/DD/YYY') || '*' 
      end GRAD_DATE,*/
    --to_char(SGBSTDN.SGBSTDN_EXP_GRAD_DATE, 'yyyy') as processed_grad_year,
    case
      when (SHRDGMR.SHRDGMR_GRAD_DATE is not null and SHRDGMR.SHRDGMR_DEGS_CODE = 'GR') then '* '|| to_char(SHRDGMR.SHRDGMR_GRAD_DATE, 'MM/DD/yyyy')
        else to_char(SGBSTDN.SGBSTDN_EXP_GRAD_DATE, 'MM/DD/YYYY')
      end GRAD_DATE,
      --to_char(SGBSTDN.SGBSTDN_EXP_GRAD_DATE, 'MM/DD/YYYY') <= 
      ('8/31/' ||  STVTERM.STVTERM_ACYR_CODE) THE_WHEY

from
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = 202220 --:parm_term_code_select.STVTERM_CODE

    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGBSTDN.SGBSTDN_LEVL_CODE = 'UG'
         and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
         and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)
         and SGBSTDN.SGBSTDN_STST_CODE = 'AS'

    
    left outer join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM, SGBSTDN.SGBSTDN_LEVL_CODE, STVTERM.STVTERM_CODE)
    left outer join STVDEPT STVDEPT on STVDEPT.STVDEPT_CODE = SGBSTDN.SGBSTDN_DEPT_CODE
    left outer join STVDEGC STVDEGC on STVDEGC.STVDEGC_CODE = SGBSTDN.SGBSTDN_DEGC_CODE_1
    left outer join STVMAJR STVMAJR on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1
    left outer join STVMAJR STVMAJR2 on STVMAJR2.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_MINR_1
    left outer join STVMAJR STVMAJR3 on STVMAJR3.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_CONC_1


/**[section updates]**/
    left outer join SHRDGMR SHRDGMR on SHRDGMR.SHRDGMR_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SHRDGMR.SHRDGMR_TERM_CODE_GRAD = STVTERM.STVTERM_CODE
        and SHRDGMR.SHRDGMR_DEGS_CODE = 'GR'
where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
    and SGBSTDN.SGBSTDN_DEPT_CODE in ('CHEM', 'EFB', 'ERE', 'ESC', 'EST', 'FRM', 'LA', 'PBE', 'OA', 'OSUS' )
    and STVDEGC.STVDEGC_CODE not in ('AAS')
        and exists(
        select *
        from SFRSTCR SFRSTCR
        where SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
        and SFRSTCR.SFRSTCR_RSTS_CODE in ('RE','RW')
    )
    --and STVTERM.STVTERM_ACYR_CODE > to_date(SGBSTDN.SGBSTDN_EXP_GRAD_DATE, 'YYYY') --to_date(STVTERM.STVTERM_ACYR_CODE, 'yyyy')
    and to_char(SGBSTDN.SGBSTDN_EXP_GRAD_DATE, 'MM/DD/YYYY') <= ('8/31/' ||  STVTERM.STVTERM_ACYR_CODE)
      --yeah that does not it
    and STVTERM.STVTERM_ACYR_CODE >= to_char(SGBSTDN.SGBSTDN_EXP_GRAD_DATE, 'yyyy')
    and to_char(SGBSTDN.SGBSTDN_EXP_GRAD_DATE, 'MM/YYYY') not in (12 ||'/' || STVTERM.STVTERM_ACYR_CODE)
--$addfilter

--$beginorder

order by
      SHRDGMR.SHRDGMR_GRAD_DATE, SGBSTDN_EXP_GRAD_dATE, SGBSTDN.SGBSTDN_DEPT_CODE, SGBSTDN.SGBSTDN_MAJR_CODE_1, SPRIDEN.SPRIDEN_SEARCH_LAST_NAME, SPRIDEN.SPRIDEN_FIRST_NAME
      
/* [CRAZY NOTES]
uh param_graduation_year_select
where(mf i have no clues)
         stvterm_fa_proc_yr => to_char(SGBSTDN.SGBSTDN_EXP_GRAD_DATE,yyyy, 'dd-mm-yyyy')
Compiler instructions:
all undergraduate students (must be active and registered in 1+ courses)
    - discludes undergraduate students pursuiing AAS degree
    
expected graduation year is in selected year (graduated fall term or is expected)
    
student major is in preselected departments (see query code)    
outputs:
- expected.actual grad dates
- cummulative hours
*/
