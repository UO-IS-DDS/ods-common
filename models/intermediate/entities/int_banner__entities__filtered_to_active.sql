with banner_entities as (

  select * from {{ ref('stg_banner__saturn__spriden') }}

),

filter_to_active as (

  select 
    
  -- banner_entities
  {{ dbt_utils.star(from=ref('stg_banner__saturn__spriden'),
                    relation_alias='banner_entities',
                    except=["change_ind"]) }}

  from banner_entities
  where change_ind = 'A'

),

-- unique_int_banner__entities__filter_to_active_banner_id
test_clean as (

  select *
  from filter_to_active t1
  -- failed test sql
  where not exists (
                    select 
                    
                           t2.banner_id as unique_field,
                           count(*) as n_records
                           
                    from filter_to_active t2
                    where t2.banner_id is not null
                      and t2.banner_id = t1.banner_id
                    group by t2.banner_id
                    having count(*) > 1
                   )
                     
)

select *,
       {{ dbt_utils.generate_surrogate_key(
            ['internal_banner_id']) }}           as ods_surrogate_key 
from test_clean