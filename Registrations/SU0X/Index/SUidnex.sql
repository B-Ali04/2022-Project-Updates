/*    Collective Course Catalogue   */
select 
    SSBSECT.SSBSECT_SUBJ_CODE,
    SSBSECT.SSBSECT_CRSE_NUMB, 
    SSBSECT.SSBSECT_SEQ_NUMB, 
    --SHRTCKN.SHRTCKN_CRSE_TITLE,
    SSBSECT.SSBSECT_CAMP_CODE,
    SSBSECT.SSBSECT_REG_ONEUP,
    SSBSECT.SSBSECT_MAX_ENRL,
    SSBSECT.SSBSECT_ENRL,
    SSBSECT.SSBSECT_SEATS_AVAIL, 
    SSBSECT.SSBSECT_TOT_CREDIT_HRS,
    SSBSECT.SSBSECT_CENSUS_ENRL,
    SSBSECT.SSBSECT_GMOD_CODE

from
    SSBSECT SSBSECT

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = 202240

where
    SSBSECT.SSBSECT_TERM_CODE = STVTERM.STVTERM_CODE
    --and ((ssbsect_gmod_code not in ('Y')) or (ssbsect_gmod_code is null))
    --and ssbsect_gmod_code = 'Y'
order by 
      SSBSECT.SSBSECT_SUBJ_CODE, SSBSECT.SSBSECT_CRSE_NUMB
