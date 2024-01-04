# Conda/Mamba Environment management

## Prerequisits
Make sure you have the following things set up
* the mamba package manager
* With the mamba python activated, install the conda-lock package
    * `mamba install --channel=conda-forge --name=base conda-lock`
* Make sure your compiler build chain is properly installed ** including cmake**

## Makefile commands
All the actions you can take are enumerated in lockfile

## Notes on how I think I'll use this
* I'll have my main viz environmnet and a experiment environmnet.  
* I'll update which one I'm using my manually editing the activation code for my switchenv `viz` profile
* Any new packages I want to include (many its just part of my install process) will get added to the `ad_hoc_installs.txt` file.
    * If I decide I like those packages, then I'll (at a later date) have to add each of those files to the corresponding environment
      file and recreate the lock file.
* I anticipate having the `viz` and `experiment` lock-files checked into a github repo 
