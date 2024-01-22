with banner_address_types as (

    select * from {{ ref('stg_banner__saturn__stvatyp') }}

)

select *,
       {{ dbt_utils.generate_surrogate_key(
            ['address_type_code']) }}           as ods_surrogate_key
from banner_address_types 
