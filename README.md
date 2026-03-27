
Cmake build scripts to simplify Geant, ROOT and general environment-variable based builds.

It uses standard environment variables to find needed things but the magic is that you do not need to source the setup script before running CMake (or your IDE).  This can be a pain in some IDE enviroments. 

This will source the script for you and extract the variables, and create targets for Geant4 and ROOT.

copy, subtree, or submodule this director into: 

cmake/DSL
ie so that this README.md will be 
```
cmake/DSL/README.md
```
and you will have
```
cmake/DSL/cern
cmake/DSL/utils
```
.. and maybe more in the future

Copy the example CMakeLists.example.txt to your root CMakeLists.txt
It is taken from DLG4Volumebuilders.

You will need this part or its latest version (could change):
```
# This CMakeLists.txt is for VolumeBuilder
# It defines a static library for VolumeBuilder, including its source files,
# its headers, and its necessary Geant4 dependencies.

# Ensure minimum CMake version consistent with your main project
cmake_minimum_required(VERSION 3.15)

# Define a project for this sub-component
project(YourProject LANGUAGES CXX)

# Set C++ standard consistent with your main project
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(SETUP_FILE "vb_user_setup.sh")
set(SETUP_SCRIPT "$ENV{HOME}/${SETUP_FILE}")
set(DSL_CMAKE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/DSL/")
include("${DSL_CMAKE_PATH}/cern/Geant4_Target.cmake")
include("${DSL_CMAKE_PATH}/cern/ROOT_Target.cmake")
#Optional:
#include("${DSL_CMAKE_PATH}/utils/Setup_Paths.cmake")
```

Change the vb_user_setup.sh to the name of your setup script in your HOME directory.  That script should define:
```
        GEANT4_PATH
        G4ENSDFSTATEDATA
        G4LEDATA
        G4LEVELGAMMADATA
        G4NEUTRONHPDATA
```
and
```
	    ROOTSYS
```
and if you use Setup_Paths.cmake then also ```local_bin``` and ```local_lib```
which can be used to define isntall paths.

GEANT4_PATH is the path to the root of the GEANT4 isntallation, not the CMAKE path.  That script could look something like this:
```
export Geant4_DIR="/opt/geant-10.7.4-C++17/geant4-install-4.10.7.4-C17-gcc-13.3.0/"
export ROOT_PATH="/opt/root/6.30.04-CPP17-install"
source ${Geant4_DIR}/bin/geant4.sh  # this should work on standard geant installs

# I have some redundant variable names from historical reasons.
export ROOT_DIR=${ROOT_PATH}
export ROOTSYS=${ROOT_DIR}
export GEANT4_PATH=${Geant4_DIR}   

#Extra ROOT setup
source ${ROOT_PATH}/bin/thisroot.sh
export PATH=${VOLUME_BUILDER_GIT_DIR}/bin:${PATH}

unset MAKEFILES  # Not sure what this does
```
... and those are the versions of root and geant this is presently tested on.  In fact problems with find_package on the old Geant 10 is part of what inspired this.

Most importantly you will be setup with two virtual targets to use in the CMakeLists.txt:
```
ROOT_Target
Geant4_Target
```

which you can use like this:
```
target_link_libraries(YourProject PUBLIC
    ROOT_Target
    Geant4_Target
)
```

Finally you can also extract more environment variables from your shell script in the same way the geant script does it:

```
set(REQUIRED_ENVS
        GEANT4_PATH
        G4ENSDFSTATEDATA
        G4LEDATA
        G4LEVELGAMMADATA
        G4NEUTRONHPDATA
)

siphon_user_envs(REQUIRED_ENVS REQUIRED)
```
The keyword REQUIRED just makes cmake error if the env is not found.
The values will be set the the shell ENV and to the CMAKE variable with the same name.


