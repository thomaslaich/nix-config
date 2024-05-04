default:
  rebuild && hm-switch

rebuild:
  rebuild

hm-switch:
  hm-switch

format:
  nix fmt

check:
  nix flake check --impure
