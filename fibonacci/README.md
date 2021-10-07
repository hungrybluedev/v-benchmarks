# Extremely Basic Benchmark comparing V with Python

This experiment is conducted in the context of calculating fibonacci numbers using the traditional method.

## The Algorithm

```
fib(n) = 1,                       if n <= 0
       = fib(n - 1) + fib(n - 2), otherwise


result = 0

for n in 0..40 {
  result = fib(n)
}

display(result)
```

## Files

1. `fib.py` - implementation in Python
2. `fib.v` - implementation in V

They all go up to 40 (exclusive) and should print `165580141`.

## Test Hardware

### System 01 - hungrybluedev's laptop

Partial output from `v doctor`:

```
OS: linux, Pop!_OS 21.04
Processor: 6 cpus, 64bit, little endian, AMD Ryzen 5 4500U with Radeon Graphics
```

Partial output from `lscpu`:

```
Architecture:                    x86_64
CPU op-mode(s):                  32-bit, 64-bit
Byte Order:                      Little Endian
Address sizes:                   48 bits physical, 48 bits virtual
CPU(s):                          6
On-line CPU(s) list:             0-5
Thread(s) per core:              1
Core(s) per socket:              6
Socket(s):                       1
NUMA node(s):                    1
Vendor ID:                       AuthenticAMD
CPU family:                      23
Model:                           96
Model name:                      AMD Ryzen 5 4500U with Radeon Graphics
Stepping:                        1
Frequency boost:                 enabled
CPU MHz:                         1400.000
CPU max MHz:                     2375.0000
CPU min MHz:                     1400.0000
```

## Results

The runtime duration was measured using [hyperfine](https://github.com/sharkdp/hyperfine).

All the programs should output `165580141` as the final result.

### System 01

#### Test 01 - Python

```
$ hyperfine -w 2 "python fib.py"
Benchmark #1: python fib.py
  Time (mean ± σ):     49.322 s ±  0.130 s    [User: 49.313 s, System: 0.005 s]
  Range (min … max):   49.185 s … 49.617 s    10 runs
```

#### Test 02 - V (without any optimizations)

```
$ hyperfine -w 4 "v run fib.v"
Benchmark #1: v run fib.v
  Time (mean ± σ):      2.220 s ±  0.025 s    [User: 2.243 s, System: 0.033 s]
  Range (min … max):    2.183 s …  2.257 s    10 runs
```

#### Test 03 - V (with `-prod` switch)

```
$ hyperfine -w 4 "v -prod run fib.v"
Benchmark #1: v -prod run fib.v
  Time (mean ± σ):      3.764 s ±  0.046 s    [User: 3.675 s, System: 0.142 s]
  Range (min … max):    3.706 s …  3.857 s    10 runs
```

#### Test 04 - V (average production compilation speed + executable runtime)

First we generate an optimized executable.

```
$ hyperfine -w 4 "v -prod fib.v"
Benchmark #1: v -prod fib.v
  Time (mean ± σ):      2.999 s ±  0.039 s    [User: 2.947 s, System: 0.107 s]
  Range (min … max):    2.940 s …  3.054 s    10 runs
```

Then we run the executable.

```
$ hyperfine -w 4 "./fib"
Benchmark #1: ./fib
  Time (mean ± σ):     790.4 ms ±  64.3 ms    [User: 787.9 ms, System: 2.0 ms]
  Range (min … max):   610.7 ms … 827.4 ms    10 runs

  Warning: Statistical outliers were detected...
```

## Conclusion

V beat Python by a significant margin in all the scenarios.

Even when V used the default TCC compiler, the V version ran in approximately 2.2 seconds, around
