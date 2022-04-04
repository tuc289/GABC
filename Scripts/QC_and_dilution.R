r = getOption("repos")
r["CRAN"]= "http://cran.us.r-project.org"
options(repos=r)

if(!require(optparse)){
  intall.packages("optparse", quiet=TRUE)
  library(optparse)
}

#Setting up the options and import data

option_list = list(make_option(c("--nanodrop", "-n"), type = "character", 
                               default= NULL, help="Exported .csv file from Nanodrop"),
                   make_option(c("--qubit", "-q"), type = "character",
                               default=NULL, help="exported .csv file from Qubit"),
                   make_option(c("--volume", "-v"), type = "integer", 
                               default = 10, help = "Expected total volume after dilution"),
                   make_option(c("--output", "-o"), type = "character",
                               default= "output", help ="Output filename")
)
opt_parse <- OptionParser(usage = "Rscript %prog [options] file", option_list=option_list)
opt = parse_args(opt_parse)

if (is.null(opt$nanodrop)){
  print_help(opt_parse)
  stop("No nanodrop results were provided", call.=FALSE)
}

if (is.null(opt$qubit)){
  print_help(opt_parse)
  stop("No Qubit results were provided", call.=FALSE)
}


#R version check
if(version$major<4){stop("R version should be at least 4.0.1, please update your R")
} else {
    print("Start processing")
}

#Now check the input data and process them
#1. nanodrop results
#1)seperate filename and path (for output)
input_path <- opt$nanodrop
output_path <- dirname(input_path)
output_path_fin <- paste(output_path,"/",opt$output,".csv",sep="")

cat(paste("Your Nanodrop input file is", basename(input_path), seq=""))
input_nano <- read.table(input_path, sep="\t", quote="", fill=TRUE, fileEncoding = "UTF-16le", header=T)
input_trimmed <- input_nano[,2:5]

input_path_qubit <- opt$qubit
cat(paste("Your Qubit input file is", basename(input_path_qubit), seq=""))
input_qubit <- rev(read.table(input_path_qubit, 
                          sep=",", fill = TRUE, 
                          fileEncoding = "iso-8859-1", header=T))
input_trimmed_qubit <- input_qubit[,11]

final_input <- cbind("SampleID" =input_trimmed[,1], "Concentration" =input_trimmed_qubit, input_trimmed[,3:4])

#DNA quality check for A260/280 and A260/230
cat("DNA quality check ...")
for(i in 1:nrow(input_trimmed))
  {
  print(input_trimmed[i,1])
  if(1.8 < input_trimmed[i,3] && input_trimmed[i,3] < 2.2) {
    print(paste("A260/280 =",input_trimmed[i,3],"passed the quality creteria"))
  } 
} else {
  print(paste("Your", input_trimmed[i,1], "FAILED the quality creteria of A260/280, please consider re-extract gDNA from this isolate"))
}if(1.8 < input_trimmed[i,4] && input_trimmed[i,4] < 2.9) {
  print(paste("A260/A230 =", input_trimmed[i,4], "passed the quality creteria"))
}else {
  print(paste("Your", input_trimmed[i,1], "FAILED", input_trimmed[i,4],"the quality creteria of A260/230, please consider re-extract gDNA from this isoalte"))
}







