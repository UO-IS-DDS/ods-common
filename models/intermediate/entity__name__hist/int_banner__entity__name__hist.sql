with banner_entities as (

  select * from {{ ref('stg_banner__saturn__spriden') }}

),

banner_active_entities as (

  select * from {{ ref('int_banner__entities__filtered_to_active') }}

),

banner_inactive_entity_names as (

  select * 
  from banner_entities
  where change_ind = 'N'

),

curr_and_hist_banner_entity_names as (

  select 
    
    'Y'                       as is_active,
    organization_or_last_name as organization_or_last_name,
    legal_first_name          as legal_first_name,
    middle_initial            as middle_initial,
    updated_at                as updated_at,
    internal_banner_id        as internal_banner_id,
    is_person                 as is_person

  from banner_active_entities

  union

  select 

    'N'                          as is_active,
    -- Inactive Banner entity names
    t1.organization_or_last_name as organization_or_last_name,
    t1.legal_first_name          as legal_first_name,
    t1.middle_initial            as middle_initial,
    t1.updated_at                as updated_at,
    -- Active Banner entity details
    t2.internal_banner_id        as internal_banner_id,
    t2.is_person                 as is_person

  from banner_inactive_entity_names t1
  join banner_active_entities   t2
    on t2.internal_banner_id = t1.internal_banner_id

),

-- unique_int_banner__entity_name__hist_ods_surrogate_key
test_clean as (
 
  select *
  from curr_and_hist_banner_entity_names
  -- failed test sql
  where not exists (
                    select 

                           organization_or_last_name,
                           legal_first_name,
                           middle_initial,
                           updated_at,
                           count(*) as n_records

                    from curr_and_hist_banner_entity_names
                    group by organization_or_last_name,
                             legal_first_name,
                             middle_initial,
                             updated_at
                    having count(*) > 1
                   )

)

select *,
       {{ dbt_utils.generate_surrogate_key(
            ['organization_or_last_name',
             'legal_first_name',
             'middle_initial',
             'updated_at'
             ]) }}           as ods_surrogate_key 
from test_clean