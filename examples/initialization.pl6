use DRMAA;

DRMAA::Session.init; # Error handling is automatic

say "DRMAA library was started successfully";

DRMAA::Session.exit;
