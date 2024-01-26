with 

banner_phones      as (select * from {{ ref('int_banner__phones__filtered_to_active') }}),

banner_phone_types as (select * from {{ ref('int_banner__phone_types') }}),

phones_and_type_desc as (

  select 

  -- banner_phones (driver)
  {{ dbt_utils.star(from=ref('int_banner__phones__filtered_to_active'),
                    relation_alias='banner_phones',
                    except=["ods_surrogate_key"]) }},

   -- banner_phone_types
  {{ dbt_utils.star(from=ref('int_banner__phone_types'),
                    relation_alias='banner_phone_types',
                    except=["ods_surrogate_key",
                            "phone_type_code"]) }}

  from banner_phones
  left join banner_phone_types 
    on banner_phone_types.phone_type_code = 
            banner_phones.phone_type_code

)

select *,
       {{ dbt_utils.generate_surrogate_key(
            ['internal_banner_id',
             'phone_type_code',
             'phone_seqno']) }}           as ods_surrogate_key 
from phones_and_type_desc