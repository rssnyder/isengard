nix:
	sudo cp configuration.nix /etc/nixos/ && sudo chown root:root /etc/nixos/configuration.nix && sudo nixos-rebuild switch --upgrade
