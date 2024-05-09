default:
  sudo rebuild && hm-switch

rebuild:
  sudo rebuild

hm-switch:
  hm-switch

format:
  nix fmt

check:
  nix flake check --impure

update:
  nix flake update && rebuild && hm-switch
