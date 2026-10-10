// ---------------------------------------------------------------------------
// /qompassai/glass/libs/hbb_common/src/protos.rs
// Qompass AI Glass — protobuf module shim for hbb_common
// SPDX-License-Identifier: AGPL-3.0-only OR Apache-2.0
// Copyright (c) 2026 Qompass AI
//
// This file is first-party Qompass AI code, dual-licensed under the
// AGPL-3.0 or Apache-2.0, at your option. See LICENSE-AGPL and
// LICENSE-APACHE at the repository root, and LICENSE-DUAL for the
// scope of the dual license.
//
// The build script (libs/hbb_common/build.rs) runs protobuf codegen over
// protos/message.proto and protos/rendezvous.proto and writes the output
// to $OUT_DIR/protos/ (message.rs, rendezvous.rs, and a mod.rs declaring
// both). This shim is the module root that pulls the generated tree into
// the crate; lib.rs re-exports them as message_proto / rendezvous_proto.

include!(concat!(env!("OUT_DIR"), "/protos/mod.rs"));
