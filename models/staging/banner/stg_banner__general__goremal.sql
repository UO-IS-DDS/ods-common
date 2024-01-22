with source as (

    select * from {{ source('banner__general', 'goremal') }}

),

renamed as (

    select
        goremal_pidm                        as internal_banner_id,
        goremal_emal_code                   as email_type_code,
        goremal_email_address               as email_address,
        case 
          when goremal_status_ind = 'A'
            then 'Y'
          else 'N'
         end                                as is_active,
        goremal_activity_date               as updated_at

    from source

)

select * from renamed
-- Unused Fields --
        /*
        goremal_preferred_ind,
        goremal_user_id,
        goremal_comment,
        goremal_disp_web_ind,
        goremal_data_origin,
        goremal_surrogate_id,
        goremal_version,
        goremal_vpdi_code
        */