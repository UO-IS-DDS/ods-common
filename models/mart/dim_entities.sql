with banner_entities as (

  select * from {{ ref('int_banner__entities__filtered_to_active') }}

),

banner_entity_emails as (

  select * from {{ ref('int_banner__email_addresses__pivoted_to__entities') }}

),

banner_entity_phones as (

  select * from {{ ref('int_banner__phones__pivoted_to__entities') }}

),

banner_entity_addresses as (

  select * from {{ ref('int_banner__addresses__pivoted_to__entities') }}

),

final as (
    
  select 
    
  -- banner_entities (driver)
  {{ dbt_utils.star(from=ref('int_banner__entities__filtered_to_active'),
                    relation_alias='banner_entities',
                    except=["ods_surrogate_key", 
                            "updated_at"]) }},
  -- banner_entity_emails
  {{ dbt_utils.star(from=ref('int_banner__email_addresses__pivoted_to__entities'), 
                    relation_alias='banner_entity_emails',
                    except=["ods_surrogate_key",
                            "internal_banner_id"]) }},

  -- banner_entity_phones
  {{ dbt_utils.star(from=ref('int_banner__phones__pivoted_to__entities'), 
                    relation_alias='banner_entity_phones',
                    except=["ods_surrogate_key",
                            "internal_banner_id"]) }},

  -- banner_entity_addresses
  {{ dbt_utils.star(from=ref('int_banner__addresses__pivoted_to__entities'), 
                    relation_alias='banner_entity_addresses',
                    except=["ods_surrogate_key",
                            "internal_banner_id"]) }}


  from banner_entities
  left join banner_entity_emails
    on banner_entities.internal_banner_id = 
       banner_entity_emails.internal_banner_id
  left join banner_entity_phones
    on banner_entities.internal_banner_id = 
       banner_entity_phones.internal_banner_id
  left join banner_entity_addresses
    on banner_entities.internal_banner_id = 
       banner_entity_addresses.internal_banner_id
)

select *,
       {{ dbt_utils.generate_surrogate_key(
            ['internal_banner_id']) }}           as ods_surrogate_key 
from final