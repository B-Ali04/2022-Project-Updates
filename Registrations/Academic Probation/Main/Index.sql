Select
    SPRIDEN.SPRIDEN_ID Banner_ID,
    f_format_name(spriden_pidm, 'LF30') Student_Name,
    SPRIDEN.SPRIDEN_LAST_NAME Last_Name,
    SPRIDEN.SPRIDEN_FIRST_NAME First_Name,
    GORADID.GORADID_ADDITIONAL_ID SU_ID,
    STVCLAS.STVCLAS_CODE Class_Code,
    STVDEGC.STVDEGC_CODE Degree_Code,
    STVSTYP.STVSTYP_DESC Student_Type,
    f_format_name(SGRADVR.SGRADVR_ADVR_PIDM, 'LFMI') as Major_Prof_Advisor,
    SHRTGPA.SHRTGPA_HOURS_EARNED Semester_Hours_Earned,
    SHRTGPA.SHRTGPA_HOURS_ATTEMPTED Semester_Hours_Attempted,
    trunc(SHRTGPA.SHRTGPA_GPA,3) Semester_GPA,
    SHRLGPA.SHRLGPA_HOURS_EARNED Cumulative_Hours_Earned,
    SHRLGPA.SHRLGPA_HOURS_ATTEMPTED Cumulative_Hours_Attempted,
    trunc(SHRLGPA.SHRLGPA_GPA,3) Cumulative_GPA,

    SPRADDR.SPRADDR_STREET_LINE1 ||' '|| SPRADDR.SPRADDR_STREET_LINE2 Permanent_Address_1,
    SPRADDR.SPRADDR_CITY ||' '|| SPRADDR.SPRADDR_STAT_CODE ||' '|| substr(SPRADDR.SPRADDR_ZIP,1,12) Permanent_Address_2,
    SPRADDR1.SPRADDR_STREET_LINE1 ||' '|| SPRADDR1.SPRADDR_STREET_LINE2 Mailing_Address_1,
    SPRADDR1.SPRADDR_CITY ||' '|| SPRADDR1.SPRADDR_STAT_CODE ||' '|| substr(SPRADDR1.SPRADDR_ZIP,1,12) Mailing_Address_2,
    r.ASTD_CODE ASTD_Code,
    CASE
        when (((shrlgpa.shrlgpa_gpa < 2.0000) and (SGBSTDN.SGBSTDN_LEVL_CODE = 'UG'))
             or ((shrlgpa.shrlgpa_gpa < 3.0000) and (SGBSTDN.SGBSTDN_LEVL_CODE = 'GR'))) then 'Y'
        else null
    END Probation_Eligible,

    GOREMAL.GOREMAL_EMAIL_ADDRESS Email

from
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = :parm_term_code_select.STVTERM_CODE

    join SPBPERS SPBPERS on SPBPERS.SPBPERS_PIDM = SPRIDEN.SPRIDEN_PIDM

    left outer join GOREMAL GOREMAL on GOREMAL.GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GOREMAL.GOREMAL_EMAL_CODE = 'SU'
        and GOREMAL.GOREMAL_STATUS_IND = 'A'

    join GORADID GORADID on GORADID.GORADID_PIDM = SPRIDEN.SPRIDEN_PIDM
         and GORADID.GORADID_ADID_CODE = 'SUID'

    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)
        and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
        and SGBSTDN.SGBSTDN_STST_CODE in ('AS')

    join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, STVTERM.STVTERM_CODE)

    join STVDEPT STVDEPT on STVDEPT.STVDEPT_CODE = SGBSTDN.SGBSTDN_DEPT_CODE

    join STVDEGC STVDEGC on STVDEGC.STVDEGC_CODE = SGBSTDN.SGBSTDN_DEGC_CODE_1

    join STVMAJR STVMAJR on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1

    join STVSTYP STVSTYP on STVSTYP.STVSTYP_CODE = SGBSTDN.SGBSTDN_STYP_CODE

    left outer join REL_STUDENT_STANDING r on r.PIDM = SPRIDEN.SPRIDEN_PIDM
         and r.TERM_CODE <= STVTERM.STVTERM_CODE

    left outer join SHRLGPA SHRLGPA on SHRLGPA.SHRLGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRLGPA.SHRLGPA_LEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE
         and SHRLGPA.SHRLGPA_GPA_TYPE_IND = 'I'
         and SHRLGPA.SHRLGPA_GPA is not null

    left outer join SHRTGPA SHRTGPA on SHRTGPA.SHRTGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SHRTGPA.SHRTGPA_TERM_CODE = STVTERM.STVTERM_CODE
        and SHRTGPA.SHRTGPA_GPA_TYPE_IND = 'I'

    left outer join SPRADDR SPRADDR on SPRADDR.SPRADDR_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SPRADDR.SPRADDR_ATYP_CODE in ('PR')
        and SPRADDR.SPRADDR_STATUS_IND is null
        and SPRADDR_STREET_LINE1 is not null
        and SPRADDR.SPRADDR_VERSION = (
             select max(SPRADDR_VERSION)
             from SPRADDR SPRADDR1
             where SPRADDR1.SPRADDR_PIDM = SPRADDR.SPRADDR_PIDM
             and SPRADDR1.SPRADDR_ATYP_CODE in ('PR')
             and SPRADDR1.SPRADDR_STATUS_IND is null)
        and SPRADDR.SPRADDR_SURROGATE_ID = (
             select max(SPRADDR_SURROGATE_ID)
             from SPRADDR SPRADDR1
             where SPRADDR1.SPRADDR_PIDM = SPRADDR.SPRADDR_PIDM
             and SPRADDR1.SPRADDR_ATYP_CODE in ('PR')
             and SPRADDR1.SPRADDR_STATUS_IND is null)

    left outer join SPRADDR SPRADDR1 on SPRADDR1.SPRADDR_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SPRADDR1.SPRADDR_ATYP_CODE in ('MA')
        and SPRADDR1.SPRADDR_STATUS_IND is null
        and SPRADDR1.SPRADDR_STREET_LINE1 is not null
        and SPRADDR1.SPRADDR_VERSION = (
             select max(SPRADDR_VERSION)
             from SPRADDR SPRADDR2
             where SPRADDR2.SPRADDR_PIDM = SPRADDR1.SPRADDR_PIDM
             and SPRADDR2.SPRADDR_ATYP_CODE in ('MA')
             and SPRADDR2.SPRADDR_STATUS_IND is null)
        and SPRADDR1.SPRADDR_SURROGATE_ID = (
             select max(SPRADDR_SURROGATE_ID)
             from SPRADDR SPRADDR2
             where SPRADDR2.SPRADDR_PIDM = SPRADDR1.SPRADDR_PIDM
             and SPRADDR2.SPRADDR_ATYP_CODE in ('MA')
             and SPRADDR2.SPRADDR_STATUS_IND is null)

    left outer join SGRADVR SGRADVR on SGRADVR.SGRADVR_PIDM =  SPRIDEN.SPRIDEN_PIDM
        and SGRADVR.SGRADVR_ADVR_PIDM is not null
        and SGRADVR.SGRADVR_SURROGATE_ID = (
            select max(SGRADVR_SURROGATE_ID)
            from SGRADVR SGRADVR2
            where SGRADVR2.SGRADVR_PIDM = SGRADVR.SGRADVR_PIDM
            and SGRADVR2.SGRADVR_ADVR_PIDM is not null
            and SGRADVR2.SGRADVR_PRIM_IND = 'Y')
where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
    and exists(
        select *
        from SFRSTCR SFRSTCR
        where SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
        and SFRSTCR.SFRSTCR_RSTS_CODE in ('RE','RW')
    )

--$addfilter

--$beginorder

order by
        SPRIDEN.SPRIDEN_SEARCH_LAST_NAME
--$endorder