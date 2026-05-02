-- Asserts that the person model output exactly matches the person_expected seed.
-- The test passes when this query returns zero rows.

-- Rows in the model but not in expected
select
    'in model, not in expected' as discrepancy,
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

except

select
    'in model, not in expected',
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

union all

-- Rows in expected but not in the model
select
    'in expected, not in model' as discrepancy,
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

except

select
    'in expected, not in model',
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
