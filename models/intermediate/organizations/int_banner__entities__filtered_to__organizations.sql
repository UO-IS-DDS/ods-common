with banner__active_entities as (

  select * from {{ ref('mart_entities') }}

),

filter_to_organization as (

  select 
        
  -- banner__active_entities
  {{ dbt_utils.star(from=ref('mart_entities'),
                    relation_alias='banner__active_entities',
                    except=["ods_surrogate_key",
                            "is_person",
                            "legal_first_name",
                            "middle_initial",
                            "organization_or_last_name"]) }},
  banner__active_entities.organization_or_last_name as organization_name
    
  from banner__active_entities
  where is_person = 'N'

)

select *,
       {{ dbt_utils.generate_surrogate_key(
            ['internal_banner_id']) }}           as ods_surrogate_key 
from filter_to_organization