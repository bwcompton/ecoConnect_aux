'project_package_calls' <- function(package, path = getwd()) {
   
   # list all calls to functions in specified package from files in project 
   # Arguments: 
   #     package     name of package to search for
   #     path        project path (default: current directory)
   # B. Compton, 10 Oct 2024
   
   
   
   library(NCmisc)
   library(package,  character.only = TRUE)        # the package must be loaded to track down its functions
   
   files <- list.files(path, '.*.R$')

   for(f in files) {
      x <- tryCatch(list.functions.in.file(f),
                    error = function(e) e)
      if(!inherits(x, 'error') & length(x) > 0) {
         y <- x[[paste0('package:', package)]]
         if(!is.null(y)) {
            cat(f, ':\n', sep = '')
            cat('   ', paste(y, collapse = ', '), '\n', sep = '')
         }
      }
   }
}