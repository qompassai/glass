# ---------------------------------------------------------------------------
# /qompassai/glass/shell.nix
# Qompass AI Glass — legacy nix-shell entry point (compat shim)
# SPDX-License-Identifier: AGPL-3.0-only OR Apache-2.0
# Copyright (c) 2026 Qompass AI
#
# This file is first-party Qompass AI code, dual-licensed under the
# AGPL-3.0 or Apache-2.0, at your option. See LICENSE-AGPL and
# LICENSE-APACHE at the repository root, and LICENSE-DUAL for the
# scope of the dual license.
#
# The canonical Nix entry point is flake.nix; this shim only forwards
# `nix-shell` to the flake's dev shell for users without flakes
# enabled by default.

{ system ? builtins.currentSystem }:

(builtins.getFlake (toString ./.)).devShells.${system}.default
