inherit user

DESCRIPTION="Maven Repository Manager"
HOMEPAGE="http://nexus.sonatype.org/"
LICENSE="GPL-3"
SRC_URI="http://www.sonatype.org/downloads/nexus-${PV}-01-bundle.zip"
RESTRICT="mirror"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE=""

S="${WORKDIR}"

RDEPEND=">=virtual/jdk-1.6"

INSTALL_DIR="/opt/nexus"

WEBAPP_DIR="${INSTALL_DIR}/nexus-oss-webapp"

pkg_setup() {
    enewgroup nexus
    enewuser nexus -1 /bin/bash /opt/nexus "nexus"
}

src_unpack() {
    unpack ${A}
    cd "${S}"
    rm  -rf nexus-${PV}-01/bin/jsw/solaris* \
       nexus-${PV}-01/bin/jsw/windows* \
       nexus-${PV}-01/bin/jsw/macosx* \
       nexus-${PV}-01/bin/jsw/linux-ppc*
    rm nexus-${PV}-01/bin/jsw/lib/libwrapper-solaris* \
       nexus-${PV}-01/bin/nexus.bat \
       nexus-${PV}-01/bin/jsw/lib/wrapper-windows* \
       nexus-${PV}-01/bin/jsw/lib/libwrapper-macosx* \
       nexus-${PV}-01/bin/jsw/lib/libwrapper-linux-ppc*
    if [[ ${KEYWORDS} =~ amd64 ]] && [[ ${KEYWORDS} =~ x86 ]]
	then
		#do nothing
		MULTILIB=1
	elif [[ ${KEYWORDS} =~ amd64 ]]
	then
		rm /opt/nexus/nexus-oss-webapp/bin/jsw/lib/libwrapper-linux-x86-32.so 
		rm -rf /opt/nexus/nexus-oss-webapp/bin/jsw/linux-x86-32/
	elif [[ ${KEYWORDS} =~ x86 ]]
	then
		rm /opt/nexus/nexus-oss-webapp/bin/jsw/lib/libwrapper-linux-x86-64.so 
		rm -rf /opt/nexus/nexus-oss-webapp/bin/jsw/linux-x86-64/
	fi
}

src_install() {
    insinto ${WEBAPP_DIR}
    doins -r nexus-${PV}-01/*

    newinitd "${FILESDIR}/init.sh" nexus

    fowners -R nexus:nexus ${INSTALL_DIR}
    fperms 755 "${INSTALL_DIR}/nexus-oss-webapp/bin/jsw/linux-x86-64/wrapper"
}
