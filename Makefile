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
	@cp -r init/. /mnt/etc/nixos/
	@cp -r config/. /mnt/etc/nixos/
	@echo "Edit the file '$(CONFNIX)' then run '$(INSTCMD)'."

.PHONY: install
install: $(CONFNIX)
	@nixos-install --no-root-passwd --root /mnt

.PHONY: iso
iso:
	@nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=$(ISONIX)

.PHONY: copy
copy:
	@echo "copying Nix configs..."
	@sudo cp -r config/. /etc/nixos/
	@bash ./scripts/channel

.PHONY: rebuild
rebuild: copy
	@echo "starting rebuild..."
	@sudo nixos-rebuild switch

.PHONY: upgrade
upgrade: copy
	@echo -e "Updating system..."
	@sudo nixos-rebuild --upgrade switch
	@nix-env -u

.PHONY: drop
drop:
	@echo -e "Dropping old derivations..."
	@sudo nix-collect-garbage -d
	@nix-env --delete-generations old
