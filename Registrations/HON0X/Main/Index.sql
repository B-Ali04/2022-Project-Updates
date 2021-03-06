select
    SPRIDEN.SPRIDEN_ID Banner_ID,
    SPRIDEN.SPRIDEN_LAST_NAME Last_Name,
    SPRIDEN.SPRIDEN_FIRST_NAME First_Name,
    STVCLAS.STVCLAS_DESC Student_Class,
    STVMAJR.STVMAJR_DESC Program_of_Study,
    STVDEGC.STVDEGC_CODE Degree_Program,
    SGBSTDN.SGBSTDN_STYP_CODE Reg_Type,
    SGBSTDN.SGBSTDN_STST_CODE STST_CODE,
    SGBSTDN.SGBSTDN_EXP_GRAD_DATE Exp_Grad_Date,
    case
        when SGRSATT.SGRSATT_ATTS_CODE in ('LHON','UHON', 'HONR') then 'Honors Student'
        else ''
    end Honors

from
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = :parm_term_code_select.STVTERM_CODE

    join GORADID GORADID on GORADID.GORADID_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GORADID.GORADID_ADID_CODE = 'SUID'

    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SGBSTDN.SGBSTDN_STST_CODE = 'AS'
        and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
        and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)

    join STVMAJR STVMAJR on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1

    join STVDEGC STVDEGC on STVDEGC.STVDEGC_CODE = SGBSTDN.SGBSTDN_DEGC_CODE_1

    join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, SGBSTDN.SGBSTDN_TERM_CODE_EFF)

    join SGRSATT SGRSATT on SGRSATT.SGRSATT_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGRSATT.SGRSATT_TERM_CODE_EFF = STVTERM.STVTERM_CODE
         and SGRSATT.SGRSATT_ATTS_CODE in ('LHON','UHON', 'HONR')

where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
--$addfilter


--$beginorder

order by
    SPRIDEN.SPRIDEN_LAST_NAME

--$endorder