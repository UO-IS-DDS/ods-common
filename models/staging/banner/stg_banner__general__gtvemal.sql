with source as (

    select * from {{ source('banner__general', 'gtvemal') }}

),

renamed as (

    select
        gtvemal_code as email_type_code,
        gtvemal_desc as email_type_desc

    from source

)

select * from renamed
-- Unused Fields --
        /*
        gtvemal_activity_date,
        gtvemal_disp_web_ind,
        gtvemal_url_ind,
        gtvemal_surrogate_id,
        gtvemal_version,
        gtvemal_user_id,
        gtvemal_data_origin,
        gtvemal_vpdi_code
        */