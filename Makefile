
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
	@echo "copying Nix configs..."
	@sudo cp -a config/. /etc/nixos/
	@echo "starting rebuild..."
	@sudo nixos-rebuild switch
	@sudo nix-collect-garbage

.PHONY: drop
drop:
	@sudo nix-collect-garbage -d

.PHONY: upgrade
upgrade:
	@sudo nixos-rebuild --upgrade switch
	@sudo nix-collect-garbage

.PHONY: install
install: $(CONFNIX)
	@nixos-install --no-root-passwd --root /mnt

