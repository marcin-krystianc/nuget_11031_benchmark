#!/bin/bash

# apt-get update
# apt-get install curl wget bc

export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
export MSBUILDDISABLENODEREUSE=1

# Define a list of string variable
# PROCESSORS=1,2,4,8,16,32,64,128
 
iterationCount=20

# Use comma as separator and apply as pattern
#for p in ${PROCESSORS//,/ }
for m in {0..1}
do
  for k in {0..1}
  do
     for j in {0..1}
     do
      # export DOTNET_PROCESSOR_COUNT=$p
      export NUGET_MMAP_PACKAGE_EXTRACTION=$j
      export NUGET_ASYNC_PACKAGE_EXTRACTION=$k
      for (( i=0; i<$iterationCount; i++ ))
      do
        ./dotnet-osx/dotnet nuget locals all --clear
        sleep 10
        # gdate is GNU version of the date (available via brew install coreutils)
        starttime0=$(gdate +%s.%N)
        ./dotnet-osx/dotnet restore -clp:summary --force /p:RestoreUseStaticGraphEvaluation=true orleans/
        # gdate is GNU version of the date (available via brew install coreutils)
        endtime0=$(gdate +%s.%N)
        dt=$(echo "$endtime0 - $starttime0" | bc)
        echo "async=$NUGET_ASYNC_PACKAGE_EXTRACTION,mmap=$NUGET_MMAP_PACKAGE_EXTRACTION,$dt" >> results_osx_dotnet.txt
      done
     done
  done
done
