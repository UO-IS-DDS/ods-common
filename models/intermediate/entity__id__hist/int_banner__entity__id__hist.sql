with banner_entities as (

  select * from {{ ref('stg_banner__saturn__spriden') }}

),

banner_active_entities as (

  select * from {{ ref('int_banner__entities__filtered_to_active') }}

),

banner_inactive_entity_ids as (

  select * 
  from banner_entities
  where change_ind = 'I'

),

curr_and_hist_banner_entity_ids as (

  select 

    'Y'                       as is_active,
    banner_id                 as banner_id,
    updated_at                as updated_at,
    internal_banner_id        as internal_banner_id

  from banner_active_entities

  union

  select 
   
    'N'                          as is_active,
    -- Inactive Banner entity ID
    t1.banner_id                 as banner_id,
    t1.updated_at                as updated_at,
    -- Active Banner entity details
    t2.internal_banner_id        as internal_banner_id

  from banner_inactive_entity_ids t1
  join banner_active_entities   t2
    on t2.internal_banner_id = t1.internal_banner_id

),

-- unique_int_banner__entity__id__hist_ods_surrogate_key
test_clean as (

  select *
  from curr_and_hist_banner_entity_ids
  -- failed test sql
  where not exists (
                    select 
                          
                           banner_id,
                           updated_at,
                           count(*) as n_records
                           
                    from curr_and_hist_banner_entity_ids
                    group by banner_id,
                             updated_at
                    having count(*) > 1
                   )

)

select *,
       {{ dbt_utils.generate_surrogate_key(
            ['banner_id',
             'updated_at']) }}           as ods_surrogate_key 
from test_clean