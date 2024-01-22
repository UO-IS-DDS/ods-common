with banner__email_addresses as (

  select * from {{ ref('int_banner__email_addresses__filtered_to_active') }}

),


{%- set email_type_codes = ['uo'] -%}
-- ^ Add more as requested
email_addresses__pivoted_to_entity as (

  select

    internal_banner_id,
    {% for email_type_code in email_type_codes -%}
         
      max(case when email_type_code = upper('{{ email_type_code }}') then email_address end) as {{ email_type_code }}_email_address,
      max(case when email_type_code = upper('{{ email_type_code }}') then email_type_desc end) as {{ email_type_code }}_email_type_desc

      {%- if not loop.last %},{% endif %}
    {%- endfor %}

  from banner__email_addresses t1
  where updated_at = (
                      select max(t2.updated_at)
                      from banner__email_addresses t2
                      where t2.internal_banner_id = t1.internal_banner_id
                        and t2.email_type_code = t1.email_type_code
                     )
  group by internal_banner_id

)

select *,
       {{ dbt_utils.generate_surrogate_key(
            ['internal_banner_id']) }}           as ods_surrogate_key 
from email_addresses__pivoted_to_entity