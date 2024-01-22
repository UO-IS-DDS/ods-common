with banner_phones as (

   select * from {{ ref('stg_banner__saturn__sprtele') }}

),

banner_phone_types as (

   select * from {{ ref('int_banner__phone_types') }}

),

phones_and_type_desc as (

  select 

  -- banner_phones (driver)
  {{ dbt_utils.star(from=ref('stg_banner__saturn__sprtele'),
                    relation_alias='banner_phones',
                    except=["is_active"]) }},

   -- banner_phone_types
  {{ dbt_utils.star(from=ref('int_banner__phone_types'),
                    relation_alias='banner_phone_types',
                    except=["ods_surrogate_key",
                            "phone_type_code"]) }}

  from banner_phones
  left join banner_phone_types 
    on banner_phone_types.phone_type_code = 
            banner_phones.phone_type_code
  where is_active = 'Y'

),

-- relationships_int_banner__phones__filtered_to_active_internal_banner_id__internal_banner_id__ref_int_banner__entities__filtered_to_active
test_clean as (

  select *
  from phones_and_type_desc t1
  -- failed test sql
  where t1.internal_banner_id in (
                                  select t2.internal_banner_id
                                  from {{ ref('int_banner__entities__filtered_to_active') }} t2
                                 )
)

select *,
       {{ dbt_utils.generate_surrogate_key(
            ['internal_banner_id',
             'phone_type_code',
             'phone_seqno']) }}           as ods_surrogate_key 
from test_clean