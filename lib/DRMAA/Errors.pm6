use v6.c;
unit module DRMAA::Errors:ver<0.0.1>:auth<Vittore F Scolari (vittore.scolari@gmail.com)>;

class X::DRMAA::Success is Exception is export {
    has $.because;

    method message() {
	"No error happened, you told me to fail xD";
    }
}

class X::DRMAA::Internal is Exception is export {
    has $.because;

    method message() {
        "Internal error: $.because";
    }
}

class X::DRMAA::DRM_communication is Exception is export {
    has $.because;
    method message() {
        "DRM communication: $.because"
    }
}

class X::DRMAA::Auth is Exception is export {
    has $.because;
    method message() {
        "Authorization error: $.because"
    }
}

class X::DRMAA::Invalid-argument is Exception is export {
    has $.because;
    method message() {
        "Invalid argument: $.because"
    }
}

class X::DRMAA::No-active-session is Exception is export {
    has $.because;
    method message() {
        "No active session: $.because"
    }
}

class X::DRMAA::No-memory is Exception is export {
    has $.because;
    method message() {
        "Out of memory: $.because"
    }
}

class X::DRMAA::Invalid-contact-string is Exception is export {
    has $.because;
    method message() {
        "Invalid contact string: $.because"
    }
}

class X::DRMAA::Default-contact-string is Exception is export {
    has $.because;
    method message() {
        "Default contact string: $.because"
    }
}

class X::DRMAA::No-default-contact-string-selected is Exception is export {
    has $.because;
    method message() {
        "No default contact string selected: $.because"
    }
}

class X::DRMAA::DRMS_init-failed is Exception is export {
    has $.because;
    method message() {
        "DRMS init failed: $.because"
    }
}

class X::DRMAA::Already-active-session is Exception is export {
    has $.because;
    method message() {
        "Already active session: $.because"
    }
}

class X::DRMAA::DRMS-exit-error is Exception is export {
    has $.because;
    method message() {
        "DRMS exit error: $.because"
    }
}

class X::DRMAA::Invalid-attribute-format is Exception is export {
    has $.because;
    method message() {
        "Invalid attribute format: $.because"
    }
}

class X::DRMAA::Invalid-attribute-value is Exception is export {
    has $.because;
    method message() {
        "Invalid attribute value: $.because"
    }
}

class X::DRMAA::Conflicting-attribute-values is Exception is export {
    has $.because;
    method message() {
        "Conflicting attribute values: $.because"
    }
}

class X::DRMAA::Try-later is Exception is export {
    has $.because;
    method message() {
        "Try later: $.because"
    }
}

class X::DRMAA::Denied-by-DRM is Exception is export {
    has $.because;
    method message() {
        "Denied by DRM: $.because"
    }
}

class X::DRMAA::Invalid-job is Exception is export {
    has $.because;
    method message() {
        "Invalid job: $.because"
    }
}

class X::DRMAA::Resume-inconsistent-state is Exception is export {
    has $.because;
    method message() {
        "Resume in an inconsistent state: $.because"
    }
}

class X::DRMAA::Suspend-inconsistent-state is Exception is export {
    has $.because;
    method message() {
        "Suspend in an inconsistent state: $.because"
    }
}

class X::DRMAA::Hold-inconsistent-state is Exception is export {
    has $.because;
    method message() {
        "Hold in an inconsistent state: $.because"
    }
}

class X::DRMAA::Release-inconsistent-state is Exception is export {
    has $.because;
    method message() {
        "Release in an inconsistent state: $.because"
    }
}

class X::DRMAA::Exit-timeout is Exception is export {
    has $.because;
    method message() {
        "Exit timeout expired: $.because"
    }
}

class X::DRMAA::No-rusage is Exception is export {
    has $.because;
    method message() {
        "No rusage: $.because"
    }
}

class X::DRMAA::No-more-elements is Exception is export {
    has $.because;
    method message() {
        "No more elements: $.because"
    }
}

class X::DRMAA::Unknown is Exception is export {
    has $.because;
    method message() {
        "Exceptional error: $.because"
    }
}

my $codes = (
    X::DRMAA::Success,
    X::DRMAA::Internal,
    X::DRMAA::DRM_communication,
    X::DRMAA::Auth,
    X::DRMAA::Invalid-argument,
    X::DRMAA::No-active-session,
    X::DRMAA::No-memory,
    X::DRMAA::Invalid-contact-string,
    X::DRMAA::Default-contact-string,
    X::DRMAA::No-default-contact-string-selected,
    X::DRMAA::DRMS_init-failed,
    X::DRMAA::Already-active-session,
    X::DRMAA::DRMS-exit-error,
    X::DRMAA::Invalid-attribute-format,
    X::DRMAA::Invalid-attribute-value,
    X::DRMAA::Conflicting-attribute-values,
    X::DRMAA::Try-later,
    X::DRMAA::Denied-by-DRM,
    X::DRMAA::Invalid-job,
    X::DRMAA::Resume-inconsistent-state,
    X::DRMAA::Suspend-inconsistent-state,
    X::DRMAA::Hold-inconsistent-state,
    X::DRMAA::Release-inconsistent-state,
    X::DRMAA::Exit-timeout,
    X::DRMAA::No-rusage,
    X::DRMAA::No-more-elements,
    X::DRMAA::Unknown
);

our sub from-code(Int $num --> Exception) {
    return $codes[$num];
}
