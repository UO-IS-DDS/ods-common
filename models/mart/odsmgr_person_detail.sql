with 

dim_person as (select * from {{ ref('dim_persons') }}),

final as (
    
  select 
    
    -- dim_person (driver)
    internal_banner_id                    as person_uid,
    banner_id                             as "ID", 
    last_name                             as last_name,
    preferred_first_name                  as first_name,
    middle_initial                        as middle_initial,
    is_confidential                       as confidentiality_ind
 
  from dim_person

)

select *,
       {{ dbt_utils.generate_surrogate_key(
            ['ID']) }}             as ods_surrogate_key 
from final