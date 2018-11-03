
ISONIX=iso/iso.nix

.PHONY: iso
iso:
	@nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=$(ISONIX)

.PHONY: install
install:
	@echo "not implemented"
