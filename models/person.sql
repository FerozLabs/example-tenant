-- Maps the source EHR patients table to the canonical person entity.
-- One row per patient; deceased patients are retained (death is tracked elsewhere).

with source as (
    select *
    from {{ source('ehr', 'patients') }}
)

select
    -- Surrogate key: pat_id is already an integer, pass through directly.
    pat_id::integer                                      as person_id,

    -- Sex-at-birth encoded as a concept ID.
    -- M/m/male variants → 8507, F/f/female variants → 8532, anything else → 0.
    case
        when sex in ('M', 'm', 'male', 'Male', 'MALE')         then 8507
        when sex in ('F', 'f', 'female', 'Female', 'FEMALE')   then 8532
        else 0  -- covers 'U', NULL, or any unrecognised value
    end                                                  as gender_concept_id,

    -- Year, month, and day extracted from the date-of-birth column.
    extract(year  from dob)::integer                     as year_of_birth,
    extract(month from dob)::integer                     as month_of_birth,
    extract(day   from dob)::integer                     as day_of_birth,

    -- No race or ethnicity column exists in the source; default to 0 (UNKNOWN).
    0                                                    as race_concept_id,
    0                                                    as ethnicity_concept_id,

    -- Source natural identifier preserved verbatim for traceability.
    mrn                                                  as person_source_value,

    -- Original sex token preserved for audit.
    sex                                                  as gender_source_value

from source
