use v6.c;
unit module DRMAA::Session:ver<0.0.1>:auth<Vittore F Scolari (vittore.scolari@gmail.com)>;

use NativeCall :types;
use NativeHelpers::CBuffer;
use DRMAA::NativeCall;
use DRMAA::Native-specification;
use X::DRMAA;

class DRMAA::Session {
    my DRMAA::Native-specification $native-specification;

    method new(|) { die "DRMAA::Session is a Singleton, it desn't need to be instantiated" };
    method bless(|) { die "DRMAA::Session is a Singleton, it desn't need to be instantiated" };

    method init(Str :$contact, DRMAA::Native-specification :native-specification(:$ns)) {
	my $contact-buf = CBuffer.new(DRMAA_CONTACT_BUFFER, :init($contact));
	my $error-buf = CBuffer.new(DRMAA_ERROR_STRING_BUFFER);
	LEAVE { $contact-buf.free; $error-buf.free; }

	my $error-num = drmaa_init($contact-buf, $error-buf, DRMAA_ERROR_STRING_BUFFER);

	fail X::DRMAA::from-code($error-num).new(:because($error-buf)) if ($error-num != DRMAA_ERRNO_SUCCESS);

	if (defined $ns) {
	    $native-specification = $ns;
	} else {
	    my $drm = self.DRM-system;
	    for %DRMAA::Native-specification::Builtin-specifications.kv -> $module, $match {
		if ($drm ~~ $match) {
		    require ::($module);

		    $native-specification = ::($module);
		    last;
		}
	    }
	}
    }

    method exit() is export {
	my $error-buf = CBuffer.new(DRMAA_ERROR_STRING_BUFFER);
	LEAVE { $error-buf.free; }

	my $error-num = drmaa_exit($error-buf, DRMAA_ERROR_STRING_BUFFER);

	fail X::DRMAA::from-code($error-num).new(:because($error-buf)) if ($error-num != DRMAA_ERRNO_SUCCESS);
    }

    method native-specification(--> DRMAA::Native-specification) {
	$native-specification;
    }
    
    method attribute-names(--> List) {
	my $values = Pointer[drmaa_attr_names_t].new;
	my $error-buf = CBuffer.new(DRMAA_ERROR_STRING_BUFFER);
	LEAVE { drmaa_release_attr_names($values.deref); $error-buf.free; }

	my $error-num = drmaa_get_attribute_names($values, $error-buf, DRMAA_ERROR_STRING_BUFFER);

	die X::DRMAA::from-code($error-num).new(:because($error-buf)) if ($error-num != DRMAA_ERRNO_SUCCESS);
	(Seq.new($values.deref).map: { LEAVE { .free }; .Str; }).list.eager;
    }

    method vector-attribute-names(--> List) {
	my $values = Pointer[drmaa_attr_names_t].new;
	my $error-buf = CBuffer.new(DRMAA_ERROR_STRING_BUFFER);
	LEAVE { drmaa_release_attr_names($values.deref); $error-buf.free; }

	my $error-num = drmaa_get_vector_attribute_names($values, $error-buf, DRMAA_ERROR_STRING_BUFFER);

	die X::DRMAA::from-code($error-num).new(:because($error-buf)) if ($error-num != DRMAA_ERRNO_SUCCESS);
	(Seq.new($values.deref).map: { LEAVE { .free }; .Str; }).list.eager;
    }

    method contact(--> Str) {
	my $contact-buf = CBuffer.new(DRMAA_CONTACT_BUFFER);
	my $error-buf = CBuffer.new(DRMAA_ERROR_STRING_BUFFER);
	LEAVE { $contact-buf.free; $error-buf.free; }

	my $error-num = drmaa_get_contact($contact-buf, DRMAA_CONTACT_BUFFER,
					  $error-buf, DRMAA_ERROR_STRING_BUFFER);

	die X::DRMAA::from-code($error-num).new(:because($error-buf)) if ($error-num != DRMAA_ERRNO_SUCCESS);
	$contact-buf.Str;
    }

    method DRM-system(--> Str) {
	my $drm-buf = CBuffer.new(DRMAA_DRM_SYSTEM_BUFFER);
	my $error-buf = CBuffer.new(DRMAA_ERROR_STRING_BUFFER);
	LEAVE { $drm-buf.free; $error-buf.free; }

	my $error-num = drmaa_get_DRM_system($drm-buf, DRMAA_DRM_SYSTEM_BUFFER,
					     $error-buf, DRMAA_ERROR_STRING_BUFFER);

	die X::DRMAA::from-code($error-num).new(:because($error-buf)) if ($error-num != DRMAA_ERRNO_SUCCESS);
	$drm-buf.Str;
    }

    method implementation(--> Str) {
	my $drmaa-buf = CBuffer.new(DRMAA_DRM_SYSTEM_BUFFER);
	my $error-buf = CBuffer.new(DRMAA_ERROR_STRING_BUFFER);
	LEAVE { $drmaa-buf.free; $error-buf.free; }

	my $error-num = drmaa_get_DRMAA_implementation($drmaa-buf, DRMAA_DRM_SYSTEM_BUFFER,
						       $error-buf, DRMAA_ERROR_STRING_BUFFER);

	die X::DRMAA::from-code($error-num).new(:because($error-buf)) if ($error-num != DRMAA_ERRNO_SUCCESS);
	$drmaa-buf.Str;
    }

    method version(--> Version) {
	my int32 $major;
	my int32 $minor;
	my $error-buf = CBuffer.new(DRMAA_ERROR_STRING_BUFFER);
	LEAVE { $error-buf.free; }

	my $error-num = drmaa_version($major, $minor,
				      $error-buf, DRMAA_ERROR_STRING_BUFFER);

	die X::DRMAA::from-code($error-num).new(:because($error-buf)) if ($error-num != DRMAA_ERRNO_SUCCESS);
	Version.new("$major.$minor");
    }
}
