setup-fedora:
	sudo dnf install -y coreos-installer butane qemu
	mkdir -p images/
	coreos-installer download -s "stable" -p qemu -f qcow2.xz --decompress -C images/
ignite:
	butane --pretty --strict betterbell.bu > images/betterbell.ign
qemu:
	#!/usr/bin/env bash
	set -euxo pipefail
	pattern="images/fedora-coreos-*.qcow2"
	files=( $pattern )
	qemu-kvm -m 2048 -cpu host -nographic -snapshot \
		-drive if=virtio,file=${files[0]} -fw_cfg name=opt/com.coreos/config,file=images/betterbell.ign \
		-nic user,model=virtio,hostfwd=tcp::2222-:22,hostfwd=tcp::3333-:3333 \
		-audiodev pa,id=snd0 -device ich9-intel-hda -device hda-output,audiodev=snd0
