
ISONIX=iso/iso.nix

.PHONY: iso
iso:
	@nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=$(ISONIX)

.PHONY: install
install:
	@sh ./scripts/partition
	@nixos-generate-config --root /mnt
	@cp -a config/. /mnt/etc/nixos/
	@nixos-install --root /mnt

