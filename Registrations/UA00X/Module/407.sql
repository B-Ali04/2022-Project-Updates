(
    SARADAP_STYP_CODE = 'F'

    or (
        SARADAP_STYP_CODE = 'T'
        and f_class_calc_fnc(SPRIDEN.SPRIDEN_PIDM,SARADAP.SARADAP_LEVL_CODE, STVTERM.STVTERM_CODE) = 'FR'
        )
    )