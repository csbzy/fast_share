use std::io::Result;
fn main() -> Result<()> {
    let mut conf = prost_build::Config::new();
    conf.bytes(&["."]);
    conf.type_attribute(".", "#[derive(PartialOrd)]");
    conf.out_dir("src/api")
        .compile_protos(&["command.proto"], &["."])
        .expect("生成proto失败");

    Ok(())
}
