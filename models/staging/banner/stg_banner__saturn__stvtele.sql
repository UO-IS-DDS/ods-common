with source as (

    select * from {{ source('banner__saturn', 'stvtele') }}

),

renamed as (

    select
        stvtele_code as phone_type_code,
        stvtele_desc as phone_type_desc

    from source

)

select * from renamed
-- Unused Fields --
        /*
        stvtele_activity_date,
        stvtele_surrogate_id,
        stvtele_version,
        stvtele_user_id,
        stvtele_data_origin,
        stvtele_vpdi_code
        */