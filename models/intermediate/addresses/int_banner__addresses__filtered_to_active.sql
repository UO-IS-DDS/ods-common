with banner_addresses as (

   select * from {{ ref('stg_banner__saturn__spraddr') }}

),

banner_address_types as (

   select * from {{ ref('int_banner__address_types') }}

),

banner_address_states as (

   select * from {{ ref('int_banner__address_state_types') }}

),

banner_address_nations as (

   select * from {{ ref('int_banner__address_nation_types') }}

),

addresses_and_type_descs as (

  select 

  -- banner_addresses (driver)
  {{ dbt_utils.star(from=ref('stg_banner__saturn__spraddr'),
                    relation_alias='banner_addresses',
                    except=["is_active"]) }},

   -- banner_address_types
  {{ dbt_utils.star(from=ref('int_banner__address_types'),
                    relation_alias='banner_address_types',
                    except=["ods_surrogate_key",
                            "address_type_code"]) }},

   -- banner_address_states
  {{ dbt_utils.star(from=ref('int_banner__address_state_types'),
                    relation_alias='banner_address_states',
                    except=["ods_surrogate_key",
                            "state_code"]) }},

   -- banner_address_nations
  {{ dbt_utils.star(from=ref('int_banner__address_nation_types'),
                    relation_alias='banner_address_nations',
                    except=["ods_surrogate_key",
                            "nation_code"]) }}

  from banner_addresses
  left join banner_address_types 
    on banner_address_types.address_type_code = 
           banner_addresses.address_type_code
  left join banner_address_states 
    on banner_address_states.state_code = 
           banner_addresses.state_code
  left join banner_address_nations 
    on banner_address_nations.nation_code = 
           banner_addresses.nation_code
  where is_active = 'Y'

),
-- not_null_int_banner__addresses__filtered_to_active_address_line_1
-- relationships_int_banner__addresses__filtered_to_active_internal_banner_id__internal_banner_id__ref_int_banner__entities__filtered_to_active
test_clean as (

  select *
  from addresses_and_type_descs t1
  -- failed test sql
  where address_line_1 is not null
    and t1.internal_banner_id in (
                                  select t2.internal_banner_id
                                  from {{ ref('cln_int_banner__entities__filtered_to_active') }} t2
                                 )
)

select *,
       {{ dbt_utils.generate_surrogate_key(
            ['internal_banner_id',
             'address_type_code',
             'address_seqno']) }}           as ods_surrogate_key 
from test_clean