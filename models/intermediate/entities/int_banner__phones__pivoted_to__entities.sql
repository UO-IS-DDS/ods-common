with banner__phones as (

  select * from {{ ref('int_banner__phones__filtered_to_active') }}

),


{%- set phone_type_codes = ['ma', 'pr'] -%}
-- ^ Add more as requested
phones__pivoted_to_entity as (

  select

    internal_banner_id,
    {% for phone_type_code in phone_type_codes -%}
         
      max(case when phone_type_code = upper('{{ phone_type_code }}') then phone_area end) as {{ phone_type_code }}_phone_area,
      max(case when phone_type_code = upper('{{ phone_type_code }}') then phone_number end) as {{ phone_type_code }}_phone_number,
      max(case when phone_type_code = upper('{{ phone_type_code }}') then phone_ext end) as {{ phone_type_code }}_phone_ext,
      max(case when phone_type_code = upper('{{ phone_type_code }}') then intl_access end) as {{ phone_type_code }}_intl_access,
      max(case when phone_type_code = upper('{{ phone_type_code }}') then phone_type_desc end) as {{ phone_type_code }}_phone_type_desc


      {%- if not loop.last %},{% endif %}
    {%- endfor %}

  from banner__phones t1
  where updated_at = (
                      select max(t2.updated_at)
                      from banner__phones t2
                      where t2.internal_banner_id = t1.internal_banner_id
                        and t2.phone_type_code = t1.phone_type_code
                     )
  group by internal_banner_id

)

select *,
       {{ dbt_utils.generate_surrogate_key(
            ['internal_banner_id']) }}           as ods_surrogate_key 
from phones__pivoted_to_entity