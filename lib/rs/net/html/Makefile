INSTALL_DIR=`rs --install`
PRODUCT=html
SCMFILES=html.scm htmlport.scm

${PRODUCT}.mif ${PRODUCT}.mx: ${SCMFILES}
	${INSTALL_DIR}/bin/rsc -p ${PRODUCT}.mcf

install::
	cp -p ${PRODUCT}.mif ${PRODUCT}.mx ${INSTALL_DIR}/resource/modules

clean::
	rm -f html.mif html.mx html.doc

