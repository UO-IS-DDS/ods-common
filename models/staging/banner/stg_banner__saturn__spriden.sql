with source as (

    select * from {{ source('banner__saturn', 'spriden') }}

),

renamed as (

    select
        spriden_pidm                     as internal_banner_id,
        spriden_id                       as banner_id,
        spriden_last_name                as organization_or_last_name,
        spriden_first_name               as legal_first_name,
        substr(spriden_mi,1,1)           as middle_initial,
        COALESCE(spriden_change_ind,'A') as change_ind,
        case 
          when spriden_entity_ind = 'P' 
            then 'Y'
          else 'N'                     
        end                              as is_person,
        spriden_activity_date            as updated_at

    from source

)

select * from renamed
-- Unused Fields --
        /*
        spriden_user,
        spriden_origin,
        spriden_search_last_name,
        spriden_search_first_name,
        spriden_search_mi,
        spriden_soundex_last_name,
        spriden_soundex_first_name,
        spriden_ntyp_code,
        spriden_create_user,
        spriden_create_date,
        spriden_data_origin,
        spriden_create_fdmn_code,
        spriden_surname_prefix,
        spriden_surrogate_id,
        spriden_version,
        spriden_user_id,
        spriden_vpdi_code
        */