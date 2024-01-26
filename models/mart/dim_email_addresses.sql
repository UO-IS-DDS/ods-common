with 

banner_email_addresses     as (select * from {{ ref('int_banner__email_addresses__filtered_to_active') }}),

banner_email_address_types as (select * from {{ ref('int_banner__email_address_types') }}),

emails_and_type_desc as (

  select 

  -- banner_email_addresses (driver)
  {{ dbt_utils.star(from=ref('int_banner__email_addresses__filtered_to_active'),
                    relation_alias='banner_email_addresses',
                    except=["ods_surrogate_key"]) }},

   -- banner_email_address_types
  {{ dbt_utils.star(from=ref('int_banner__email_address_types'),
                    relation_alias='banner_email_address_types',
                    except=["ods_surrogate_key",
                            "email_type_code"]) }}

  from banner_email_addresses
  left join banner_email_address_types 
    on banner_email_address_types.email_type_code = 
           banner_email_addresses.email_type_code

)

select *,
       {{ dbt_utils.generate_surrogate_key(
            ['internal_banner_id',
             'email_type_code',
             'email_address']) }}           as ods_surrogate_key 
from emails_and_type_desc