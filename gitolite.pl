# http://gitolite.com/gitolite/gitweb.conf.html
# ----------------------------------------------------------------------

# Per-repo authorization for gitweb using gitolite v3 access rules
# Read comments, modify code as needed, and include in gitweb.conf

# ----------------------------------------------------------------------

# First, run 'gitolite query-rc -a' (as the gitolite hosting user) to find the
# values for GL_BINDIR and GL_LIBDIR in your installation.  Then use those
# values in the code below:

BEGIN {
	$ENV{HOME} = '/home/services/git';   # or whatever is the hosting user's $HOME
	$ENV{GL_BINDIR} = '/usr/share/gitolite';
	$ENV{GL_LIBDIR} = '/usr/share/gitolite/lib';
}

# Pull in gitolite's perl API module.  Among other things, this also sets the
# GL_REPO_BASE environment variable.
use lib $ENV{GL_LIBDIR};
use Gitolite::Easy;

# Set projectroot for gitweb.  If you already set it earlier in gitweb.conf
# you don't need this but please make sure the path you used is the same as
# the value of GL_REPO_BASE in the 'gitolite query-rc -a' output above.
$projectroot = $ENV{GL_REPO_BASE};

# Now get the user name.  Unauthenticated clients will be deemed to be the
# 'gitweb' user so make sure gitolite's conf file does not allow that user to
# see anything sensitive.
$ENV{GL_USER} = $cgi->remote_user || 'gitweb';

$export_auth_hook = sub {
	my $repo = shift;
	# gitweb passes us the full repo path; we need to strip the beginning and
	# the end, to get the repo name as it is specified in gitolite conf
	return unless $repo =~ s/^\Q$projectroot\E\/?(.+)\.git$/$1/;

	# call Easy.pm's 'can_read' function
	return can_read($repo);
};
