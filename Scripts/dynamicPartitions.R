
args = commandArgs(trailingOnly=TRUE)
#args <- c("/c/Users/caleb/OneDrive/Desktop/PartitionProject/data/1", #pwd
#          "Choiniere_etal_2010a.nex",                                 #FILE
#          "BIC"                                                      #paritioning scheme
#)

wd <- getwd()
#get paritioning scheme
partitioningScheme <- args[1]
#get path to directory containing partitioning schemes
#formattedWd <- stringr::str_replace(wd, "/c/", "c://")
schemePath <-  paste(wd, "/../../PartitioningSchemes/", partitioningScheme, sep = "")

#get name of file to search for in the directory determined by the partitioning scheme
fileName <- args[2]
fileNameNoExtension <- unlist(stringr::str_split(fileName, "\\."))[1]
#fileNameNoExtensionBasePath <- unlist(stringr::str_split(fileNameNoExtension, "/"))[2]
print(fileNameNoExtension)
namesInSchemePath <- list.files(schemePath)
nameInDirectory <- grep(fileNameNoExtension, namesInSchemePath, value = T)
fullPathToPartition <- paste(schemePath, "/", nameInDirectory, sep = "")
print(nameInDirectory)
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

for (line in partitions){
cat(line, file = "parts.tsv" , append = T, sep = "\n")
}
