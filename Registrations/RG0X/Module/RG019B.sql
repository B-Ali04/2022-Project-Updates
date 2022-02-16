(
    SGBSTDN.SGBSTDN_STYP_CODE in ('T', 'F')

    and(
        exists(
            select *

            from SGBSTDN SGBSTDN

            where SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
                and SGBSTDN.SGBSTDN_MAJR_CODE_1 in ('EHS')
                and SGBSTDN.SGBSTDN_TERM_CODE_EFF < fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)
        )
    )
)