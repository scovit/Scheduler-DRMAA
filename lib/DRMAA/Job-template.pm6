use v6.c;
unit module DRMAA::Job-template:ver<0.0.1>:auth<Vittore F Scolari (vittore.scolari@gmail.com)>;

use NativeCall :types;
use NativeHelpers::CBuffer;
use DRMAA::NativeCall;
use X::DRMAA;
use DRMAA::Submission;

class DRMAA::Job-template {
    method run(--> DRMAA::Submission) { };
}
