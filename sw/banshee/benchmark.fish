#!/usr/bin/env fish

# Print the info
set -x SNITCH_LOG info

# Make sure banshee is built
cargo build --release

set cores 8
for clusters in 2 4 8 16 32 64 128
    # Compile the matrix multiplication with weak scaling
    # sed -i "s/^N = [0-9]*/N = 16/" tests/matmul/gen_data.py
    # python3 ./tests/matmul/gen_data.py > tests/matmul/data.S
    # make -C tests bin/matmul_baseline
    # Run the tests
    for arg in "" "--latency" "--trace" "--trace --latency"
        echo "Run with $clusters clusters with $cores cores each ("(math "$clusters * $cores")") and the following flags: $arg"
        for i in (seq 0 9)
            if test -n $arg
                ./target/release/banshee tests/bin/matmul_baseline --num-cores=$cores --num-clusters=$clusters (string split ' ' -- $arg) 1> trace 2>| grep -oh "[0-9\.]* [kMG]*inst/s"
            else
                ./target/release/banshee tests/bin/matmul_baseline --num-cores=$cores --num-clusters=$clusters 1> trace 2>| grep -oh "[0-9\.]* [kMG]*inst/s"
            end
        end
    end
end
