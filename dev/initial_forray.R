    require(raster)

    CS_exe <- 'C:/"Program Files"/Circuitscape/cs_run.exe'
    tst <- 'C:/Program Files/Circuitscape/cs_run.exe'

    # Cost surface
    cost <- raster(matrix(abs(rnorm(10000,1000,100)),100,100))

    # Locs
    sites <- SpatialPoints(cbind(c(0.1,0.9),c(0.1,0.9)))

    # Rasterize points using the cost extent
    sites <- rasterize(x = sites,y = cost)

    # Write rasters to your working directory
    writeRaster(sites,"sites_rast.asc",overwrite=TRUE)
    writeRaster(cost,"cost_rast.asc",overwrite=TRUE)

    # Make an .ini file
    CS_ini <- c(
      "[circuitscape options]",            
      "data_type = raster",
      "scenario = pairwise",
      paste(c(
        "point_file =",
        "habitat_file =",
        "output_file ="),
        paste(getwd(),c(
          "sites_rast.asc",
          "cost_rast.asc",
          "CS.out"),
          sep="/"
        )
      )
    )

    # Write it to your working directory
    writeLines(CS_ini,"myini.ini")

    # Make the CS run cmd
    CS_run <- paste(tst, paste(getwd(),"myini.ini",sep="/")) # Make the cmd

    # Run the command
    system(CS_run)

    # Import the effective resistance
    rdist <- as.dist(read.csv("CS_resistances.out",sep=" ",row.names=1,header=1))
