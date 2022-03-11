select 
SSBSECT.SSBSECT_SUBJ_CODE Course_Subj,
    SSBSECT.SSBSECT_CRSE_NUMB Course_Numb,
    SSBSECT.SSBSECT_SEQ_NUMB Seq_Numb,
    ssbsect.ssbsect_term_code,
    SSBSECT1.SSBSECT_SUBJ_CODE Course_Subj,
    SSBSECT1.SSBSECT_CRSE_NUMB Course_Numb,
    SSBSECT1.SSBSECT_SEQ_NUMB Seq_Numb,
    ssbsect1.ssbsect_term_code
    
    from ssbsect ssbsect
    
    left outer join ssbsect ssbsect1 on ssbsect1.ssbsect_term_code != ssbsect.ssbsect_term_code
    
    where 
    ssbsect1.ssbsect_subj_code = ssbsect.ssbsect_subj_code
    and ssbsect1.ssbsect_crse_numb = ssbsect.ssbsect_crse_numb
