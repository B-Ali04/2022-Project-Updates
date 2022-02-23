select
    SPRIDEN.SPRIDEN_ID Banner_ID, 
    SPRIDEN.SPRIDEN_LAST_NAME Last__Name,
    SPRIDEN.SPRIDEN_FIRST_NAME First_Name,
    f_format_name(SPRIDEN.SPRIDEN_PIDM, 'LF30') Full_Name,
    STVDEPT.STVDEPT_CODE Dept,
    STVMAJR.STVMAJR_DESC Program_of_Study, 

    trunc(SHRLGPA.SHRLGPA_GPA, 3) Cumlative_GPA,
    SHRDGMR.SHRDGMR_GRAD_DATE Degree_Post_Date,
    SGBSTDN.SGBSTDN_EXP_GRAD_DATE Expected_Grad_Date,
    SFRWDRL.SFRWDRL_EFF_WDRL_DATE Withdrawl_Date
    /* to coincide w/ legacy: 
    omit: degree program, student class, minor/conc
    might want to: sort by actual grad date, then expected, by GPA on the same plane
    */

from 
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = 202220
    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGBSTDN.SGBSTDN_LEVL_CODE = 'UG'
         and SGBSTDN.SGBSTDN_STST_CODE = 'AS'
         and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
         and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)

    left outer join GORADID GORADID on GORADID.GORADID_PIDM = SPRIDEN.SPRIDEN_PIDM
         and GORADID.GORADID_ADID_CODE = 'SUID'             

    left outer join SHRLGPA SHRLGPA on SHRLGPA.SHRLGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRLGPA.SHRLGPA_LEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE
         and SHRLGPA.SHRLGPA_GPA_TYPE_IND = 'I'

    left outer join SHRDGMR SHRDGMR on SHRDGMR.SHRDGMR_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SHRDGMR.SHRDGMR_TERM_CODE_GRAD = STVTERM.STVTERM_CODE
        and SHRDGMR.SHRDGMR_DEGS_CODE = 'GR'         

    left outer join SFRWDRL SFRWDRL on SFRWDRL.SFRWDRL_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SFRWDRL.SFRWDRL_TERM_CODE = (
             select max(SFRWDRL.SFRWDRL_TERM_CODE) 
             from SFRWDRL SFRWDRL2
             where SFRWDRL2.SFRWDRL_PIDM = SFRWDRL.SFRWDRL_PIDM
         )        
    left outer join STVDEGC STVDEGC on STVDEGC.STVDEGC_CODE = SGBSTDN.SGBSTDN_DEGC_CODE_1
    left outer join STVMAJR STVMAJR on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1
    left outer join STVDEPT STVDEPT on STVDEPT.STVDEPT_CODE = SGBSTDN.SGBSTDN_DEPT_CODE
where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
    and SGBSTDN.SGBSTDN_DEPT_CODE in ('CHEM', 'EFB', 'ERE', 'ESC', 'EST', 'FRM', 'LA', 'PBE', 'OA', 'OSUS' )
    
    and STVDEGC.STVDEGC_CODE not in ('AAS') 
    --this next clause is simply something we do a lot of, verifications
    -- essentially if it didn't register, regardless of condition, we're not going to see it
    and exists(
        select *

        from SFRSTCR

        where SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
    )

order by SHRLGPA.SHRLGPA_GPA desc, SHRDGMR.SHRDGMR_GRAD_DATE, SGBSTDN.SGBSTDN_EXP_GRAD_DATE, SFRWDRL.SFRWDRL_EFF_WDRL_DATE
--order by SHRDGMR.SHRDGMR_GRAD_DATE, SGBSTDN.SGBSTDN_EXP_GRAD_DATE, SFRWDRL.SFRWDRL_EFF_WDRL_DATE, SHRLGPA.SHRLGPA_GPA desc
