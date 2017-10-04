use v6.d.PREVIEW;

unit module DRMAA::Submission::Status:ver<0.0.1>:auth<Vittore F Scolari (vittore.scolari@gmail.com)>;

class X::DRMAA::Submission::Status::Aborted is Exception {
    has Str  $.id;
    has Bool $.exited;
    has Int  $.exit-code;
    has Str  $.signal;
    has Str  $.usage;

    method message(--> Str:D) {
	"Job $.id aborted";
    }
}

class DRMAA::Submission::Status::Succeded {
    has Str  $.id;
    has Bool $.exited;
    has Int  $.exit-code;
    has Str  $.signal;
    has Str  $.usage;
}
