exists(
    select *

    from SGRSATT SGRSATT

    where SGRSATT.SGRSATT_PIDM = SPRIDEN.SPRIDEN_PIDM
          and SGRSATT.SGRSATT_ATTS_CODE in ('CNCL', 'CNCE', 'CNCC','CNCM', 'CNCX','CNCN','CNCO')
)