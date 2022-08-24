# SSP Dynamic Architecture Recovery

Replication package for SSP dynamic architecture recovery project.

The complete recovery process starts with instrumenting a scientific model
with Kieker, like Kieker4C, running the model and collecting monitoring data in
one of two ways. To ease replication, we provide a Kieker monitoring log and
the associated UVic_ESCM executable which can be found in this replication
package.

- kieker-20220816-165500-2366367278757994-UTC--ssp-recovery.tgz
- UVic_ESCM

The replication package is grouped in 5 sections.
- Setup and execution of the analysis 
- Inspection of the generated models
- Instrumenting UVic
- Instrumenting MITgcm

## Analysis Setup and Execution

To setup and execute the analysis execute the following steps:
- Ensure Java is installed
- Unpack maa-1.3.0-SNAPSHOT.tar and dar-1.3.0-SNAPSHOT.tar
  - `tar -xpf maa-1.3.0-SNAPSHOT.tar`
  - `tar -xpf dar-1.3.0-SNAPSHOT.tar`
- In case you want to use the pre-recorded monitoring events
  - Create a data directory and extract the log there.
  - `mkdir data`
  - `cd data`
  - `tar -xzpf ../kieker-20220816-165500-2366367278757994-UTC--ssp-recovery.tgz`
- In case you want to monitor a model yourself, follow the instrutions below
  which will generate Kieker log directories which you can use in this step
  as well.
- Check whether the addr2line tool is installed. In Debian and Ubuntu the tool
  can be found in the binutils package and is usually already installed when
  you have a compiler installed.
- Have a look in `config.rc`. Usually it should be setup correctly, but
  in case addr2line is installed in an unusal place or you aim to use your
  own `module-file-function-map.csv` and Kieker-log files, you can set the
  path there.
- Run `./experiment.sh` in case a path is not set up correctly, the script
  will warn in case anything is missing.

When the script has finished correctly, you will have a set of architecture
models in the `models` directory:

- `file` architecture model with file based components
- `file-interface` same as above, with computed interfaces
- `file-map` same as file, but with a second component hierarchy added based on
  the map file. 
- `file-map-interface` same as above, with computed interfaces
- `map` architecture model with map based components
- `map-interface` same as above, with computed interfaces

## Inspecting the models

While the OceanDSL tools have a command line visualization tool, we also have a
Eclipse based UI visualization. To set it up you need to install Eclipse
preferably Eclipse Modeling or DSL edition.

Install from https://maui.se.informatik.uni-kiel.de/repo/kdt/snapshot/
the Kieker Architecture Visualization Feature.
- To do so start your Eclipse
- Click on "Help" > "Install New Software ..."
- Click on "Add..."
- Enter KDT as name and https://maui.se.informatik.uni-kiel.de/repo/kdt/snapshot/
  for the location
- Click on "Add"
- Select the newly added location in case Eclipse does not by itself.
- Now Eclipse shold list some features on called Kieker Architecture Visualization
- Proceed with the installation. It will ask for permission to do so, as our
  packages are not signed. 

- After installation and restarting Eclipse, you can import all the generated
  projects in the File menu.
- To enable visualizations, you have to activate Kieler Lightweight diagrams view.
  - Click on "Window" > "Show Views" > "Other"
  - Browse for "KIELER Leightweight Diagrams"
  - Select "Diagram"

- Now when clicking on an `assembly-model.xmi` or `execution-model.xmi`, a
  corresponding visualization should be shown in the view area of Eclipse.
- Please note that the execution model viewer is less stable and might produce
  odd results or miss behave when changing view options. You can just toggle to
  another file and view and back again, and it should work again.

## Installing Kieker 4 C

For all model instrumentation you have to install Kieker 4 C. To install
Kieker 4 C, you need build utils installed including libtool, automake and
autoconf.

- `git clone https://github.com/kieker-monitoring/kieker-lang-pack-c`
- `cd lieker-lang-pack-c/source`
- `libtoolize`
- `aclocal`
- `automake --add-missing`
- `autoconf`

This makes is compileable.

- `./configure` configures the code
- `make ; make install` this installs the library in `/usr/local/lib`
  In case you want to install it elsewhere, you can set a path with `--prefix`
  during configuration.

## Setup logging

Unpack `collector.tgz` with 
- `tar -xpf collector.tgz`
Setup the collector by adapting the `collector.conf`
- Set the `customStoragePath` to a location you want to collect your data.

## Instrumenting UVic

Instrumenting UVic is fairly simple when could get the code from
http://terra.seos.uvic.ca/model/

To get access to the code, you have to write them an e-mail.

- Unpack the archive and compile the software
- We used ifort to compile it, as it did not work with gcc. However, other
  people where able to compile it just fine with gcc.
- The main configuration file is `mk.in` you have to add at least the following
  lines to it or (depending on your source) replace variables in your `mk.in`

```  
Libraries = -lnetcdf -lnetcdff -L/usr/local/lib -lkieker -L/opt/intel/oneapi/compiler/2021.4.0/linux/compiler/lib/intel64_lin -L/usr/lib/x86_64-linux-gnu

Compiler_F = ifort -r8 -g -finstrument-functions -O0 -warn nouncalled -c
Compiler_f = ifort -r8 -g -finstrument-functions -O0 -warn nouncalled -c
Linker = ifort -r8 -g -finstrument-functions -O0 -warn nouncalled -o
```

The option `-L/opt/intel/oneapi/compiler/2021.4.0/linux/compiler/lib/intel64_lin` 
is used in the current debian package setup for intel compilers. As this is
constantly changing, ifort library might be somewhere else on your machine.

- Compile the model with `mk e` with the correct path to the mk tool.
- When everything checks out, start the collector as detailed in "Setup logging"
  and when it is running, start the UVic_ESCM
  
## Instrumenting MITgcm

MITgcm can be found at https://github.com/MITgcm/MITgcm and its documentation at
https://mitgcm.readthedocs.io/en/latest/

Clone MITgcm in a directory and follow the installation instructions for one of
the tutorials. We recommend to start with "Barotropic Ocean Gyre".
If you are able to run the model, it is time to instrument it.

Therefore, you use the following `linux_amd64_gfortran_kieker` setup file when
running genmake, e.g., `genmake2 -mods ../code -of linux_amd64_gfortran_kieker`

In the `linux_amd64_gfortran_kieker` you have to set the path to the kieker
library.

After successful compilation, you can start the collector and then run the
model according to the MITgcm documentation.

MITgcm can be compiled with gcc and gfortran.



  
