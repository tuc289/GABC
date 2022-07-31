# DNA quality control and dilution factor calculation for Nanaopore rapid barcoding kits (RBK-004)

Prior to prepare library for MinION, quantity and quality of extracted genomic DNA (gDNA) must be measured using a fluoremeter (Qubit) and spectrophotometer (Nanodrop). The manufacturer (ONT) states that sequencing was optimized for DNA with specific ratios of absorbances measured at differernt wavelengths, specifically A260/280nm and A260/230nm. Based on the previous experience, MinIOn sequencing was successful with A260/280 between 1.8 to 2.1; and A260/230 between 1.8 to 2.9. 

After checking its quality, quantity (concentration) should be matched with its minimum and maximum requirements. The required DNA input is ~400ng in 7.5ul of total volume, which is equivalent as ~53.33ng/uL. In most cases, gDNA needs to be diluted and measured again using Qubit for more accurate quantity measurements

## Table of contents
__1. Export data from Nanodrop One__\
__2. DNA quality check and calculate dilution factors using custom R script__\
__3. Automation of the process using Rscript__

--- 

#### 1. Export data from Nanodrop One

Nanodrop One provides .csv file export from the machine to the flash drive. After you put your flash drive in the front of the machine, you can touch the "history" icon on the left bottom side

![image](https://user-images.githubusercontent.com/62360632/158447060-9a10c018-8fd7-42c8-a71c-458e4cc7097d.png)

Touch the date of your measurement and enter the experiment detail 

![image](https://user-images.githubusercontent.com/62360632/158447283-1dd1a468-8574-46d6-9d8b-5b5c777d2769.png)

Touch the menu botton on the left top part of the screen, and touch "export", choose "front USB" as destination

![image](https://user-images.githubusercontent.com/62360632/158447721-b6a034cb-7e09-4915-83b8-af99d5e1a084.png)

Choose the file type, .csv is required for the downstream procedure. 

![image](https://user-images.githubusercontent.com/62360632/158447888-607d616a-ca42-4ce4-aca9-28c5b408fbea.png)

---
### Please note that Nanodrop results might not be accurate if gDNA concentration is either too high or too low. Please consider using Qubit to check if concentration is accurate before calculating dilution factor 

#### 2. DNA quality check and calculate dilution factors using custom R script 
1. Import .csv file from NanodropOne to R
```
input <- read.table(<input_file.csv>, sep="\t", quote="", fill=TRUE, fileEncoding="UTF-16le", header=T)
input_trimmed <- input[,2:5] #Extract columns with i) concentration, ii) A260/280, iii) A260/230
```

2. DNA quality check
```
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
```

It will print out the results of QC as either your sample has passed the QC or failed and consider to re-extract gDNA

3. Calculate dilution factors and volumes targeting 53.33ng/ul
```
volume <- <custom final volume after dilution, RBK-004 requires 7.5ul, but you also need some extract for Qubit quantification too>

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
```

As a default, volume calculation will be done automatically based on the total volume of 10ul, as well as your custom volume

4. Write a new .csv file for the experiment
```
write.csv(final_results, <File name.csv>)
```

### 3. Automation of the process using Rscript ###
Running this script either under terminal or R(R >4.0.1 required)
```
wget https://github.com/tuc289/GABI/raw/main/Scripts/QC_and_dilution.R #Download script
Rscript QC_and_dilution.R <input path with file name> <Desired total volume after dilution>
```

