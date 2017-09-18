use v6.c;
unit module DRMAA::Session:ver<0.0.1>:auth<Vittore F Scolari (vittore.scolari@gmail.com)>;

use NativeCall :types;
use NativeHelpers::CBuffer;
use DRMAA::NativeCall;
use X::DRMAA;

class DRMAA::Session {
    method new(|) { die "DRMAA::Session is a Singleton, it desn't need to be instantiated" };
    method bless(|) { die "DRMAA::Session is a Singleton, it desn't need to be instantiated" };

    method init(Str $contact?) {
	my $contact-buf = CBuffer.new(DRMAA_CONTACT_BUFFER, :init($contact));
	my $error-buf = CBuffer.new(DRMAA_ERROR_STRING_BUFFER);
	LEAVE { $contact-buf.free; $error-buf.free; }

	my $error-num = drmaa_init($contact-buf, $error-buf, DRMAA_ERROR_STRING_BUFFER);

	fail X::DRMAA::from-code($error-num).new(:because($error-buf)) if ($error-num != DRMAA_ERRNO_SUCCESS);
    }

    method exit() is export {
	my $error-buf = CBuffer.new(DRMAA_ERROR_STRING_BUFFER);
	LEAVE { $error-buf.free; }

	my $error-num = drmaa_exit($error-buf, DRMAA_ERROR_STRING_BUFFER);

	fail X::DRMAA::from-code($error-num).new(:because($error-buf)) if ($error-num != DRMAA_ERRNO_SUCCESS);
    }

    method attribute-names(--> List) {
	my $values = Pointer[drmaa_attr_names_t].new;
	my $error-buf = CBuffer.new(DRMAA_ERROR_STRING_BUFFER);
	LEAVE { drmaa_release_attr_names($values.deref); $error-buf.free; }

	my $error-num = drmaa_get_attribute_names($values, $error-buf, DRMAA_ERROR_STRING_BUFFER);

	fail X::DRMAA::from-code($error-num).new(:because($error-buf)) if ($error-num != DRMAA_ERRNO_SUCCESS);
	(Seq.new($values.deref).map: { LEAVE { .free }; .Str; }).list.eager;
    }

    method vector-attribute-names(--> List) {
	my $values = Pointer[drmaa_attr_names_t].new;
	my $error-buf = CBuffer.new(DRMAA_ERROR_STRING_BUFFER);
	LEAVE { drmaa_release_attr_names($values.deref); $error-buf.free; }

	my $error-num = drmaa_get_vector_attribute_names($values, $error-buf, DRMAA_ERROR_STRING_BUFFER);

	fail X::DRMAA::from-code($error-num).new(:because($error-buf)) if ($error-num != DRMAA_ERRNO_SUCCESS);
	(Seq.new($values.deref).map: { LEAVE { .free }; .Str; }).list.eager;
    }
}
