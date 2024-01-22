with banner_address_nation_types as (

    select * from {{ ref('stg_banner__saturn__stvnatn') }}

)

select *,
       {{ dbt_utils.generate_surrogate_key(
            ['nation_code']) }}           as ods_surrogate_key
from banner_address_nation_types 
