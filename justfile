build: test
	cargo build

test:
	cargo test

start-nix:
	podman run --rm -it -v $PWD:/workspace:z nixos/nix bash
	# nix build --extra-experimental-features nix-command --extra-experimental-features flakes /workspace