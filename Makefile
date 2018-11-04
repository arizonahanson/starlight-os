
ISONIX=iso/iso.nix
CONFNIX=/mnt/etc/nixos/configuration.nix

default: install

.PHONY: iso
iso:
	@nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=$(ISONIX)

.PHONY: configure
configure: $(CONFNIX)

$(CONFNIX):
	@nixos-generate-config --root /mnt
	@cp -av config/. /mnt/etc/nixos/

.PHONY: rebuild
rebuild:
	@sudo cp -av config/. /etc/nixos/
	@sudo nixos-rebuild switch

.PHONY: install
install: $(CONFNIX)
	@nixos-install --no-root-passwd --root /mnt

