with banner_email_addresses as (

   select * from {{ ref('stg_banner__general__goremal') }}

),

banner_email_address_types as (

   select * from {{ ref('int_banner__email_address_types') }}

),

emails_and_type_desc as (

  select 

  -- banner_email_addresses (driver)
  {{ dbt_utils.star(from=ref('stg_banner__general__goremal'),
                    relation_alias='banner_email_addresses',
                    except=["is_active"]) }},

   -- banner_email_address_types
  {{ dbt_utils.star(from=ref('stg_banner__general__gtvemal'),
                    relation_alias='banner_email_address_types',
                    except=["email_type_code"]) }}

  from banner_email_addresses
  left join banner_email_address_types 
    on banner_email_address_types.email_type_code = 
           banner_email_addresses.email_type_code
  where is_active = 'Y'

),

-- relationships_int_banner__email_addresses__filtered_to_active_internal_banner_id__internal_banner_id__ref_int_banner__entities__filtered_to_active
test_clean as (

  select *
  from emails_and_type_desc t1
  -- failed test sql
  where t1.internal_banner_id in (
                                  select t2.internal_banner_id
                                  from {{ ref('cln_int_banner__entities__filtered_to_active') }} t2
                                 )

)

select *,
       {{ dbt_utils.generate_surrogate_key(
            ['internal_banner_id',
             'email_type_code',
             'email_address']) }}           as ods_surrogate_key 
from test_clean