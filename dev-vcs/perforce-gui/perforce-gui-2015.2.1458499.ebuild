# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit versionator eutils

REL=$(get_version_component_range 1-2)
SHORTREL=${REL/#20/}

DESCRIPTION="GUI for Perforce version control system"
HOMEPAGE="http://www.perforce.com/"
SRC_URI="x86? (
	ftp://ftp.perforce.com/perforce/r${SHORTREL}/bin.linux26x86/p4v.tgz -> \
	${PF}-x86.tgz )
	amd64? (
	ftp://ftp.perforce.com/perforce/r${SHORTREL}/bin.linux26x86_64/p4v.tgz -> \
	${PF}-amd64.tgz )"

LICENSE="perforce"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
RESTRICT="mirror strip test"

S=${WORKDIR}

RDEPEND="
	dev-qt/qtgui:5
"

src_install() {
	cd p4v-${PVR} || die
	[[ -f bin/assistant ]] && rm bin/assistant

	dodir "/opt/${PN}"
	cp -R * "${D}/opt/${PN}" || die "Install failed!"

	for i in bin/* ; do
		if [[ ${i} != *'.bin' && ${i} != *'.conf' ]]; then
			make_wrapper "$(basename ${i})" "/opt/${PN}/${i}"
		fi
	done

	newicon "lib/p4v/P4VResources/icons/P4-V_96x96.png" "p4v.png"
	make_desktop_entry "p4v" "P4V" "p4v" "Development;"
	newicon "lib/p4v/P4VResources/icons/P4-Admin_96x96.png" "p4admin.png"
	make_desktop_entry "p4admin" "P4Admin" "p4admin" "Development;"
	newicon "lib/p4v/P4VResources/icons/P4-Merge_96x96.png" "p4merge.png"
	make_desktop_entry "p4merge" "P4Merge" "p4merge" "Development;"

	dodir /etc/revdep-rebuild
	echo "SEARCH_DIRS_MASK=\"/opt/${PN}\""> "${ED}/etc/revdep-rebuild/50-perforce-gui"
}
