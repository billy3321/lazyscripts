
##Python 
PYTHON_VERSION = '2.6.0'

### DISTRIBUTION
# Debian base
DIST_DEBIAN = 'debian'
DIST_UBUNTU = 'ubuntu'
DIST_LINUXMINT = 'linuxmint'

DIST_DEB_BASE = \
        (DIST_DEBIAN,
         DIST_UBUNTU,
         DIST_LINUXMINT)


# RPM Base
DIST_REDHAT = 'redhat'
DIST_CENTOS = 'centos'
DIST_FEDORA = 'fedora'

DIST_SUSE = 'suse'
DIST_OPENSUSE = 'opensuse'
DIST_MANDRIVA = 'mandriva'

DIST_REDHAT_BASE = \
        (DIST_REDHAT,
         DIST_CENTOS,
         DIST_FEDORA)
DIST_RPM_BASE = \
        (DIST_REDHAT,
         DIST_CENTOS,
         DIST_FEDORA,
         DIST_SUSE,
         DIST_OPENSUSE,
         DIST_MANDRIVA)

# BSD Base
DIST_MACOSX = 'macosx'

### Architecture
ARCH_I386 = 'i386'
ARCH_AMD64 = 'amd64'

### System
SYSTEM_LINUX = 'Linux'
SYSTEM_MAC = 'Darwin'
# not ready
#SYSTEM_BSD = ''
