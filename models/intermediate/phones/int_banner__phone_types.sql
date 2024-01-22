with banner_phone_types as (

    select * from {{ ref('stg_banner__saturn__stvtele') }}

)

select *,
       {{ dbt_utils.generate_surrogate_key(
            ['phone_type_code']) }}           as ods_surrogate_key
from banner_phone_types 
