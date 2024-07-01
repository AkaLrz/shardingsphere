#!/bin/bash


# Get file directory and output directory
current=$(pwd)

# use loop to get root directory, if module don't change the loop needn't change
for i in {1..5}; do
  current=$(dirname "$current")
done

dir=$current
# create corresponding fold
eval `mkdir mergeClassFile`
eval `mkdir mergeExecFile`
eval `mkdir mergeReport`

execMergePath='./mergeExecFile/merge.exec'
echo 'Start search jacoco.exec file'

# Search all jacoco.exec file on whole SS
execFiles=$(find $dir -name 'jacoco.exec')

# Check if file exist
if [ -z "$execFiles" ]
then
  echo "Can't find jacoco.exec file on specific directory"
  exit 1
fi

# create an array to store file path
execFileArray=()

# Traverse the file and add file path to array
for execFile in $execFiles
do
  execFileArray+=($execFile)
done

echo "Find ${#execFileArray[@]} jacoco.exec file"

# make sure folder is empty
rm -rf "$execMergePath"/*

echo "start aggregation jacoco.exec"
# Use jacococli to merge files and output them to the specified file
java -jar ./jacococli.jar merge "${execFileArray[@]}" --destfile $execMergePath

echo "Aggreration Success，Output file on：$execMergePath"

echo "Start aggregation and compiling code"
# Start aggregation all compiled code
classOutPutDir='./mergeClassFile'

# Find all classes folders
classFolders=$(find $dir -type d -name 'classes')

# Check if the folder is found.
if [ -z "$classFolders" ]
then
  echo "The classes folder was not found in the given directory"
  exit 1
fi

# Create an array to store folder paths
classFolderArray=()

# Traverse the folder and add the path to the array
for classFolder in $classFolders
do
  classFolderArray+=($classFolder)
done

# Make sure folder is empty
rm -rf "$classOutPutDir"/*

echo "Find${#classFolderArray[@]}classes folder"
# Copy the folders to the specified directory in order, and add the copied folders to the following order: 1, 2, 3... Names in the order
counter=1
for classFolder1 in "${classFolderArray[@]}"
do
  cp -r $classFolder1 $classOutPutDir/$counter
  let counter++
done

echo "Copy Success，The compilation merge output folder is located in the：$classOutPutDir"

echo "Start generating overall coverage reports"
mergeReportDir='./mergeReport'
# make sure file is empty
rm -rf "$mergeReportDir"/*
# use jacococli generate html
java -jar ./jacococli.jar report $execMergePath --classfiles $classOutPutDir --sourcefiles $dir --html $mergeReportDir
# use jacococli generate xml
java -jar ./jacococli.jar report $execMergePath --classfiles $classOutPutDir --sourcefiles $dir --xml $mergeReportDir/jacoco.xml

echo "Build success，report is on ：$mergeReportDir"