use v6.d.PREVIEW;
unit module DRMAA::Native-specification::SLURM:ver<0.0.1>:auth<Vittore F Scolari (vittore.scolari@gmail.com)>;

use DRMAA::Native-specification;
#use DRMAA::Session;

class DRMAA::Native-specification::SLURM does DRMAA::Native-specification {
    method init {
#	say DRMAA::Session.implementation;
    }
}

