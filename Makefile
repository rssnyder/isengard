build:
	sudo cp playbooks/templates/t480-0/* /etc/nixos/ && sudo chown root:root /etc/nixos/* && sudo nixos-rebuild build

test:
	sudo cp playbooks/templates/t480-0/* /etc/nixos/ && sudo chown root:root /etc/nixos/* && sudo nixos-rebuild test

switch:
	sudo cp playbooks/templates/t480-0/* /etc/nixos/ && sudo chown root:root /etc/nixos/* && sudo nixos-rebuild switch
