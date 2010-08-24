# :vim: filetype=make : -*- mode: makefile; coding: utf-8; -*-

# setuptools.mk
#
# Copyright © 2006-2008 Ben Finney <ben+python@benfinney.id.au>
# This is free software; you may copy, modify and/or distribute this work
# under the terms of the GNU General Public License, version 2 or later.
# No warranty expressed or implied. See the file LICENSE for details.

# Makefile rules for Python setuptools

MODULE_DIR := .

PREFIX ?= /usr/local

PYVERS := 2.4 2.5
PYTHON := python
PYTHON_SETUP_SCRIPT := ${MODULE_DIR}/setup.py
PYTHON_SETUP := $(PYTHON) ${PYTHON_SETUP_SCRIPT}

PYTHON_BDIST_TARGETS := bdist_egg

GENERATED_FILES += ${MODULE_DIR}/MANIFEST.in
GENERATED_FILES += ${MODULE_DIR}/*.egg-info
GENERATED_FILES += ${MODULE_DIR}/build/
GENERATED_FILES += ${MODULE_DIR}/dist/

VCS_INVENTORY ?= bzr inventory


.PHONY: setuptools-register
setuptools-register:
	$(PYTHON_SETUP) register

.PHONY: setuptools-sign
setuptools-sign:
	$(PYTHON_SETUP) sign

.PHONY: setuptools-upload
setuptools-upload:
	$(PYTHON_SETUP) upload

.PHONY: setuptools-test
setuptools-test:
	$(PYTHON_SETUP) test


.PHONY: setuptools-build
setuptools-build:
	$(PYTHON_SETUP) build

.PHONY: setuptools-install
setuptools-install:
	$(PYTHON_SETUP) install --prefix=${PREFIX}


.PHONY: setuptools-dist-upload
setuptools-dist: setuptools-register setuptools-sdist ${PYTHON_BDIST_TARGETS}
	$(PYTHON_SETUP) sdist ${PYTHON_BDIST_TARGETS} upload

.PHONY: setuptools-bdist
setuptools-bdist: ${PYTHON_BDIST_TARGETS}
.PHONY: ${PYTHON_BDIST_TARGETS}
${PYTHON_BDIST_TARGETS}:
	for ver in ${PYVERS} ; do \
		python$${ver} ${PYTHON_SETUP_SCRIPT} $@ ; \
	done

.PHONY: setuptools-sdist
setuptools-sdist: MANIFEST.in
	$(PYTHON_SETUP) sdist

MANIFEST.in:
	( \
		$(VCS_INVENTORY) \
		| sed -e 's/^/include /' \
	) > $@


.PHONY: setuptools-clean
setuptools-clean:
	$(PYTHON_SETUP) clean


# Local Variables:
# mode: makefile
# coding: utf-8
# End:
# vim: filetype=make fileencoding=utf-8 :
