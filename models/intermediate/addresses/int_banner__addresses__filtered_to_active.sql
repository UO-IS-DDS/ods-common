with 

banner_addresses as (select * from {{ ref('stg_banner__saturn__spraddr') }}),

active_addresses as (

  select 

    {{ dbt_utils.star(from=ref('stg_banner__saturn__spraddr'),
                      relation_alias='banner_addresses',
                      except=["is_active"]) }}

  from banner_addresses
  where is_active = 'Y'

),

-- not_null_int_banner__addresses__filtered_to_active_address_line_1
-- relationships_int_banner__addresses__filtered_to_active_internal_banner_id__internal_banner_id__ref_int_banner__entities__filtered_to_active
-- relationships_int_banner__addresses__filtered_to_active_state_code__state_code__ref_int_banner__address_state_types
test_clean as (

  select *
  from active_addresses t1
  -- failed test sql
  where address_line_1 is not null
    and t1.internal_banner_id in (
                                  select t2.internal_banner_id
                                  from {{ ref('cln_banner__entities__filtered_to_active') }} t2
                                 )
    and t1.state_code in (
                          select t3.state_code
                          from {{ ref('cln_banner__address_state_types') }} t3
                         )
)

select *,
       {{ dbt_utils.generate_surrogate_key(
            ['internal_banner_id',
             'address_type_code',
             'address_seqno']) }}           as ods_surrogate_key 
from test_clean