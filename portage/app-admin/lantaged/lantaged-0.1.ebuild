# Copyright 2025 Lily
# Distributed under the terms of the AGPL-3.0 license

EAPI=8

DESCRIPTION="Server daemon for remote portage builds"
HOMEPAGE="https://github.com/user/lantage" # Replace with actual URL
SRC_URI="https://github.com/user/lantage/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz" # Replace with actual URL

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# No build-time dependencies, it's a standalone script
DEPEND=""
# Runtime dependency on python
RDEPEND=">dev-lang/python-3.6"

src_install() {
	# Use dosbin as it's a daemon
	dosbin lantaged
	# A real ebuild would also install an init script or systemd unit file
	# newinitd "${FILESDIR}/lantaged.initd" lantaged
}
