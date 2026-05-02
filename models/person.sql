-- Maps the source EHR patients table to the canonical person entity.
-- One row per patient; deceased patients are retained (death is tracked elsewhere).

with source as (
    select *
    from {{ source('ehr', 'patients') }}
)

select
    -- Identifier: pat_id is already an integer surrogate key; pass through directly.
    pat_id::integer                                      as person_id,

    -- Sex-at-birth encoded as a concept ID.
    -- M/m/male variants → 8507, F/f/female variants → 8532, anything else → 0.
    case
        when sex in ('M', 'm', 'male', 'Male', 'MALE')         then 8507
        when sex in ('F', 'f', 'female', 'Female', 'FEMALE')   then 8532
        else 0
    end                                                  as gender_concept_id,

    -- Date-of-birth components extracted from the dob column.
    extract(year  from dob)::integer                     as year_of_birth,
    extract(month from dob)::integer                     as month_of_birth,
    extract(day   from dob)::integer                     as day_of_birth,

    -- Race and ethnicity: source does not carry these fields; default to 0 (UNKNOWN).
    0                                                    as race_concept_id,
    0                                                    as ethnicity_concept_id,

    -- Source-value audit columns for traceability.
    mrn                                                  as person_source_value,
    sex                                                  as gender_source_value

from source
