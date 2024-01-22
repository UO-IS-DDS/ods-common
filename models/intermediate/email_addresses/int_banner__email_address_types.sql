with banner_email_address_types as (

    select * from {{ ref('stg_banner__general__gtvemal') }}

)

select *,
       {{ dbt_utils.generate_surrogate_key(
            ['email_type_code']) }}           as ods_surrogate_key
from banner_email_address_types 
