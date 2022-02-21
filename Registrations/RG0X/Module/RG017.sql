and exists(
    select * 

    from SGRVETN SGRVETN
    
    where SPRIDEN.SPRIDEN_PIDM = SGRVETN.SGRVETN_PIDM
    and SGRVETN.SGRVETN_TERM_CODE_VA = (
        select max(SGRVETN_TERM_CODE_VA) 
        from SGRVETN SGRVETN2
        where SGRVETN.SGRVETN_PIDM = SGRVETN2.SGRVETN_PIDM
    )
)

--$addfilter

--$beginorder

order by
    SPRIDEN.SPRIDEN_SEARCH_LAST_NAME
