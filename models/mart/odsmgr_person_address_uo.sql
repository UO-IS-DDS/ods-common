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
    case
      when ma_address_line_1 is null
        then pr_address_line_1
      else ma_address_line_1
    end                                   as mapr_street_line1,
    case
      when ma_address_line_1 is null
        then pr_address_line_2
      else ma_address_line_2
    end                                   as mapr_street_line2,
    case
      when ma_address_line_1 is null
        then pr_address_line_3
      else ma_address_line_3
    end                                   as mapr_street_line3,
    case
      when ma_address_line_1 is null
        then pr_city
      else ma_city
    end                                   as mapr_city,
    case
      when ma_address_line_1 is null
        then pr_state_code
      else ma_state_code
    end                                   as mapr_state,
    case
      when ma_address_line_1 is null
        then pr_zip_code
      else ma_zip_code
    end                                   as mapr_zip,
    case
      when ma_address_line_1 is null
        then pr_nation_desc
      else ma_nation_desc
    end                                   as mapr_nation
 
  from dim_person

)

select *,
       {{ dbt_utils.generate_surrogate_key(
            ['ID']) }}             as ods_surrogate_key 
from final