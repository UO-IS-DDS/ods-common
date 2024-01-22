with source as (

    select * from {{ source('banner__saturn', 'spbpers') }}

),

renamed as (

    select

        spbpers_pidm                    as internal_banner_id,
        spbpers_pref_first_name         as preferred_first_name,
        case
          when spbpers_confid_ind = 'Y' 
            then 'Y'
          else 'N'
        end                             as is_confidential

    from source

)

select * from renamed
-- Unused Fields -- 
        /*
        spbpers_ssn,
        spbpers_birth_date,
        spbpers_lgcy_code,
        spbpers_ethn_code,
        spbpers_mrtl_code,
        spbpers_relg_code,
        spbpers_sex,
        spbpers_dead_ind,
        spbpers_vetc_file_number,
        spbpers_legal_name,
        spbpers_name_prefix,
        spbpers_name_suffix,
        spbpers_activity_date,
        spbpers_vera_ind,
        spbpers_citz_ind,
        spbpers_dead_date,
        spbpers_pin,
        spbpers_citz_code,
        spbpers_hair_code,
        spbpers_eyes_code,
        spbpers_city_birth,
        spbpers_stat_code_birth,
        spbpers_driver_license,
        spbpers_stat_code_driver,
        spbpers_natn_code_driver,
        spbpers_uoms_code_height,
        spbpers_height,
        spbpers_uoms_code_weight,
        spbpers_weight,
        spbpers_sdvet_ind,
        spbpers_license_issued_date,
        spbpers_license_expires_date,
        spbpers_incar_ind,
        spbpers_webid,
        spbpers_web_last_access,
        spbpers_pin_disabled_ind,
        spbpers_itin,
        spbpers_active_duty_sepr_date,
        spbpers_data_origin,
        spbpers_user_id,
        spbpers_ethn_cde,
        spbpers_confirmed_re_cde,
        spbpers_confirmed_re_date,
        spbpers_armed_serv_med_vet_ind,
        spbpers_surrogate_id,
        spbpers_version,
        spbpers_vpdi_code,
        spbpers_gndr_code,
        spbpers_pprn_code
        */