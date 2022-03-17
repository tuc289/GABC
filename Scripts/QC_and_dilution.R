<<<<<<< HEAD
#r = getOption("repos")
#r["CRAN"] = "http://cran.us.r-project.org"
#options(repos = r)

#install.packages("optparse", quiet = T)
library(optparse)

option_list = list(make_option(c("--nanodrop", "-n"), type = "character", 
                               default= NULL, help="Exported .csv file from Nanodrop", metavar = "path to input .csv file from Nanodrop"),
                   make_option(c("--qubit", "-q"), type = "character",
                               default=NULL, help="exported .csv file from Qubit", metavar="path to input .csv file from Qubit"),
                   make_option(c("--volume", "-v"), type = "integer", 
                               default = 10, help = "Expected total volume after dilution", metavar="Desired volume"),
                   make_option(c("--output", "-o"), type = "character",
                               default= NULL, help ="Output filename", metavar = "output file name")
)

opt_parse = OptionParser(option_list=option_list)
opt = parse_args(opt_parse)

if (is.null(opt$nanodrop)){
  print_help(opt_parse)
  stop("No nanodrop results were provided", call.=FALSE)
}

if (is.null(opt$qubit)){
  print_help(opt_parse)
  stop("No Qubit results were provided", call.=FALSE)
}

if (is.null(opt$output)){
  print_help(opt_parse)
  stop("No output filename were provided", call.=FALSE)
}

print("Processing started")


#Input files and arguments as object
input_file_path <- opt$nanodrop
input <- read.table(input_file_path,sep ="\t", quote="",fill = TRUE, fileEncoding = "UTF-16le", header=T)
input_file_name <- unlist(strsplit(input_file_path, "/"))
input_file_path_without_file_name <- head(input_file_name, n = length(input_file_name)-1)

print(paste("input file for nanodrop measurement is", tail(input_file_name,n=1)))
input_trimmed <- input[,2:5]

qubit_file_path <- opt$qubit
qubit_input <- read.table(qubit_file_path, sep="\t", quote="", fill = TRUE, fileEncoding = "UTF-16le", header=T)
qubit_input_name <- unlist(strsplit(qubit_file_path, "/"))
qubit_input_file_path_without_file_name <- head(qubit_input_name, n = length(qubit_input_name)-1)

print(paste("input file for qubit measurement is", tail(qubit_input_name, n=1)))

#output
output_file_path <- opt$output
output_file_path_final <- paste(output_file_path,"/",tools::file_path_sans_ext(tail(input_file_name,n=1)),
"_dilution.csv")


#DNA quality check for A260/280 and A260/230
#1. Concatenate Qubit results and Nanodrop results

=======
print("Processing started")
args <- commandArgs(trailingOnly=TRUE)

arguments <- unlist(strsplit(args, " "))
input_file_path <- arguments[1]
input_file_name <- unlist(strsplit(input_file_path, "/"))
output_path <- head(input_file_name, n = length(input_file_name)-1)
output_path <- do.call(file.path, 
                       as.list(output_path))
print(paste("input file is", tail(input_file_name,n=1)))

input <- read.table(input_file_path,sep ="\t", quote="",fill = TRUE, fileEncoding = "UTF-16le", header=T)
input_trimmed <- input[,2:5]

#DNA quality check for A260/280 and A260/230
>>>>>>> origin/main
print("DNA quality check")
for(i in 1:nrow(input_trimmed)){
  print(input_trimmed[i,1])
  if(1.8 < input_trimmed[i,3] && input_trimmed[i,3] < 2.2) {
    print(paste("A260/280 =",input_trimmed[i,3],"passed the quality creteria"))
<<<<<<< HEAD
  } 
=======
    } 
>>>>>>> origin/main
  else {
    print(paste("Your", input_trimmed[i,1], "FAILED the quality creteria of A260/280, please consider re-extract gDNA from this isolate"))
  }
  if(1.8 < input_trimmed[i,4] && input_trimmed[i,4] < 2.9) {
    print(paste("A260/A230 =", input_trimmed[i,4], "passed the quality creteria"))
  }
  else {
    print(paste("Your", input_trimmed[i,1], "FAILED", input_trimmed[i,4],"the quality creteria of A260/230, please consider re-extract gDNA from this isoalte"))
  }
}

#Calculate dilution factors and volumes targetting 53.33ng/uL in 10 uL
print("Dilution calculation")
volume <- as.numeric(arguments[2])

concentrations <- input_trimmed[,1:2]
target_concentration <- 53.33
dilution_factor <- (input_trimmed[,2]/target_concentration)
volume_10ul <- 10/dilution_factor
water_needed_10ul <- 10-volume_10ul
volume_Xul <- volume/dilution_factor
water_needed <- volume-volume_Xul

final_results <- cbind(input_trimmed, "dilution factor" = dilution_factor,
                       "target volume" = volume,
                       "amount DNA (ul)" = volume_Xul, 
                       "amount water (ul)" = water_needed,
                       "amound DNA (ul) for 10ul" = volume_10ul, 
                       "amount water (ul) for 10ul" = water_needed_10ul)
<<<<<<< HEAD
write.csv(final_results, output_file_path_final, sep ="")
=======
write.csv(final_results, 
          paste(output_path,"/",tools::file_path_sans_ext(tail(input_file_name,n=1)),
                "_dilution.csv", sep =""))
>>>>>>> origin/main
print("Process finished")


