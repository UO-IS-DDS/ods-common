with banner__addresses as (

  select * from {{ ref('int_banner__addresses__filtered_to_active') }}

),


{%- set address_type_codes = ['ma', 'pr'] -%}
-- ^ Add more as requested
addresses__pivoted_to_entity as (

  select

    internal_banner_id,
    {% for address_type_code in address_type_codes -%}
         
      max(case when address_type_code = upper('{{ address_type_code }}') then address_line_1 end) as {{ address_type_code }}_address_line_1,
      max(case when address_type_code = upper('{{ address_type_code }}') then address_line_2 end) as {{ address_type_code }}_address_line_2,
      max(case when address_type_code = upper('{{ address_type_code }}') then address_line_3 end) as {{ address_type_code }}_address_line_3,
      max(case when address_type_code = upper('{{ address_type_code }}') then city end) as {{ address_type_code }}_city,
      max(case when address_type_code = upper('{{ address_type_code }}') then state_code end) as {{ address_type_code }}_state_code,
      max(case when address_type_code = upper('{{ address_type_code }}') then state_desc end) as {{ address_type_code }}_state_desc,
      max(case when address_type_code = upper('{{ address_type_code }}') then zip_code end) as {{ address_type_code }}_zip_code,
      max(case when address_type_code = upper('{{ address_type_code }}') then nation_code end) as {{ address_type_code }}_nation_code,
      max(case when address_type_code = upper('{{ address_type_code }}') then nation_desc end) as {{ address_type_code }}_nation_desc

      {%- if not loop.last %},{% endif %}
    {%- endfor %}

  from banner__addresses t1
  where address_seqno = (
                          select max(t2.address_seqno)
                          from banner__addresses t2
                          where t2.internal_banner_id = t1.internal_banner_id
                            and t2.address_type_code = t1.address_type_code
                        )
  group by internal_banner_id

)

select *,
       {{ dbt_utils.generate_surrogate_key(
            ['internal_banner_id']) }}           as ods_surrogate_key 
from addresses__pivoted_to_entity