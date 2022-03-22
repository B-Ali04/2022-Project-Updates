select
f_format_name(spriden_pidm, 'LFMI') Name,
spriden.spriden_id Banner_ID,
SFRSTCR.SFRSTCR_PIDM,
SFRSTCR.SFRSTCR_CRN,
SSBSECT.SSBSECT_SUBJ_CODE,
SSBSECT.SSBSECT_CRSE_NUMB,
SSBSECT.SSBSECT_TERM_CODE,
SSBSECT.SSBSECT_CRN,
r.*

from 
SPRIDEN SPRIDEN

join STVTERM STVTERM on STVTERM.STVTERM_CODE = 202220

left outer join SFRSTCR SFRSTCR on SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SFRSTCR.SFRSTCR_RSTS_CODE like 'R%'
         and SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
         
left outer join SSBSECT SSBSECT on SSBSECT.SSBSECT_CRN = SFRSTCR.SFRSTCR_CRN
     and SSBSECT.SSBSECT_TERM_CODE=  SFRSTCR.SFRSTCR_TERM_CODE

join REL_STUDENT_ACAD_HISTORY r on r.PIDM = SPRIDEN.SPRIDEN_PIDM
    and r.term_code != SFRSTCR.SFRSTCR_TERM_CODE
    and r.SUBJ_CODE = SSBSECT.SSBSECT_SUBJ_CODE
    and r.CRSE_NUMB = SSBSECT.SSBSECT_CRSE_NUMB

where 
spriden.spriden_ntyp_code is null
and spriden.spriden_change_ind is null
and sFRSTCR.SFRSTCR_GRDE_CODE = 'F'

order by spriden_search_last_name, r.term_code desc, ssbsect.ssbsect_subj_code, ssbsect.ssbsect_crse_numb
