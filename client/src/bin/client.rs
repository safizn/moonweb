#![allow(non_snake_case, unused)]

use clap::*;
use client::web::app;
use dioxus::prelude::*;
use dioxus_logger::tracing::{info, Level};
use std::str::FromStr;

// Urls are relative to your Cargo.toml file
const _TAILWIND_URL: &str = manganis::mg!(file("public/tailwind.css"));

fn main() {
    dioxus_logger::init(Level::TRACE).expect("logger failed to init");

    info!("Running client");

    launch(app);
}
