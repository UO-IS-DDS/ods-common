with 

banner_addresses         as (select * from {{ ref('int_banner__addresses__filtered_to_active') }}),

banner_address_types     as (select * from {{ ref('int_banner__address_types') }}),

banner_address_states    as (select * from {{ ref('int_banner__address_state_types') }}),

banner_address_nations   as (select * from {{ ref('int_banner__address_nation_types') }}),

addresses_and_type_descs as (

  select 

  -- banner_addresses (driver)
  {{ dbt_utils.star(from=ref('int_banner__addresses__filtered_to_active'),
                    relation_alias='banner_addresses',
                    except=["ods_surrogate_key"]) }},

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

)

select *,
       {{ dbt_utils.generate_surrogate_key(
            ['internal_banner_id',
             'address_type_code',
             'address_seqno']) }}           as ods_surrogate_key 
from addresses_and_type_descs