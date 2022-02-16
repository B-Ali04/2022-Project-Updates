select
    SPRIDEN_LAST_NAME lNAME,
    SPRIDEN_FIRST_NAME FNAME,
    SPRIDEN.SPRIDEN_ID BANNERID,
    GORADID.GORADID_ADDITIONAL_ID SUID,
    SGBSTDN.SGBSTDN_STYP_CODE RegType,
    STVCLAS.STVCLAS_CODE ClassLvL,
    STVMAJR.STVMAJR_DESC ProgramOfStudy,
    SPBPERS.SPBPERS_BIRTH_DATE

from
    SPRIDEN SPRIDEN
    join GORADID GORADID on GORADID.GORADID_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GORADID.GORADID_ADID_CODE = 'SUID'

    join SPBPERS SPBPERS on SPBPERS.SPBPERS_PIDM = SPRIDEN.SPRIDEN_PIDM

    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM,:ListBox1.STVTERM_CODE)
        and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
        and SGBSTDN.SGBSTDN_STST_CODE = 'AS'
        and SGBSTDN.SGBSTDN_LEVL_CODE = 'UG'

    join STVMAJR STVMAJR on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1
    join STVDEGC STVDEGC on STVDEGC.STVDEGC_CODE = SGBSTDN.SGBSTDN_DEGC_CODE_1
    join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, SGBSTDN.SGBSTDN_TERM_CODE_EFF)

where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
    and SPBPERS.SPBPERS_BIRTH_DATE <=to_date(sysdate)-7665

order by
    SPRIDEN.SPRIDEN_LAST_NAME