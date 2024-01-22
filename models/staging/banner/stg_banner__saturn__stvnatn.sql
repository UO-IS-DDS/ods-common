with source as (

    select * from {{ source('banner__saturn', 'stvnatn') }}

),

renamed as (

    select
        stvnatn_code   as nation_code,
        stvnatn_nation as nation_desc

    from source

)

select * from renamed
-- Unused Fields --
        /*
        stvnatn_capital,
        stvnatn_area,
        stvnatn_population,
        stvnatn_activity_date,
        stvnatn_edi_equiv,
        stvnatn_lms_equiv,
        stvnatn_postal_mask,
        stvnatn_tele_mask,
        stvnatn_statscan_cde,
        stvnatn_scod_code_iso,
        stvnatn_ssa_reporting_equiv,
        stvnatn_sevis_equiv,
        stvnatn_surrogate_id,
        stvnatn_version,
        stvnatn_user_id,
        stvnatn_data_origin,
        stvnatn_vpdi_code
        */