
ISONIX=iso/iso.nix
CONFNIX=/mnt/etc/nixos/configuration.nix
INSTCMD=os-install

default: iso

# WARNING: WILL PARTITION YOUR DISK DRIVE!!!
.PHONY: configure
configure: $(CONFNIX)

$(CONFNIX):
	@bash ./scripts/partition
	@nixos-generate-config --root /mnt
	@cp -av init/. /mnt/etc/nixos/
	@cp -av config/. /mnt/etc/nixos/
	@echo "Edit the file '$(CONFNIX)' then run '$(INSTCMD)'."

.PHONY: install
install: $(CONFNIX)
	@nixos-install --no-root-passwd --root /mnt

.PHONY: iso
iso:
	@nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=$(ISONIX)

.PHONY: rebuild
rebuild:
	@echo "copying Nix configs..."
	@sudo cp -a config/. /etc/nixos/
	@echo "starting rebuild..."
	@sudo nixos-rebuild switch
	@sudo nix-collect-garbage

.PHONY: upgrade
upgrade:
	@echo -e "Updating system..."
	@sudo cp -a config/. /etc/nixos/
	@sudo nixos-rebuild --upgrade switch
	@sudo nix-collect-garbage
