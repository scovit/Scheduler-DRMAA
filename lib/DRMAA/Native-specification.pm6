use v6.c;
unit module DRMAA::Native-specification:ver<0.0.1>:auth<Vittore F Scolari (vittore.scolari@gmail.com)>;

role DRMAA::Native-specification {

}

our @Builtin-specifications =
    "DRMAA::Native-specification::SLURM",      /^SLURM/,
    "DRMAA::Native-specification::Default",    /.*/;

