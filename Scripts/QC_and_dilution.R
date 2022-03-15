#Usage: Rscript QC_and_dilution.R <input file> <target volume>

args <- commandArgs(trailingOnly=TRUE)

arguments <- unlist(strsplit(args, " "))
input_file_path <- arguments[1]
input_file_name <- unlist(strsplit(input_file_path, "/"))

print(paste("input file is", tail(input_file_name,n=1)))

input <- read.table(input_file_path,sep ="\t", fill = TRUE, fileEncoding = "UTF-16le", header=T)
input_trimmed <- input[,2:5]

#DNA quality check for A260/280 and A260/230
print("DNA quality check")
for(i in 1:nrow(input_trimmed)){
  print(input_trimmed[i,1])
  if(1.8 < input_trimmed[i,3] && input_trimmed[i,3] < 2.2) {
    print(paste("A260/280 =",input_trimmed[i,3],"passed the quality creteria"))
    } 
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
volume <- arguments[2]

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

print("Process finished")


