clean_intervals <- function(filename = "intervals_p3.txt", output_file = "intervals_R.csv"){
      # Read in file as string and convert to (r x 2) data frame
      # Infinity is read in as NA
      st <- scan(filename, what = "character", na.strings = "infinity")
      l <- length(st)
      r <- l/2
      m <- matrix(st, r, 2, byrow = TRUE)
      n <- as.data.frame(m, stringsAsFactors = FALSE)

      # Identify where the dimensions change
      spots <- numeric()
      for(i in 1:r){
            if (n[i,1] == "Dimension:")
                  spots <- c(spots, i)
      }
      num_dims <- length(spots)
      spots <- c(spots, r+1) 
      # spots is a vector with a value at each row where dim changes,
      # and also has a final value of r+1 appended
      
      data_list <- vector("list", length = num_dims)  #initialize
      
      for(k in 1:num_dims){                     # repeats for each dimension
            dim <- as.numeric(n[spots[k],2])    # reads dimension
            start <- (spots[k]+1)               # row where lines start
            finish <- (spots[k+1]-1)            # row where lines end
            num_lines <- finish - start + 1     # number of lines
            dim_list <- rep(dim, num_lines)     # repeat string of dimension
            d <- data.frame(dimension = dim_list) #turns into skinny DF
            e <- n[start:finish,]               # subset data for this dim
            names(e) <- c("start", "stop")      # change heading
            e$start <- as.numeric(e$start)      # convert to numerics
            e$stop <- as.numeric(e$stop)
            data <- cbind(d,e)                  # combine columns
            data_list[[k]] <- data              # store in list
            #print(data)
      }
      total_data <- data_list[[1]]              #combines list into one DF
      if (num_dims>1){
            for (j in 2:(num_dims)){
                  total_data <- merge(total_data,data_list[[j]],all=TRUE)
            }
      }
      # Optional save to file
      write.csv(total_data, output_file, row.names=FALSE, quote=FALSE)
      
      total_data
      
}