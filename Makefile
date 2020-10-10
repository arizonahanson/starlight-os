ISONIX=iso/iso.nix

default: upgrade

.PHONY: iso
iso:
	nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=$(ISONIX) -o "/var/tmp/starlight-iso"

.PHONY: copy
copy:
	@echo "copying Nix configs..."
	@sudo cp -r config/. /etc/nixos/
	@bash ./scripts/channel

.PHONY: expire
expire:
	nix-collect-garbage --delete-older-than 2w
	nix-env --delete-generations 14d

.PHONY: rebuild
rebuild: copy
	@echo "starting rebuild..."
	@sudo nixos-rebuild switch

.PHONY: update
update: upgrade
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
