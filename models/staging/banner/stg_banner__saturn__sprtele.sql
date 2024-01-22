with source as (

    select * from {{ source('banner__saturn', 'sprtele') }}

),

renamed as (

    select
        sprtele_pidm                      as internal_banner_id,
        sprtele_seqno                     as phone_seqno,
        sprtele_tele_code                 as phone_type_code,
        sprtele_activity_date             as updated_at,
        sprtele_phone_area                as phone_area,
        sprtele_phone_number              as phone_number,
        sprtele_phone_ext                 as phone_ext,
        case
          when sprtele_status_ind = 'I'
            then 'N'
          else 'Y'
        end                               as is_active,
        COALESCE(sprtele_unlist_ind, 'N') as is_unlisted,
        sprtele_comment                   as phone_comment,
        sprtele_intl_access               as intl_access,
        sprtele_ctry_code_phone           as phone_country_code

    from source

)

select * from renamed
-- Unused Fields --
        /*
        sprtele_atyp_code,
        sprtele_addr_seqno,
        sprtele_primary_ind,
        sprtele_data_origin,
        sprtele_user_id,
        sprtele_surrogate_id,
        sprtele_version,
        sprtele_vpdi_code
        */