use v6.c;
unit module DRMAA:ver<0.0.1>:auth<Vittore F Scolari (vittore.scolari@gmail.com)>;

# see Scheduler::DRMAA for the documentation

use DRMAA::Session;
use DRMAA::NativeCall;
use X::DRMAA;
use DRMAA::Job-template;
use DRMAA::Submission;

sub await (DRMAA::Submission:D $s) is export {
    $s.result;
}
