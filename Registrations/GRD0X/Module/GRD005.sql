SFRSTCR.SFRSTCR_TERM_CODE < STVTERM.STVTERM_CODE
and SFRSTCR_GRDE_CODE in ('U', 'UAU', 'I', 'IF')

order by
    SPRIDEN.SPRIDEN_LAST_NAME, SPRIDEN.SPRIDEN_FIRST_NAME, SSBSECT.SSBSECT_SUBJ_CODE, SSBSECT.SSBSECT_CRSE_NUMB
