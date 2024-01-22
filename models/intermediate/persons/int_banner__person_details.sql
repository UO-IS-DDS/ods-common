with banner_person_details as (

  select * from {{ ref('stg_banner__saturn__spbpers') }}

),

-- relationships_int_banner__person_details_internal_banner_id__internal_banner_id__ref_int_banner__entities__filtered_to__person
test_clean as (
     
  select *
  from banner_person_details t1
  -- failed test sql
  where t1.internal_banner_id in (
                                  select t2.internal_banner_id
                                  from {{ ref('cln_int_banner__entities__filtered_to__persons') }} t2
                                 )
)

select *,
       {{ dbt_utils.generate_surrogate_key(
            ['internal_banner_id']) }}           as ods_surrogate_key  
from test_clean