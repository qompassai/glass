# ---------------------------------------------------------------------------
# /qompassai/glass/shell.nix
# Qompass AI Glass — legacy nix-shell entry point (compat shim)
# SPDX-License-Identifier: AGPL-3.0-only
# Copyright (c) 2026 Qompass AI
#
# This project is distributed under the repository's dual-license
# scheme: AGPL-3.0 for non-commercial use, Q-CDA 1.0 for commercial
# use. See LICENSE-AGPL and LICENSE-QCDA at the repository root.
#
# The canonical Nix entry point is flake.nix; this shim only forwards
# `nix-shell` to the flake's dev shell for users without flakes
# enabled by default.

{ system ? builtins.currentSystem }:

(builtins.getFlake (toString ./.)).devShells.${system}.default
