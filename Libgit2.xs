#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <git2.h>
#include <git2/repository.h>
#include <errno.h>

const char* error_string(signed char code)
{
  const char* rv;
  switch (code)
    { 
    case GIT_ERROR : rv = "operation failed"; break;
    case GIT_ENOTOID : rv = "object ID not well formed"; break;
    case GIT_ENOTFOUND : rv = "not found"; break;
    case GIT_ENOMEM : rv = "out of space"; break;
    case GIT_EOSERR : 
      if (errno > sys_nerr-1) {
	rv = "unknown OS error";
      }
      else {
	rv = sys_errlist[errno];
      };
      break;
    case GIT_EOBJTYPE : rv = "invalid object type"; break;
    case GIT_EOBJCORRUPTED : rv = "object data corrupted"; break;
    case GIT_ENOTAREPO : rv = "not a git repo"; break;
    case GIT_EINVALIDTYPE : rv = "object type mismatch"; break;
    case GIT_EMISSINGOBJDATA : rv = "object required field missing"; break;
    case GIT_EPACKCORRUPTED : rv = "packfile corrupt"; break;
    case GIT_EFLOCKFAIL : rv = "failed to acquire lock"; break;
    case GIT_EZLIB : rv = "zlib failure"; break;
    case GIT_EBUSY : rv = "object busy"; break;
    case GIT_EBAREINDEX : rv = "The index file is not backed up by an existing repository."; break;
    default : rv = "unknown error";
    }
  return rv;
}


MODULE = Git::Libgit2		PACKAGE = Git::Libgit2

PROTOTYPES: DISABLE

git_repository *
git_repository_open(gitdir)
  const char *gitdir;

  CODE:
    git_repository* repo;
    SV *isv, *self;
    int error = git_repository_open( &repo, gitdir );

    if (error != 0) {
      Perl_croak(aTHX_ "%s trying to open repository at %s\n",
		 error_string(error), gitdir);
    }

    RETVAL = repo;

  OUTPUT:
    RETVAL

