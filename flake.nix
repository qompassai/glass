# ---------------------------------------------------------------------------
# /qompassai/glass/flake.nix
# Qompass AI Glass — Nix flake: server package and development shell
# SPDX-License-Identifier: AGPL-3.0-only
# Copyright (c) 2026 Qompass AI
#
# This project is distributed under the repository's dual-license
# scheme: AGPL-3.0 for non-commercial use, Q-CDA 1.0 for commercial
# use. See LICENSE-AGPL and LICENSE-QCDA at the repository root.
#
# packages.default builds the three server binaries (hbbs, hbbr,
# glass-utils) with the exact Rust toolchain pinned in
# rust-toolchain.toml, supplied by fenix. Dependencies are vendored
# from Cargo.lock with importCargoLock and built with the stock
# cargo hooks (buildRustPackage's platform glue in current nixpkgs
# requires rustc.targetPlatforms, which the fenix toolchain
# derivation does not expose).
#
# The sqlx queries in src/database.rs are type-checked against a live
# sqlite database at compile time (DATABASE_URL in .env points at
# ./db_v2.sqlite3). That file is gitignored build scaffolding holding
# only the peer schema from Database::create_tables — the package
# build creates it in preBuild, and the dev shell creates it on entry
# when missing.

{
  description = "Qompass AI Glass — self-hosted rendezvous (hbbs) and relay (hbbr) server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, fenix, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      toolchainFor =
        system:
        fenix.packages.${system}.toolchainOf {
          channel = "1.96.0";
          sha256 = "sha256-mvUGEOHYJpn3ikC5hckneuGixaC+yGrkMM/liDIDgoU=";
        };
      # The peer schema, verbatim from src/database.rs create_tables().
      peerSchema = ''
        create table if not exists peer (
          guid blob primary key not null,
          id varchar(100) not null,
          uuid blob not null,
          pk blob not null,
          created_at datetime not null default(current_timestamp),
          user blob,
          status tinyint,
          note varchar(300),
          info text not null
        ) without rowid;
        create unique index if not exists index_peer_id on peer (id);
        create index if not exists index_peer_user on peer (user);
        create index if not exists index_peer_created_at on peer (created_at);
        create index if not exists index_peer_status on peer (status);
      '';
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.stdenv.mkDerivation {
            pname = "glass";
            version = "0.1.0";
            src = ./.;

            cargoDeps = pkgs.rustPlatform.importCargoLock {
              lockFile = ./Cargo.lock;
              outputHashes = {
                "async-speed-limit-0.3.1-1" = "sha256-OCO8sYXPbMUTUlGW2F7I0jsjCic+jHKnC8qEh+1Kll4=";
                "confy-0.4.0-2" = "sha256-V7BCKISrkJIxWC3WT5+B5Vav86YTQvdO9TO6A++47FU=";
                "tokio-socks-0.5.2-3" = "sha256-Fkfp91+VowNqi4OjUEgFd7YxCew7uOhsVsN6mdcCEq4=";
              };
            };

            nativeBuildInputs = [
              (toolchainFor system).toolchain
              pkgs.rustPlatform.cargoBuildHook
              pkgs.rustPlatform.cargoInstallHook
              pkgs.rustPlatform.cargoSetupHook
              pkgs.perl
              pkgs.pkg-config
              pkgs.sqlite
            ];

            cargoBuildType = "release";

            # The test suite is gated outside Nix on the pinned
            # toolchain (cargo test): the database load test alone
            # runs for minutes and writes scratch sqlite files, which
            # is a poor fit for the build sandbox.
            doCheck = false;

            # sqlx type-checks its queries against this database at
            # compile time; it must exist before cargo runs.
            preBuild = ''
              sqlite3 ./db_v2.sqlite3 "${peerSchema}"
            '';

            meta = {
              description = "Qompass AI Glass server (hbbs rendezvous + hbbr relay + glass-utils)";
              homepage = "https://qompass.ai/glass";
              license = pkgs.lib.licenses.agpl3Only;
              mainProgram = "hbbs";
              platforms = systems;
            };
          };
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = [
              (toolchainFor system).toolchain
              pkgs.pkg-config
              pkgs.sqlite
            ];
            shellHook = ''
              if [ ! -f db_v2.sqlite3 ]; then
                echo "glass: creating sqlx compile-time check database ./db_v2.sqlite3"
                sqlite3 ./db_v2.sqlite3 "${peerSchema}"
              fi
            '';
          };
        }
      );
    };
}
