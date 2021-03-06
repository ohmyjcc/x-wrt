#
# Copyright (C) 2010 OpenWrt.org
#

PART_NAME=firmware
REQUIRE_IMAGE_METADATA=1

platform_check_image() {
	return 0
}

platform_pre_upgrade() {
	local board=$(board_name)

	case "$board" in
	mikrotik,rb750gr3|\
	mikrotik,rbm11g|\
	mikrotik,rbm33g)
		[ -z "$(rootfs_type)" ] && mtd erase firmware
		;;
	esac
}

platform_nand_pre_upgrade() {
	local board=$(board_name)

	case "$board" in
	ubnt-erx|\
	ubnt-erx-sfp)
		platform_upgrade_ubnt_erx "$ARGV"
		;;
	esac
}

platform_do_upgrade() {
	local board=$(board_name)

	case "$board" in
	hc5962|\
	mir3g|\
	netgear,r6220|\
	netgear,r6220a|\
	netgear,r6220b|\
	netgear,r6220c|\
	netgear,r6350|\
	ubnt-erx|\
	ubnt-erx-sfp)
		nand_do_upgrade "$ARGV"
		;;
	mir3g)
		# this make it compatible with breed
		dd if=/dev/mtd0 bs=1 count=64 2>/dev/null | grep -qi breed && CI_KERNPART_EXT="kernel_stock"
		nand_do_upgrade "$ARGV"
		;;
	xiaomi,miwifi-r3)
		# this make it compatible with breed
		dd if=/dev/mtd0 bs=1 count=64 2>/dev/null | grep -qi breed && CI_KERNPART_EXT="kernel0_rsvd"
		nand_do_upgrade "$ARGV"
		;;
	tplink,c50-v4)
		MTD_ARGS="-t romfile"
		default_do_upgrade "$ARGV"
		;;
	*)
		default_do_upgrade "$ARGV"
		;;
	esac
}
