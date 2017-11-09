    #  Circuitscape .ini file builder functions
    #  Josh Nowak
    #  10/2017
    #  Sections follow the order of the configuration file, which is different
    #   than the GUI
################################################################################
    cs_logical_q <- function(response = NULL){
      #  A function to change R logical to Circuitscape alternative, helper
      #  Takes T, TRUE, F or FALSE only
      #  Returns character representation True or False
      
      athat(is.logical(response))
    
      out <- dplyr::if_else(response, "True", "False")

    return(out)
    }
################################################################################
    cs_match_tbl <- function(x, tbl){
      any(x %in% tbl)
    }
    cs_match_val <- function(x, val){
      athat(length(x) == 1)
      athat(length(val) == 1)
      
      identical(x, val)
    }
    cs_ntwrk_mode <- function(x, tbl){
      any(x %in% tbl)
    }
    
    assertthat::on_failure(cs_match_tbl) <- function(call, env){
      paste0(deparse(call$x), " must be one of ", deparse(call$tbl))
    }
    assertthat::on_failure(cs_match_val) <- function(call, env){
      paste0(deparse(call$x), " does not equal ", deparse(call$val))
    }
    assertthat::on_failure(cs_ntwrk_mode) <- function(call, env){
      glue::glue(
        "When data_type equals network, scenario can only be pairwise or 
        advanced."
      )
    }
################################################################################
    cs_adv_mode <- function(
      ground_file_is_resistances = T, 
      remove_src_or_gnd = "keepall",
      ground_file = NULL,
      use_unit_currents = F,
      source_file = NULL,
      use_direct_gnds = F,
      ...
    ){
    
      #  Assertions
      athat(is.logical(ground_file_is_resistances))
      athat(remove_src_or_gnd %in% c("keepall")) #  Check options available
      
      if(is.null(ground_file)){
        ground_file <- "(Browse for a ground point file)"
      }else{
        assertthat::is.readable(ground_file)
        athat(
          any(assertthat::has_extension(ground_file, c("txt", "asc")))
        )
        ground_file <- normalizePath(ground_file)
      }
      
      athat(is.logical(use_unit_currents))
      
      if(is.null(source_file)){
        source_file <- "(Browse for a current source file)"
      }else{
        assertthat::is.readable(source_file)
        athat(
          any(assertthat::has_extension(source_file, c("txt", "asc")))
        )
        source_file <- normalizePath(source_file)
        
      }
      
      athat(is.logical(use_direct_gnds))
      
      out <- glue::glue(
        "[Options for advanced mode]
        ground_file_is_resistances = {cs_logical_q(ground_file_is_resistances)}
        remove_src_or_gnd = {remove_src_or_gnd}
        ground_file = {ground_file}
        use_unit_currents = {cs_logical_q(use_unit_currents)}
        source_file = {source_file}
        use_direct_grounds = {cs_logical_q(use_direct_gnds)}"
      )
    
    return(out)
    }
################################################################################
    cs_mask_file <- function(
      use_mask = F, 
      mask_file = "None",
      ...
    ){
      #  A function to buile the Mask portion of the .ini file Circuitscape
      #  Takes
      #  Returns formatted text
      
      #  Assertions
      athat(is.logical(use_mask))
      if(use_mask){
        assertthat::is.readable(mask_file)
        athat(assertthat::has_extension(mask_file, "asc"))
      }
      
    
      out <- glue::glue(
        "[Mask file]
        mask_file = {purrr::when(
          use_mask, 
          . ~ normalizePath(mask_file),
          mask_file
        )}
        use_mask = {cs_logical_q(use_mask)}"
      )

    return(out)
    }
################################################################################
    cs_calc_opts <- function(
      low_memory_mode = F, 
      parallelize = F, 
      print_timings = F,
      preemptive_memory_release = F,
      print_rusages = F,
      max_parallel = 0,
      ...
    ){
      #  A function to build the calculation options portion of the .ini file 
      #   Circuitscape
      #  Takes 
      #  Returns formatted text
      
      valid_cores <- function(x) {
        athat(is.numeric(x), length(x) == 1)
        round(x) == x
      }

      assertthat::on_failure(valid_cores) <- function(call, env) {
          "max_parallel must be an integer greater than or equal to zero"
      }
      
      # Assertions
      athat(is.logical(low_memory_mode))
      athat(is.logical(parallelize))
      athat(is.logical(print_timings))
      athat(is.logical(preemptive_memory_release))
      athat(is.logical(print_rusages))
      athat(valid_cores(max_parallel))
              
      
      out <- glue::glue("[Calculation options]
        low_memory_mode = {cs_logical_q(low_memory_mode)}
        parallelize = {cs_logical_q(parallelize)}
        solver = cg+amg
        print_timings = {cs_logical_q(print_timings)}
        preemptive_memory_release = {cs_logical_q(preemptive_memory_release)}
        print_rusages = {cs_logical_q(print_rusages)}
        max_parallel = {as.integer(max_parallel)}"
      )

    return(out)
    }
################################################################################
    cs_shrt_crct <- function(
      use_polygons = F, 
      polygon_file = NULL,
      ...
    ){
      #  A function to build the short circuit section of the .ini file 
      #   Circuitscape
      #  Takes
      #  Returns formatted text
      
      #  Assertions
      athat(is.logical(use_polygons))
      if(use_polygons){
        assertthat::is.readable(polygon_file)
        athat(assertthat::has_extension(polygon_file, "asc"))
      }
      
      out <- glue::glue(
        "[Short circuit regions (aka polygons)]
        polygon_file = {purrr::when(
          use_polygons,
          . ~ normalizePath(polygon_file),
          '(Browse for a short-circuit region file)'
        )}
        use_polygons = {cs_logical_q(use_polygons)}"
      
      )
    
    return(out)
    }
################################################################################
    cs_oneall_allone <- function(
      use_variable_source_strengths = F, 
      variable_source_file = NULL,
      ...
    ){
      #  A function to build the options section for one-to-all and all-to-one
      #   modeling modes
      #  Takes
      #  Returns formatted text
    
      #  Assertions
      athat(is.logical(use_variable_source_strengths))
      if(use_variable_source_strengths){
        assertthat::is.readable(variable_source_file)
        athat(
          assertthat::has_extension(variable_source_file, "asc")
        )
      } 
    
      out <- glue::glue(
        "[Options for one-to-all and all-to-one modes]
        use_variable_source_strengths = {cs_logical_q(use_variable_source_strengths)}
        variable_source_file = {purrr::when(
          use_variable_source_strengths,
          . ~ normalizePath(variable_source_file),
          'None'
        )}"
      )
    
    return(out)
    }
################################################################################
    cs_output_opts <- function(
      null_current_to_nodata = F,
      focal_node_current_zero = T,
      null_volts_to_nodata = F,
      compress_grids = F,
      write_cur_maps = F,
      write_volt_maps = F,
      out_path = NULL,
      cum_cur_map_only = T,
      log_maps = F,
      write_max_cur_maps = T,
      ...
    ){
      #  A function to build the Circuitscape output options section of the ini 
      #   file
      #  Takes logical inputs and a file path for the output with extension .out
      #  Returns formatted text
      
      #  Assertions
      athat(is.logical(null_current_to_nodata))
      athat(is.logical(focal_node_current_zero))
      athat(is.logical(null_volts_to_nodata))
      athat(is.logical(compress_grids))
      athat(is.logical(write_cur_maps))
      athat(is.logical(write_volt_maps))
      athat(assertthat::is.writeable(dirname(out_path)))
      athat(is.logical(cum_cur_map_only))
      athat(is.logical(log_maps))
      athat(is.logical(write_max_cur_maps))      
      
      out <- glue::glue(
        "[Output options]
        set_null_currents_to_nodata = {cs_logical_q(null_current_to_nodata)}
        set_focal_node_currents_to_zero = {cs_logical_q(focal_node_current_zero)}
        set_null_voltages_to_nodata = {cs_logical_q(null_volts_to_nodata)}
        compress_grids = {cs_logical_q(compress_grids)}
        write_cur_maps = {cs_logical_q(write_cur_maps)}
        write_volt_maps = {cs_logical_q(write_volt_maps)}
        output_file = {normalizePath(out_path, mustWork = F)}
        write_cum_cur_map_only = {cs_logical_q(cum_cur_map_only)}
        log_transform_maps = {cs_logical_q(log_maps)}
        write_max_cur_maps = {cs_logical_q(write_max_cur_maps)}"
      )

    return(out)
    }
################################################################################
    cs_version <- function(){
      #  A function that returns the version of Circuitscape
      #  Takes nothing
      #  Returns formatted text
    
      out <- glue::glue(
        "[Version]
        version = unknown"
      )

    return(out)
    }
################################################################################
    cs_reclass_habitat <- function(
      use_reclass_table = F, 
      reclass_file = NULL,
      ...
    ){
      #  A function to build the habitat reclassification options portion of the 
      #   .ini file Circuitscape
      #  Takes
      #  Returns formatted text
      
      #  Assertions
      athat(is.logical(use_reclass_table))
      if(use_reclass_table){
        assertthat::is.readable(reclass_file) # Not sure on extension type
      }    
      
      
      out <- glue::glue(
        "[Options for reclassification of habitat data]
        reclass_file = {purrr::when(
          use_reclass_table,
          . ~ normalizePath(reclass_file),
          '(Browse for file with reclassification data)'
        )}
        use_reclass_table = {cs_logical_q(use_reclass_table)}"
      )

    return(out)
    }
################################################################################
    cs_log_opts <- function(
      log_level = "INFO", 
      log_file = "None", 
      profiler_log_file = "None",
      screenprint_log = F,
      ...
    ){
      #  A function to build the logging portion of the .ini file Circuitscape
      #  Takes
      #  Returns formatted text
      log_level <- toupper(log_level)

      #  Assertions
      athat(
        any(log_level %in% c("DEBUG", "INFO", "WARN", "ERROR"))
      )
      if(!is.null(log_file) && !identical(log_file, "None")){
        assertthat::is.writeable(dirname(log_file))
      }
      if(!is.null(profiler_log_file) && !identical(profiler_log_file, "None")){
        assertthat::is.writeable(dirname(profiler_log_file))      
      }
      athat(is.logical(screenprint_log))

      out <- glue::glue(
        "[Logging Options]
        log_level = {log_level}
        log_file = {log_file}
        profiler_log_file = {profiler_log_file}
        screenprint_log = {cs_logical_q(screenprint_log)}"
      )

    return(out)
    }
################################################################################
    cs_pair_oneall_allone_opts <- function(
      use_included_pairs = F,
      included_pairs_file = NULL,
      point_file = NULL,
      ...
    ){
      #  A function to build the Options for pairwise and one-to-all and 
      #   all-to-one modes portion of the .ini file
      #  Takes
      #  Returns formatted text
      
      #  Assertions
      athat(is.logical(use_included_pairs))
      
      if(!is.null(included_pairs_file)){
        athat(assertthat::is.readable(included_pairs_file))
      }
      
      athat(assertthat::is.readable(point_file))      
      
      out <- glue::glue(
        "[Options for pairwise and one-to-all and all-to-one modes]
        included_pairs_file = {purrr::when(
          use_included_pairs,
          . ~ normalizePath(included_pairs_file),
          '(Browse for a file with pairs to include or exclude)'
        )}
        use_included_pairs = {cs_logical_q(use_included_pairs)}   
        point_file = {purrr::when(
          !is.null(point_file),
          . ~ normalizePath(point_file),
          'None'
        )}"
      )
    
    return(out)
    }
################################################################################
    cs_connect_scheme <- function(
      connect_using_avg_resistances = F,
      connect_four_neighbors_only = F,
      ...
    ){
      #  A function to build the Connection scheme for raster habitat data 
      #   portion of the .ini file
      #  Takes
      #  Returns formatted text
      
      #  Assertions
      athat(is.logical(connect_using_avg_resistances))
      athat(is.logical(connect_four_neighbors_only))      
      
      out <- glue::glue(
        "[Connection scheme for raster habitat data]
        connect_using_avg_resistances = {
          cs_logical_q(connect_using_avg_resistances)
        }
        connect_four_neighbors_only = {
          cs_logical_q(connect_four_neighbors_only)
        }"      
      )
    
    return(out)
    }
################################################################################
    cs_habitat_layer <- function(
      habitat_map_is_resistances = T,
      habitat_file = NULL,
      ...
    ){
      #  A function to build the Habitat raster or graph portion of the .ini 
      #   file Circuitscape
      #  Takes
      #  Returns formatted text
      
      #  Assertions
      athat(is.logical(habitat_map_is_resistances))
      athat(assertthat::is.readable(habitat_file))
      
      out <- glue::glue(
        "[Habitat raster or graph]
        habitat_map_is_resistances = {cs_logical_q(habitat_map_is_resistances)}
        habitat_file = {purrr::when(
          !is.null(habitat_file),
          . ~ normalizePath(habitat_file),
          'None'
        )}"
      )
    
    return(out)
    }
################################################################################
    cs_mode <- function(
      data_type, 
      scenario = "pairwise",
      ...
    ){
      #  A function to build the Circuitscape mode section of the ini file
      #  Takes the data_type and mode with valid entries including raster or 
      #   network and pairwise, advanced, all-to-one, or one-to-all respectively
      #  Returns formatted text
      
      data_type <- tolower(data_type)
      scenario <- tolower(scenario)
      
      #  Assertions
      athat(
        cs_match_tbl(data_type, c("raster", "network"))
      )
      athat(
        cs_match_tbl(
          scenario, 
          c("pairwise", "advanced", "one-to-all", "all-to-one")
        )
      )
      
      if(data_type == "network"){
        athat(
          cs_ntwrk_mode(scenario, c("pairwise", "advanced"))
        )      
      }

      
      out <- glue::glue(
        "[Circuitscape mode]      
        data_type = {data_type}     
        scenario = {scenario}"
      )

    return(out)
    }
################################################################################