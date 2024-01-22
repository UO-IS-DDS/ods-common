with source as (

    select * from {{ source('banner__saturn', 'spraddr') }}

),

renamed as (

    select
        spraddr_pidm                    as internal_banner_id,
        spraddr_atyp_code               as address_type_code,
        spraddr_seqno                   as address_seqno,
        spraddr_street_line1            as address_line_1,
        spraddr_street_line2            as address_line_2,
        spraddr_street_line3            as address_line_3,
        spraddr_city                    as city,
        spraddr_stat_code               as state_code,
        spraddr_zip                     as zip_code,
        spraddr_natn_code               as nation_code,
        case
          when spraddr_status_ind = 'I'
            then 'N'
          else 'Y'
        end                             as is_active,
        spraddr_activity_date           as updated_at

    from source

)

select * from renamed
-- Unused Fields --
        /*
        spraddr_from_date,
        spraddr_to_date,
        spraddr_cnty_code,
        spraddr_phone_area,
        spraddr_phone_number,
        spraddr_phone_ext,
        spraddr_user,
        spraddr_asrc_code,
        spraddr_validated_ind,
        spraddr_validated_date,
        spraddr_carrier_route,
        spraddr_delivery_point,
        spraddr_correction_digit,
        spraddr_gst_tax_id,
        spraddr_reviewed_ind,
        spraddr_reviewed_user,
        spraddr_data_origin,
        spraddr_ctry_code_phone,
        spraddr_house_number,
        spraddr_street_line4,
        spraddr_surrogate_id,
        spraddr_version,
        spraddr_user_id,
        spraddr_vpdi_code
        */