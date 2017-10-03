use v6.c;

unit module DRMAA::Submission::Status:ver<0.0.1>:auth<Vittore F Scolari (vittore.scolari@gmail.com)>;

class X::DRMAA::Submission::Status::Aborted is Exception {
    has Str $.id;
    has Int $.exited;
    has Int $.exit-code;
    has Str $.signal;
}

class DRMAA::Submission::Status::Succeded {
    has Str $.id;
    has Int $.exited;
    has Int $.exit-code;
    has Str $.signal;
}
