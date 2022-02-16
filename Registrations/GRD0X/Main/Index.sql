select
    SPRIDEN.SPRIDEN_ID BANNER_ID,
    SPRIDEN_LAST_NAME Last_Name,
    SPRIDEN_FIRST_NAME First_Name,
    GORADID.GORADID_ADDITIONAL_ID SUID,
    SGBSTDN.SGBSTDN_STYP_CODE Reg_Type,
    STVCLAS.STVCLAS_CODE Class_LevL,
    STVMAJR.STVMAJR_DESC Program_of_Study,
    STVDEGC.STVDEGC_CODE Degree_Prog,
    SSBSECT.SSBSECT_SUBJ_CODE Course_Subj,
    SSBSECT.SSBSECT_CRSE_NUMB Course_Numb,
    SSBSECT.SSBSECT_SEQ_NUMB Seq_Numb,
    SFRSTCR.SFRSTCR_GRDE_CODE Letter_Grade,
    SFRSTCR.SFRSTCR_TERM_CODE Term_Code,
    STVCLAS.STVCLAS_SURROGATE_ID

from
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = :ListBox1.STVTERM_CODE

    join GORADID GORADID on GORADID.GORADID_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GORADID.GORADID_ADID_CODE = 'SUID'

    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)
        and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
        and SGBSTDN.SGBSTDN_STST_CODE = :DropDown1.STVSTST_CODE

    join SFRSTCR SFRSTCR on SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SFRSTCR.SFRSTCR_RSTS_CODE in ('RW', 'RE')

    left outer join SSBSECT SSBSECT on SSBSECT.SSBSECT_CRN = SFRSTCR.SFRSTCR_CRN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = SFRSTCR.SFRSTCR_TERM_CODE
    join STVMAJR STVMAJR on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1
    join STVDEGC STVDEGC on STVDEGC.STVDEGC_CODE = SGBSTDN.SGBSTDN_DEGC_CODE_1
    join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, SGBSTDN.SGBSTDN_TERM_CODE_EFF)

where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
    

--$addfilter
--$beginorder

order by
    SPRIDEN.SPRIDEN_LAST_NAME
--$endorder

