with banner__active_entities as (

  select * from {{ ref('mart_entities') }}

),

filter_to_person as (

  select 

  -- banner__active_entities
  {{ dbt_utils.star(from=ref('mart_entities'),
                    relation_alias='banner__active_entities',
                    except=["ods_surrogate_key",
                            "is_person",
                            "organization_or_last_name"]) }},
  banner__active_entities.organization_or_last_name as last_name
    
  from banner__active_entities    
  where is_person = 'Y'

)

select *,
       {{ dbt_utils.generate_surrogate_key(
            ['internal_banner_id']) }}           as ods_surrogate_key 
from filter_to_person