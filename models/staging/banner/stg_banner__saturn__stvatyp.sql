with source as (

    select * from {{ source('banner__saturn', 'stvatyp') }}

),

renamed as (

    select
        stvatyp_code as address_type_code,
        stvatyp_desc as address_type_desc

    from source

)

select * from renamed
-- Unused Fields --
        /*
        stvatyp_activity_date,
        stvatyp_system_req_ind,
        stvatyp_tele_code,
        stvatyp_update_web_ind,
        stvatyp_surrogate_id,
        stvatyp_version,
        stvatyp_user_id,
        stvatyp_data_origin,
        stvatyp_vpdi_code
        */