use lazy_static::lazy_static;
use serde::{Deserialize, Serialize};
use std::env;
use std::fs;
use std::io::Read;
use std::path::PathBuf;
use std::sync::Arc;
use tokio::sync::RwLock;

#[derive(Deserialize, Serialize, Debug, Clone)]
pub(crate) struct WorkerServer {
    pub model_id: String,
    pub program: String,
    pub temp: f64,
    pub top_p: f64,
}

#[derive(Deserialize, Serialize, Debug, Clone)]
struct ServerConfig {
    pub ports: Vec<u32>,
    pub master_addr: String,
    pub working_servers: Vec<WorkerServer>,
    pub servers: Vec<WorkerServer>,
}

lazy_static! {
    static ref CONFIG: Arc<RwLock<ServerConfig>> = Arc::new(RwLock::new(load_config()));
}

fn load_config() -> ServerConfig {
    let mut file =
        fs::File::open("config/server-config.json").expect("Failed to read server.config!");
    let mut contents = String::new();
    file.read_to_string(&mut contents)
        .expect("Failed to read server.config to string!");
    let config =
        serde_json::from_str::<ServerConfig>(contents.as_str()).expect("Failed to deseriablize.");
    config
}
fn save_config(config: &ServerConfig) {
    let content = serde_json::to_string_pretty(config).unwrap();
    fs::write("server-config.json", content.as_bytes()).unwrap();
}

pub(crate) fn get_program(server: &WorkerServer) -> PathBuf {
    let exe_path = env::current_exe().expect("Failed to determine the current executable path");
    let cwd = exe_path
        .parent()
        .expect("Failed to get the parent directory of the current executable path")
        .to_path_buf();
    let mut path = PathBuf::from(server.program.clone());

    let p = if path.to_str().unwrap() == "self" {
        cwd.join("worker")
    } else if path.is_relative() {
        cwd.join(path)
    } else {
        let mut path = PathBuf::from(server.program.clone());
        path.canonicalize().unwrap()
    };

    println!("path = {}", p.to_str().unwrap());

    p
}

pub(crate) async fn get_working_servers() -> Vec<WorkerServer> {
    CONFIG.read().await.working_servers.clone()
}

pub(crate) async fn get_master_addr() -> String {
    CONFIG.read().await.master_addr.clone()
}

pub(crate) async fn get_servers() -> Vec<WorkerServer> {
    CONFIG.read().await.servers.clone()
}

pub(crate) async fn new_working_server(server: WorkerServer) {
    let new_config = {
        let mut config = CONFIG.write().await;
        config.working_servers.push(server);
        config
    };
    save_config(&new_config);
}

pub(crate) async fn remove_working_server(model_id: &str) {
    let new_config = {
        let mut config = CONFIG.write().await;
        config
            .working_servers
            .retain(|s| s.model_id != model_id.to_string());
        config
    };
    save_config(&new_config);
}
