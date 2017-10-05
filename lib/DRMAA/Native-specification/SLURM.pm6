use v6.d.PREVIEW;
unit module DRMAA::Native-specification::SLURM:ver<0.0.1>:auth<Vittore F Scolari (vittore.scolari@gmail.com)>;

use DRMAA::Native-specification;
#use DRMAA::Session;
use DRMAA::Submission;
use DRMAA::Job-template;

class DRMAA::Native-specification::SLURM does DRMAA::Native-specification {
    method init {
#	say DRMAA::Session.implementation;
    }

    method job-template-afterany(DRMAA::Job-template:D $what, $after) {
	$what.native-specification ~= " --dependency=afterany:" ~ join(":", $after.map: { $_.job-id }) ~ " ";
    };

    method submission-then(DRMAA::Submission:D $after, DRMAA::Job-template:D $what --> DRMAA::Submission) {
	.job-template-afterany($what, $after);

	$what.run;
    }
}
