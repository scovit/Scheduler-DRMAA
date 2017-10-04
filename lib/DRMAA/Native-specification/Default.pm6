use v6.d.PREVIEW;
unit module DRMAA::Native-specification::Default:ver<0.0.1>:auth<Vittore F Scolari (vittore.scolari@gmail.com)>;

use DRMAA::Native-specification;
use DRMAA::Session;

class DRMAA::Native-specification::Default does DRMAA::Native-specification {
    method init {
	warn 'WARNING, DRM-system "', DRMAA::Session.DRM-system, '" unknown', "\n",
	     "Using default Native specification plugin, it sucks,\n",
	     "please implement one for your configuration,\n",
	     "patches are wellcome!\n";
    }
}

