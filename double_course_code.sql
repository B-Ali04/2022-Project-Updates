select 
    SSBSECT.SSBSECT_SICAS_CAMP_COURSE_ID,
    SSBSECT.SSBSECT_SEQ_NUMB Seq_Numb,
    ssbsect.ssbsect_term_code,
    SSBSECT1.SSBSECT_SICAS_CAMP_COURSE_ID,
    SSBSECT1.SSBSECT_SEQ_NUMB Seq_Numb,
    ssbsect1.ssbsect_term_code
    
    from ssbsect ssbsect
    
    left outer join ssbsect ssbsect1 on ssbsect1.ssbsect_term_code != ssbsect.ssbsect_term_code
    
    where
         SSBSECT1.SSBSECT_SICAS_CAMP_COURSE_ID = SSBSECT.SSBSECT_SICAS_CAMP_COURSE_ID
         
    order by
          SSBSECT.SSBSECT_SICAS_CAMP_COURSE_ID         
