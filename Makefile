
ISONIX=iso/iso.nix
CONFNIX=/mnt/etc/nixos/configuration.nix

default: install

.PHONY: iso
iso:
	@nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=$(ISONIX)

.PHONY: partition
partition:
	@sh ./scripts/partiton

.PHONY: configure
configure: $(CONFNIX)

$(CONFNIX):
	@nixos-generate-config --root /mnt
	@cp -av config/. /mnt/etc/nixos/

.PHONY: install
install: $(CONFNIX)
	@nixos-install --root /mnt

