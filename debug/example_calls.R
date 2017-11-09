    #  CircuitScape example calls
    #  Josh Nowak
    #  10/2017
################################################################################
    #  Example build_ini calls with and without errors
    cs_build_ini(
      data_type = "raster",
      scenario = "pairwise",
      point_file = "C:/Users/josh.nowak/Documents/GitHub/Circuits/data/fake/sites_rast.asc", 
      habitat_file = "C:/Users/josh.nowak/Documents/GitHub/Circuits/data/fake/cost_rast.asc",
      out_path = "C:/Users/josh.nowak/Documents/GitHub/Circuits/dev/run1"
    )
    
    #  Should fail because point_file is missing
    cs_build_ini(
      data_type = "raster",
      scenario = "pairwise",
      habitat_file = "C:/Users/josh.nowak/Documents/GitHub/Circuits/data/fake/cost_rast.asc",
      out_path = "C:/Users/josh.nowak/Documents/GitHub/Circuits/dev/run1"
    )    
    
    #  Should fail b/c data_type and scenario combination not possible
    cs_build_ini(
      data_type = "network",
      scenario = "one-to-all",
      point_file = "C:/Users/josh.nowak/Documents/GitHub/Circuits/data/fake/sites_rast.asc", 
      habitat_file = "C:/Users/josh.nowak/Documents/GitHub/Circuits/data/fake/cost_rast.asc",
      ground_file = "C:/Users/josh.nowak/Documents/GitHub/Circuits/data/fake/cost_rast.asc",
      out_path = "C:/Users/josh.nowak/Documents/GitHub/Circuits/dev/run1"
    )
    
    #  Should fail because input to scenario is not valid
    cs_build_ini(
      data_type = "raster",
      scenario = "onetoall",
      point_file = "C:/Users/josh.nowak/Documents/GitHub/Circuits/data/fake/sites_rast.asc", 
      habitat_file = "C:/Users/josh.nowak/Documents/GitHub/Circuits/data/fake/cost_rast.asc",
      ground_file = "C:/Users/josh.nowak/Documents/GitHub/Circuits/data/fake/cost_rast.asc",
      out_path = "C:/Users/josh.nowak/Documents/GitHub/Circuits/dev/run1"
    )
################################################################################
    #  Build ini and call CircuitScape in sequential steps
    #  Step 1 write the ini file
    write_ini(
      cs_build_ini(
        data_type = "raster",
        scenario = "pairwise",
        point_file = "C:/Users/josh.nowak/Documents/GitHub/Circuits/data/fake/sites_rast.asc", 
        habitat_file = "C:/Users/josh.nowak/Documents/GitHub/Circuits/data/fake/cost_rast.asc",
        out_path = "C:/Users/josh.nowak/Documents/GitHub/Circuits/dev/run1",
        log_file = "C:/Users/josh.nowak/Documents/GitHub/Circuits/tests/log"
      ),
      "C:/Users/josh.nowak/Documents/GitHub/Circuits/tests",
      "myini"
    )
    #  Step 2 call CS
    cs_call(
      find_circuits(), 
      "C:/Users/josh.nowak/Documents/GitHub/Circuits/tests/myini.ini"
    )
################################################################################
    #  One step workflow
    tt <- cs_wrapper(
      data_type = "raster",
      scenario = "pairwise",
      point_file = "C:/Users/josh.nowak/Documents/GitHub/Circuits/data/fake/sites_rast.asc", 
      habitat_file = "C:/Users/josh.nowak/Documents/GitHub/Circuits/data/fake/cost_rast.asc",
      out_path = "C:/Users/josh.nowak/Documents/GitHub/Circuits/dev/run1",
      ini_write_dir = "C:/Users/josh.nowak/Documents/GitHub/Circuits/tests",
      log_file = "C:/Users/josh.nowak/Documents/GitHub/Circuits/tests/log",
      ini_name = "myini",
      cs_path = find_circuits()    
    )

################################################################################
    #  Call multiple cost layers using similar ini inputs
    costs <- cs_dir2fls(
      "C:/Users/josh.nowak/Documents/GitHub/Circuits/tests/cost_rasters"
    )
    
    #  Loop using purrr::map
    purrr::map(
      costs,
      ~ cs_wrapper(
        data_type = "raster",
        scenario = "pairwise",
        point_file = "C:/Users/josh.nowak/Documents/GitHub/Circuits/data/fake/sites_rast.asc", 
        habitat_file = .,
        out_path = file.path(
          "C:/Users/josh.nowak/Documents/GitHub/Circuits/dev/", 
          cs_path2flnm(.)
        ),
        wd = "C:/Users/josh.nowak/Documents/GitHub/Circuits/tests",
        name = cs_path2flnm(.),
        cs_path = find_circuits()    
      )
    )
    
################################################################################
    #  Call multiple site layers using similar ini inputs
    sites <- cs_dir2fls(
      "C:/Users/josh.nowak/Documents/GitHub/Circuits/tests/site_rasters"
    )
    
    #  Loop using purrr::map
    purrr::map(
      sites,
      ~ cs_wrapper(
        data_type = "raster",
        scenario = "pairwise",
        point_file = "C:/Users/josh.nowak/Documents/GitHub/Circuits/data/fake/sites_rast.asc", 
        habitat_file = .,
        out_path = file.path(
          "C:/Users/josh.nowak/Documents/GitHub/Circuits/dev/", 
          cs_path2flnm(.)
        ),
        wd = "C:/Users/josh.nowak/Documents/GitHub/Circuits/tests",
        name = cs_path2flnm(.),
        cs_path = find_circuits()    
      )
    )
################################################################################
    costs <- cs_dir2fls(
      "C:/Users/josh.nowak/Documents/GitHub/Circuits/tests/cost_rasters"
    )

    #  Loop using standard loop
    for(i in seq_along(costs)){
      cs_wrapper(
        data_type = "raster",
        scenario = "pairwise",
        point_file = "C:/Users/josh.nowak/Documents/GitHub/Circuits/data/fake/sites_rast.asc", 
        habitat_file = costs[i],
        out_path = file.path(
          "C:/Users/josh.nowak/Documents/GitHub/Circuits/dev/", 
          cs_path2flnm(costs[i])
        ),
        wd = "C:/Users/josh.nowak/Documents/GitHub/Circuits/tests",
        name = cs_path2flnm(costs[i]),
        cs_path = find_circuits()    
      )
    }
    
################################################################################
    #  End