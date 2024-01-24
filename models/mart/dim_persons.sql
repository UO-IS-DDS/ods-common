with banner_persons as (

  select * from {{ ref('int_banner__entities__filtered_to__persons') }}

),

banner_person_details as (

  select * from {{ ref('int_banner__person_details') }}

),

final as (
    
  select 
    
  -- banner_persons (driver)
  {{ dbt_utils.star(from=ref('int_banner__entities__filtered_to__persons'),
                    relation_alias='banner_persons',
                    except=["ods_surrogate_key"]) }},
  -- banner_person_details
  {{ dbt_utils.star(from=ref('int_banner__person_details'),
                    relation_alias='banner_person_details',
                    except=["ods_surrogate_key",
                            "internal_banner_id"]) }}

  from banner_persons
  left join banner_person_details
    on banner_person_details.internal_banner_id = 
              banner_persons.internal_banner_id
)

select *,
       {{ dbt_utils.generate_surrogate_key(
            ['internal_banner_id']) }}           as ods_surrogate_key 
from final