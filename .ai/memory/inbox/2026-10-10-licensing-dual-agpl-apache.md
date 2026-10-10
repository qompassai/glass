# Licensing change — dual AGPL-3.0 / Apache-2.0 (2026-10-10)

Matt ruled 2026-10-10: "20 and 21 do dual agpl 3.0 and Apache 2.0 if
possible" (item 21 = glass; item 20 = volta, handled separately).
This closes the open licensing item in
2026-10-09-build-restoration.md.

Feasibility, as found in the tree: the bulk of glass is a derivative
of the RustDesk open-source server (AGPL-3.0 upstream; hbb_common
still carries the open-trade authorship). Qompass AI holds copyright
only in its first-party work, so the dual offer extends exactly that
far and no further:

- `LICENSE-APACHE` added (canonical Apache-2.0 text, appendix line
  "Copyright 2026 Qompass AI"). `LICENSE-AGPL` retained unchanged.
- `LICENSE-DUAL` added: first-party Qompass AI code is offered under
  AGPL-3.0-only OR Apache-2.0 at the recipient's option;
  upstream-derived portions remain AGPL-3.0 only; the combined work
  is distributed under AGPL-3.0 terms.
- `LICENSE-QCDA` deleted. Q-CDA removed from README (badge and
  dual-license text now AGPL-3.0 / Apache-2.0), `CITATION.cff`,
  `.zenodo.json`, and the first-party file headers. The only
  remaining Q-CDA mentions in the repo are this file's predecessor
  record (2026-10-09, historical) and the retirement sentence in
  LICENSE-DUAL itself.
- First-party headers — `libs/hbb_common/src/protos.rs`,
  `flake.nix`, `shell.nix`, `rust-toolchain.toml` — now read
  `SPDX-License-Identifier: AGPL-3.0-only OR Apache-2.0`.
- `Cargo.toml` (root + `libs/hbb_common`) gained
  `license = "AGPL-3.0-only"`: both crates are upstream-derived, so
  no crate carries the dual expression; single-value metadata names
  the license governing the combined work rather than overclaiming
  Apache-2.0 over upstream code. Same reasoning for `CITATION.cff`
  and `.zenodo.json` (`AGPL-3.0-only`).
- Untouched, deliberately: all upstream file headers,
  `debian/copyright` (already AGPL-3.0, accurate for the packaged
  derivative), the flake package meta license (`agpl3Only`, accurate
  for the built server), third-party dependencies.

Gates on primo (pinned Rust 1.96.0): `cargo build` green;
`cargo test --workspace` 18 passed / 0 failed (2 root + 16
hbb_common — baseline held); `nix build` produced all three
binaries (hbbs, hbbr, glass-utils); `nix flake check` — all checks
passed. Manifest changes were metadata-only (license fields), so
the loopback doctor smoke was not re-run; the nix package rebuild
from the changed tree serves as the build-level check.
