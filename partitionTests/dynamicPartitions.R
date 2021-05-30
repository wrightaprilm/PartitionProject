
args = commandArgs(trailingOnly=TRUE)
#args <- c("/c/Users/caleb/OneDrive/Desktop/PartitionProject/data/1", #pwd
#          "Choiniere_etal_2010a.nex",                                 #FILE
#          "BIC"                                                      #paritioning scheme
#)

#get paritioning scheme
partitioningScheme <- args[3]

#get path to directory containing partitioning schemes
wd <- args[1]
formattedWd <- stringr::str_replace(wd, "/c/", "c://")
schemePath <- gsub("data/.*", paste("PartitioningSchemes/", partitioningScheme, sep = "") , formattedWd)


#get name of file to search for in the directory determined by the partitioning scheme
fileName <- args[2]
fileNameNoExtension <- unlist(stringr::str_split(fileName, "\\."))[1]

namesInSchemePath <- list.files(schemePath)
nameInDirectory <- grep(fileNameNoExtension, namesInSchemePath, value = T)

fullPathToPartition <- paste(schemePath, "/", nameInDirectory, sep = "")


#now to change to file
#read file containing partitions
file <- unlist(readLines(fullPathToPartition))

#convert paritions into 2 dimensional array
partitions <- grep(", Subset", x = file, value = T)
valueLocs <- stringr::str_locate(partitions, " = ")[,2]
partitions <- stringr::str_squish(stringr::str_sub(partitions, valueLocs))
partitions <- lapply(partitions, stringr::str_split, pattern = ",")
partitions <- lapply(partitions, unlist)
partitions <- lapply(partitions, stringr::str_squish)
partCopy <- partitions
#get characters that aren't in each partition to fit excludeCharacter in rev script
for(i in 1:length(partitions))
  partitions[[i]] <- unlist(partCopy[-c(i)])

#convert partitions to string
partitions <- lapply(partitions, toString)
partitions <- stringr::str_c(paste("[", partitions, "]"))

#get number of partitions
n_partitions <- length(partitions)

partitions <- toString(unlist(partitions))
partitions <- stringr::str_c(paste("[", partitions, "]"))


Mk_parted <- "C://Users/caleb/OneDrive/Desktop/PartitionProject/Scripts/Mk_parted.Rev"
Mk_parted_Final <- "C://Users/caleb/OneDrive/Desktop/PartitionProject/Scripts/Mk_parted_Final.Rev"

mkPartedText <- unlist(readLines(Mk_parted))
mkPartedText <- unlist(c(paste("n_partitions <- ", n_partitions, "\npartitions <- ", partitions, "\n", sep = " "), mkPartedText))

loopStart <- grep("excludeCharacter", mkPartedText)
mkPartedText[loopStart - 1] <- paste("for(i in 1:n_partitions){")
mkPartedText[loopStart] <- "morpho_bystate[i].excludeCharacter(partitions[i])"

cat(mkPartedText, file = Mk_parted_Final , append = F, sep = "\n")





