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
- Instrumenting the Shallow Water Model (SWM)

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

