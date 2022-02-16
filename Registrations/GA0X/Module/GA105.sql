(
    SARADAP_STYP_CODE in ('R', 'N', 'G')

    and (
        exists(
            select *

            from SFRSTCR SFRSTCR

            where SFRSTCR.SFRSTCR_TERM_CODE = SGBSTDN.SGBSTDN_TERM_CODE_EFF
                and SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
        )
    )
)