# shepherd Testing

## Install

You'll need Python 3.7, or newer:

    git clone --recurse-submodules https://gitlab.internal.sanger.ac.uk/hgi/shepherd-testing.git
    python3.7 -m venv .venv
    source .venv/bin/activate
    pip install -U pip setuptools wheel -r requirements.txt

## Submit

1. Create a subdirectory in `run`, say named `RUN_DIR`;
2. Copy your FoFN, which must be named `fofn`, to this directory (i.e.,
   `run/RUN_DIR/fofn`);
3. `./shepherd.sh submit RUN_DIR`.

This will transfer the files listed in your FoFN to iRODS, in
`/humgen/archive/RUN_DIR` (by default), with common prefixes stripped.
All logs will be written to `run/RUN_DIR`.

**NOTE** Your FoFN must be `\n`-delimited absolute paths.

The following environment variables can be used to override the default
behaviour:

* `PREP_QUEUE` sets the LSF queue for the preparation phase (defaults to
  `normal`);
* `TRANSFER_QUEUE` sets the LSF queue for the transfer phase (defaults
  to `long`);
* `IRODS_BASE` sets the base collection into which to transfer (defaults
  to `/humgen/archive`).

## Status

    shepherd.sh status JOB_ID

...where `JOB_ID` is the shepherd job ID, which is reported on
submission. Note that this is not the same as the LSF job IDs; you can
look up the shepherd job ID, should you forget it, by looking through
the submission log (i.e., `run/RUN_DIR/submit.log`).
