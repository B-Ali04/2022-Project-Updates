(
    SGBSTDN.SGBSTDN_STYP_CODE in ('T', 'F', 'U','C')

    and(
        not exists(
            select *

            from SFRSTCR SFRSTCR

            where SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
            and SFRSTCR.SFRSTCR_RSTS_CODE = 'RE'
        )
    )
)
