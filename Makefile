DOMAIN=lazyscripts
COPYRIGHT_YEAR=2010
PYSRC=${DOMAIN}
PODIR=${PWD}/po
POFILE=${PODIR}/${DOMAIN}.pot
FIRST AUTHOR=Hsin-Yi Chen <ossug.hychen@gmail.com>, ${COPYRIGHT_YEAR}
REV_DATE=`date '+%F %R+%Z'`
LANGUAGE_TEAM=Lazyscripts Developers <lazyscripts-dev@googlegroups.com>
PODESC=lazyscripts is a script management tool
PYTHON=`which python`
DESTDIR=/
BUILDIR=$(CURDIR)/debian/lazyscripts
PROJECT=lazyscripts
VERSION=0.2.3.9

all:
	@echo "make source - Create source package"
	@echo "make install - Install on local system"
	@echo "make buildrpm - Generate a rpm package"
	@echo "make builddeb - Generate a deb package"
	@echo "make clean - Get rid of scratch and byte files"

source:
	$(PYTHON) setup.py sdist $(COMPILE)

install:
	$(PYTHON) setup.py install --root $(DESTDIR) $(COMPILE)

run:
	$(PATHON) -c "from lazyscripts import console; console.gui_run()"

buildrpm:
	$(PYTHON) setup.py bdist_rpm --post-install=rpm/postinstall --pre-uninstall=rpm/preuninstall

builddeb:
	# build the source package in the parent directory
	# then rename it to project_version.orig.tar.gz
	$(PYTHON) setup.py sdist $(COMPILE) --dist-dir=../
	rename -f 's/$(PROJECT)-(.*)\.tar\.gz/$(PROJECT)_$$1\.orig\.tar\.gz/' ../*
	# build the package
	dpkg-buildpackage -i -I -rfakeroot

clean:
	$(PYTHON) setup.py clean
	$(MAKE) -f $(CURDIR)/debian/rules clean
	rm -rf build/ MANIFEST
	find . -name '*.pyc' -delete
update_pot:
	@echo -n "updating po file of ${DOMAIN} - "
	@pygettext -p ${PODIR} -d ${DOMAIN} ${PYSRC}
	@sed -i "s/CHARSET/utf-8/" ${POFILE}
	@sed -i "s/ENCODING/utf-8/" ${POFILE}
	@sed -i "s/YEAR ORGANIZATION/${COPYRIGHT_YEAR} Lazyscripts Developers/" ${POFILE}
	@sed -i "s/FIRST AUTHOR <EMAIL@ADDRESS>, YEAR/Hsin-Yi Chen <ossug.hychen@gmail.com>, ${COPYRIGHT_YEAR}/" ${POFILE}
	@sed -i "s/YEAR-MO-DA HO:MI+ZONE/${REV_DATE}/" ${POFILE}
	@sed -i 's/LANGUAGE <LL@li.org>/${LANGUAGE_TEAM}/' ${POFILE}
	@sed -i 's/SOME DESCRIPTIVE TITLE/${PODESC}/' ${POFILE}
	@echo done!
