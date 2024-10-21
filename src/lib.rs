#[cfg(not(target_arch = "wasm32"))]
pub mod ipc {
    pub use server::ipc::*;
}

#[cfg(not(target_arch = "wasm32"))]
pub mod llama {
    pub use server::llama::*;
}

#[cfg(not(target_arch = "wasm32"))]
pub mod master_server {
    pub use server::master_server::*;
}

#[cfg(not(target_arch = "wasm32"))]
pub mod master_state {
    pub use server::master_state::*;
}

#[cfg(not(target_arch = "wasm32"))]
pub mod model {
    pub use server::model::*;
}

#[cfg(not(target_arch = "wasm32"))]
pub mod phi3 {
    pub use server::phi3::*;
}

#[cfg(not(target_arch = "wasm32"))]
pub mod token_output_stream {
    pub use server::token_output_stream::*;
}

#[cfg(not(target_arch = "wasm32"))]
pub mod worker_server {
    pub use server::worker_server::*;
}

// re-export module
pub mod data {
    pub use client::data::*;
}
