    #  Circuitscape utility functions
    #  Josh Nowak
    #  01/2017
################################################################################
    #  Generic more verbose version of assert_that
    athat <- function(..., env = parent.frame()){
        res <- assertthat::see_if(..., env = env)
        
        sc <- sys.call(-1)
        
        attr(res, "msg") <- paste(
          "\nfunction: ", 
          sc[1],
          "\nargument(s): ", 
          paste(sc[-1], collapse = " | "),
          "\nreason: ", 
          attr(res, "msg")
        )
        
        if(res){ 
          return(TRUE)
        }
        
        stop(attr(res, "msg"), call. = FALSE)
    }
################################################################################
    find_circuits <- function(x = NULL){
      #  A function to generate the path to the Circuitscape exe file
      #  Takes a string representing the file path
      #  Returns a path to the program that is useable by CMD, if it exists
      
      if(!is.null(x)){
        stopifnot(file.exists(x))
      }
      
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
      if(file.info(path)$exe == "no"){
        stop("Path to cs_run is not executable.  Please check the path and try again.")
      }

      #  Morph path to CMD usable format
      out <- Sys.which(path)

    return(out)
    }
################################################################################
    cs_build_ini <- function(...){
      #  A wrapper that calls ini_builders.R in order 
      #  Takes the 5 mandatory arguments plus any options the user desires
      #  Returns formatted text file
      
      ref <- c(
        "data_type", "scenario", "point_file", "habitat_file", "out_path"
      )  
      
      #  Assertions
      req_args <- function(...){
          all( ref %in% names(list(...)) )
      }

      assertthat::on_failure(req_args) <- function(call, env){
        paste(
          "The following arguments must be specified:",
          paste(ref[!ref %in% names(list(...))], collapse = ",")
        )
      }
      
      athat(req_args(...))
      
      out <- glue::glue("
        {cs_adv_mode(...)}\n
        {cs_mask_file(...)}\n
        {cs_calc_opts(...)}\n
        {cs_shrt_crct(...)}\n
        {cs_oneall_allone(...)}\n
        {cs_output_opts(...)}\n
        {cs_version()}\n
        {cs_reclass_habitat(...)}\n
        {cs_log_opts(...)}\n
        {cs_pair_oneall_allone_opts(...)}\n
        {cs_connect_scheme(...)}\n
        {cs_habitat_layer(...)}\n
        {cs_mode(...)}\n
      ")
    
    return(out)
    }
################################################################################
    write_ini <- function(x, ini_dir, name){
    
      # Write it to your working directory
      writeLines(x, file.path(ini_dir, paste0(name, ".ini")))

    invisible(NULL)
    }
################################################################################
    cs_call <- function(cs_path, ini_path){
      #  A function to make the system call to Circuitscape
    
    
      CS_run <- paste(
        Sys.which(cs_path),
        normalizePath(ini_path)
      )
      
      out <- try(
        system(CS_run)
      )
      
    return(out)
    }
################################################################################
    cs_path2flnm <- function(x){
    
      out <- sub(
        pattern = "(.*)\\..*$", 
        replacement = "\\1", 
        basename(x)
      )

    return(out)
    }
################################################################################
    cs_wrapper <- function(..., ini_write_dir, ini_name, cs_path){
    
      write_ini(
        cs_build_ini(
          ...
        ),
        ini_write_dir,
        ini_name
      )
      
      res <- cs_call(
        cs_path, 
        file.path(
          ini_write_dir, 
          paste0(ini_name, ".ini")
        )
      )
      
      if(class(res) == "try-error"){
        try(file.show(log_file))
        out <- "Model call failed"
      }else{
        out <- "Model call successful"
      }
      
    invisible(out)
    }
################################################################################
    cs_dir2fls <- function(x){
    
      out <- list.files(
        x,
        pattern = "asc$|txt$",
        full.names = T      
      )
      
      if(length(out) == 0){
        stop("In cs_dir2fls supplied directory is either not a directory or empty")
      }
    
    return(out)
    }
################################################################################
    #  Add output functions
################################################################################
  #  End
