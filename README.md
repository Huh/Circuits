# Circuits
Calling circuitscape from R

This repository is the starting point for a general solution to programatically calling Circuitscape from R.  The workflow can be conceived in two ways:
1) A two step procedure where the ini files are built and then a system call is made
```R
    write_ini(
      cs_build_ini(
        data_type = "raster",
        scenario = "pairwise",
        point_file = "path to point file", 
        habitat_file = "path to cost layer",
        out_path = "directory to save output to",
        log_file = "log file path"
      ),
      "directory to write ini file to",
      "name for ini file"
    )
    #  Step 2 call CS
    cs_call(
      find_circuits(), 
      "path to ini file"
    )
```

2) A single step workflow
```R
  cs_wrapper(
      data_type = "raster",
      scenario = "pairwise",
      point_file = "path to point file", 
      habitat_file = "path to cost layer",
      out_path = "directory to save output to",
      ini_write_dir = "C:/Users/josh.nowak/Documents/GitHub/Circuits/tests",
      log_file = "log file path",
      ini_name = "ini file name",
      cs_path = find_circuits()    
    )
```

A total of seven arguments are required each time an ini file is built
1) data_type
2) scenario
3) point_file
4) habitat_file
5) out_path
6) ini_write_dir
7) ini_name

*Several efforts are made to check for valid inputs, but the combinations of the inputs are not constrained at this time thus it is possible for the user to supply unreasonable combinations of inputs.*

