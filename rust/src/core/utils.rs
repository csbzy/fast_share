use std::{fs::File, io::Read};



pub fn calc_md5(path: &str) -> String {
    let mut file = File::open(path).unwrap();
    let file_size = file.metadata().unwrap().len();
    if file_size <= 512 * 1024 * 1024 {
        // smaller than 512MB
        let mut buffer = Vec::new();
        file.read_to_end(&mut buffer).unwrap();

        let result = md5::compute(&buffer);
        return format!("{:x}", result);
    }
    // let mut buffer = [0; 1024 * 1024 * 10];
    // let mut context = Context::new();
    // loop {
    //     let n = file.read(&mut buffer).unwrap();
    //     if n == 0 {
    //         break;
    //     }
    //     context.consume(&buffer[..n]);
    // }
    // let result = context.compute();

    // return format!("{:x}", result);
    return "".to_string();
}

pub fn calc_progress(recv_size: usize, file_size: u64) -> i32 {
    return (recv_size as f64 / file_size as f64 * 100.0) as i32;
}

pub fn calc_speed(recv_size: usize, elapsed_time: std::time::Duration) -> f64 {
    return (recv_size as f64 / (1024.0 * 1024.0)) / elapsed_time.as_secs_f64();
}

pub enum ProgressType {
    Upload = 0,
    Download = 1,
}
