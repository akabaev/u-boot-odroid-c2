# $FreeBSD: $

PORTNAME=	u-boot
PORTVERSION=	2015.01
CATEGORIES=	sysutils
PKGNAMESUFFIX=	-odroid-c2

MAINTAINER=	brd@FreeBSD.org
COMMENT=	Cross-build U-Boot loader for ODROID-C2

LICENSE=	GPLv2

BUILD_DEPENDS=	aarch64-none-elf-gcc:devel/aarch64-none-elf-gcc
# Runs linux/x86_64 binary to sign images
ONLY_FOR_ARCHS= amd64
USES=		linux
USE_LINUX=	base:build

USE_GITHUB=	yes
GH_ACCOUNT=	hardkernel
GH_PROJECT=	u-boot
GIT_TAG=	s905_6.0.1_v2.5
GH_TAGNAME=	${GIT_TAG}

#WRKSRC=		${WRKDIR}/u-boot-${DISTVERSION}
USES=		gmake tar:bzip2
SSP_UNSAFE=	yes # cross-LD does not support -fstack-protector

U_BOOT_DIR=     share/u-boot/${PORTNAME}${PKGNAMESUFFIX}
PLIST_FILES=	${U_BOOT_DIR}/bl1.bin.hardkernel \
		${U_BOOT_DIR}/sd_fusing.sh \
		${U_BOOT_DIR}/u-boot.bin \
		${U_BOOT_DIR}/README

MAKE_ARGS+=	ARCH=arm \
		CROSS_COMPILE=aarch64-none-elf- \
		CONFIG_API=y

do-configure:
	(cd ${WRKSRC}; ${MAKE_CMD} odroidc2_config)

do-install:
	${MKDIR} ${STAGEDIR}/${PREFIX}/${U_BOOT_DIR}
	${INSTALL_DATA} ${WRKSRC}/sd_fuse/bl1.bin.hardkernel ${STAGEDIR}/${PREFIX}/${U_BOOT_DIR}
	${INSTALL_DATA} ${WRKSRC}/sd_fuse/sd_fusing.sh ${STAGEDIR}/${PREFIX}/${U_BOOT_DIR}
	${INSTALL_DATA} ${WRKSRC}/sd_fuse/u-boot.bin ${STAGEDIR}/${PREFIX}/${U_BOOT_DIR}
	${INSTALL_DATA} ${DESCR} ${STAGEDIR}/${PREFIX}/${U_BOOT_DIR}/README

.include <bsd.port.mk>
