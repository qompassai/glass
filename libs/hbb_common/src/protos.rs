// ---------------------------------------------------------------------------
// /qompassai/glass/libs/hbb_common/src/protos.rs
// Qompass AI Glass — protobuf module shim for hbb_common
// SPDX-License-Identifier: AGPL-3.0-only
// Copyright (c) 2026 Qompass AI
//
// This crate is distributed under the repository's dual-license scheme:
// AGPL-3.0 for non-commercial use, Q-CDA 1.0 for commercial use.
// See LICENSE-AGPL and LICENSE-QCDA at the repository root.
//
// The build script (libs/hbb_common/build.rs) runs protobuf codegen over
// protos/message.proto and protos/rendezvous.proto and writes the output
// to $OUT_DIR/protos/ (message.rs, rendezvous.rs, and a mod.rs declaring
// both). This shim is the module root that pulls the generated tree into
// the crate; lib.rs re-exports them as message_proto / rendezvous_proto.

include!(concat!(env!("OUT_DIR"), "/protos/mod.rs"));
