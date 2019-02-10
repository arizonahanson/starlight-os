
ISONIX=iso/iso.nix
CONFNIX=/mnt/etc/nixos/configuration.nix
ENVNIX=/mnt/etc/nixos/environment.nix
INSTCMD=os-install

default: iso

.PHONY: configure
configure: $(CONFNIX)

$(CONFNIX):
	@nixos-generate-config --root /mnt
	@cp -av template/. /mnt/etc/nixos/
	@cp -av config/. /mnt/etc/nixos/
	@echo "Edit the file '$(ENVNIX)' then run '$(INSTCMD)'."

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

.PHONY: drop
drop:
	@sudo nix-collect-garbage -d

.PHONY: upgrade
upgrade:
	@sudo nixos-rebuild --upgrade switch
	@sudo nix-collect-garbage
	@flatpak update -y

