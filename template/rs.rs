use std::env;
use std::num::ParseFloatError;

#[derive(Debug)]
struct Stats {
    count: usize,
    sum: f64,
}

impl Stats {
    fn new() -> Self {
        Self { count: 0, sum: 0.0 }
    }
    fn add(&mut self, x: f64) {
        self.count += 1;
        self.sum += x;
    }
    fn average(&self) -> Option<f64> {
        if self.count == 0 {
            None
        } else {
            Some(self.sum / self.count as f64)
        }
    }
}

fn parse_args_to_floats() -> Result<Vec<f64>, ParseFloatError> {
    // skip the first arg (program name), parse the rest
    env::args().skip(1).map(|s| s.parse::<f64>()).collect()
}

fn main() {
    match parse_args_to_floats() {
        Ok(nums) => {
            let mut stats = Stats::new();
            for n in nums {
                stats.add(n);
            }
            println!("Stats: {:?}", stats);
            match stats.average() {
                Some(avg) => println!("Average: {avg}"),
                None => println!("No numbers provided. Usage: simple_sum 1 2 3.5"),
            }
        }
        Err(_) => eprintln!("Error: all args must be numbers. Example: simple_sum 1 2 3.5"),
    }
}
