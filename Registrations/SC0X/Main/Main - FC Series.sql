select spriden_last_name, spriden_first_name, SGBSTDN.SGBSTDN_DEPT_CODE, SGBSTDN.SGBSTDN_MAJR_CODE_1, SSBSECT.SSBSECT_SUBJ_CODE, SSBSECT.SSBSECT_CRSE_NUMB, sfrstcr.sfrstcr_credit_hr

from SFRSTCR SFRSTCR

left outer join SPRIDEN SPRIDEN on SPRIDEN.SPRIDEN_PIDM = SFRSTCR.SFRSTCR_PIDM 
     and SPRIDEN.SPRIDEN_CHANGE_IND is null
     and SPRIDEN.SPRIDEN_NTYP_CODE is null

left outer join SSBSECT SSBSECT on SSBSECT.SSBSECT_CRN = SFRSTCR.SFRSTCR_CRN
     and SSBSECT.SSBSECT_TERM_CODE = SFRSTCR.SFRSTCR_TERM_CODE

left outer join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SFRSTCR.SFRSTCR_PIDM          
     and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, SFRSTCR.SFRSTCR_TERM_CODE)
where 
     SFRSTCR.SFRSTCR_TERM_CODE = 202220
     and SFRSTCR.SFRSTCR_RSTS_CODE = 'RE'
     and ssbsect_gmod_code = 'Y'

order by SGBSTDN.SGBSTDN_DEPT_CODE, SGBSTDN_MAJR_CODE_1, SSBSECT.SSBSECT_SUBJ_CODE, SSBSECT.SSBSECT_CRSE_NUMB
