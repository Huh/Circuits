    #  Circuitscape utility functions
    #  Josh Nowak
    #  01/2017
################################################################################
    fldr_mgmt <- function(){}
################################################################################
    check_exe <- function(x = NULL){
      #  A function to generate the path to the Circuitscape exe file
      #  Takes a string representing the file path
      #  Returns a path to the program that is useable by CMD, if it exists

      #  If input is null guess
      if(is.null(x)){
        #  Windows default
        if(Sys.info()["sysname"] == "Windows"){
          path <- "C:/Program Files/Circuitscape/cs_run.exe"
        }else{
          msg <- "Path guessing is only available for Windows at this time. Please provide the path to cs_run on your operating system."
          stop(
            cat(
              paste(
                strwrap(msg, options()$width),
                collapse = "\n"
              )
            )
          )
        }
      }else{
        path <- x
      }

      #  Check that exe file exists
      if(!file.exists(path) | !grepl(".exe$", path)){
        stop("Path to cs_run does not exist.  Please check the path and try again.")
      }

      #  Morph path to CMD usable format
      out <- gsub("([A-z]*\\s[A-z]*)", paste0("'", "\\1", "'"), path)

    return(out)
    }
################################################################################
    gen_ini <- function(){
    
      out <- c(
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

    return(out)
    }
################################################################################
    write_ini <- function(x, wd, name){
    
      # Write it to your working directory
      writeLines(x, file.path(wd, paste0(name, ".ini")))

    NULL
    }
################################################################################
  #  End