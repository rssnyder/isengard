build:
	sudo cp playbooks/templates/t480-0/configuration.nix /etc/nixos/ && sudo chown root:root /etc/nixos/configuration.nix && sudo nixos-rebuild build

test:
	sudo cp playbooks/templates/t480-0/configuration.nix /etc/nixos/ && sudo chown root:root /etc/nixos/configuration.nix && sudo nixos-rebuild test

switch:
	sudo cp playbooks/templates/t480-0/configuration.nix /etc/nixos/ && sudo chown root:root /etc/nixos/configuration.nix && sudo nixos-rebuild switch
