exists(
    select * 

    from SHRDGMR
    
    where SHRDGMR.SHRDGMR_PIDM = SPRIDEN.SPRIDEN_PIDM
    and SHRDGMR.SHRDGMR_COLL_CODE_1 in ('SU')
    and SHRDGMR.SHRDGMR_MAJR_CODE_CONC_1 is not null
    and SHRDGMR.SHRDGMR_TERM_CODE_GRAD = STVTERM.STVTERM_CODE
)

order by 
    STVDEGC.STVDEGC_CODE, SPRIDEN.SPRIDEN_LAST_NAME, SPRIDEN.SPRIDEN_FIRST_NAME
