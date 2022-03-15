# DNA quality control and dilution factor calculation for Nanaopore rapid barcoding kits (RBK-004)

Prior to prepare library for MinION, quantity and quality of extracted genomic DNA (gDNA) must be measured using a fluoremeter (Qubit) and spectrophotometer (Nanodrop). The manufacturer (ONT) states that sequencing was optimized for DNA with specific ratios of absorbances measured at differernt wavelengths, specifically A260/280nm and A260/230nm. Based on the previous experience, MinIOn sequencing was successful with A260/280 between 1.8 to 2.1; and A260/230 between 1.8 to 2.9. 

After checking its quality, quantity (concentration) should be matched with its minimum and maximum requirements. The required DNA input is ~400ng in 7.5ul of total volume, which is equivalent as ~53.33ng/uL. In most cases, gDNA needs to be diluted and measured again using Qubit for more accurate quantity measurements

## Table of contents
__1. Export data from Nanodrop One__\
__2. DNA quality check using custom R script__\
__3. Calculate dilution factors and volume using custom R script__

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

#### 2. DNA quality check using custom R script
```


