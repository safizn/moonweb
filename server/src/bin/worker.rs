#![allow(non_snake_case, unused)]

use clap::*;
use dioxus::prelude::*;
use dioxus_logger::tracing::{info, Level};
use std::str::FromStr;

#[cfg(not(target_arch = "wasm32"))]
use server::master_server::master_server;
#[cfg(not(target_arch = "wasm32"))]
use server::worker_server::worker_server;

#[derive(Debug, PartialEq)]
enum ServerNode {
    Master,
    Worker,
    Web,
}

impl FromStr for ServerNode {
    type Err = String;

    fn from_str(s: &str) -> std::result::Result<Self, Self::Err> {
        match s.to_lowercase().as_str() {
            "master" => Ok(ServerNode::Master),
            "worker" => Ok(ServerNode::Worker),
            "web" => Ok(ServerNode::Web),
            _ => Err(format!("'{}' is not a valid ServerNode", s)),
        }
    }
}

#[derive(Parser, Debug)]
#[clap(author, version, about, long_about = None)]
struct Args {
    #[clap(short, long)]
    server: Option<ServerNode>,

    #[clap(short, long)]
    ipc_name: Option<String>,

    #[clap(short, long)]
    model_id: Option<String>,

    #[clap(short = 'h', long)]
    temp: Option<f64>,

    #[clap(short = 't', long)]
    top_p: Option<f64>,

    #[clap(short = 'e', long)]
    master_port: Option<u32>,
}

fn main() {
    let args = Args::parse();
    let server_type = args.server.unwrap_or_else(|| ServerNode::Web);

    dioxus_logger::init(Level::TRACE).expect("logger failed to init");

    if server_type != ServerNode::Worker {
        panic!("Invalid server type: {:?}", server_type);
    }

    #[cfg(not(target_arch = "wasm32"))]
    {
        info!("Running at ServerNode::Worker");

        let model_id = args
            .model_id
            .unwrap_or_else(|| "Qwen/Qwen2-7B-Instruct".into());
        let temp = args.temp.unwrap_or_else(|| 0.6f64);
        let top_p = args.top_p.unwrap_or_else(|| 0.9f64);
        let ipc_name = args.ipc_name.unwrap();
        let runtime = tokio::runtime::Runtime::new().expect("Create runtime failed!");
        runtime.block_on(worker_server(ipc_name, model_id.clone(), temp, top_p));
    }
}