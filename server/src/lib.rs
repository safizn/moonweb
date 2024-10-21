#[cfg(not(target_arch = "wasm32"))]
pub mod ipc;

#[cfg(not(target_arch = "wasm32"))]
pub mod llama;

#[cfg(not(target_arch = "wasm32"))]
pub mod master_server;

#[cfg(not(target_arch = "wasm32"))]
pub mod master_state;

#[cfg(not(target_arch = "wasm32"))]
pub mod model;

#[cfg(not(target_arch = "wasm32"))]
pub mod phi3;

#[cfg(not(target_arch = "wasm32"))]
pub mod token_output_stream;

#[cfg(not(target_arch = "wasm32"))]
pub mod worker_server;

// re-export module
pub mod data {
    pub use client::data::*;
}
