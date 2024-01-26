with 

banner_phones as (select * from {{ ref('stg_banner__saturn__sprtele') }}),

active_phones as (

  select 

    {{ dbt_utils.star(from=ref('stg_banner__saturn__sprtele'),
                      relation_alias='banner_phones',
                      except=["is_active"]) }}

  from banner_phones
  where is_active = 'Y'

),

-- relationships_int_banner__phones__filtered_to_active_internal_banner_id__internal_banner_id__ref_int_banner__entities__filtered_to_active
test_clean as (

  select *
  from active_phones t1
  -- failed test sql
  where t1.internal_banner_id in (
                                  select t2.internal_banner_id
                                  from {{ ref('cln_int_banner__entities__filtered_to_active') }} t2
                                 )
)

select *,
       {{ dbt_utils.generate_surrogate_key(
            ['internal_banner_id',
             'phone_type_code',
             'phone_seqno']) }}           as ods_surrogate_key 
from test_clean