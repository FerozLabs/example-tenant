-- Equality test: asserts that the person model output matches the expected seed row-for-row.
-- Returns rows that are in one set but not the other; a passing test returns zero rows.

with actual as (
    select
        person_id,
        gender_concept_id,
        year_of_birth,
        month_of_birth,
        day_of_birth,
        race_concept_id,
        ethnicity_concept_id,
        person_source_value,
        gender_source_value
    from {{ ref('person') }}
),

expected as (
    select
        person_id,
        gender_concept_id,
        year_of_birth,
        month_of_birth,
        day_of_birth,
        race_concept_id,
        ethnicity_concept_id,
        person_source_value,
        gender_source_value
    from {{ ref('person_expected') }}
),

in_actual_not_expected as (
    select * from actual
    except
    select * from expected
),

in_expected_not_actual as (
    select * from expected
    except
    select * from actual
)

select * from in_actual_not_expected
union all
select * from in_expected_not_actual
