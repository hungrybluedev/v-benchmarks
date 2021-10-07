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
...
V full version: V 0.2.4 87fe15e.c356e34
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
  Time (mean ± σ):     49.939 s ±  1.085 s    [User: 49.929 s, System: 0.004 s]
  Range (min … max):   49.119 s … 51.694 s    10 runs
```

#### Test 02 - V (without any optimizations)

```
$ hyperfine -w 4 "v run fib.v"
Benchmark #1: v run fib.v
  Time (mean ± σ):      2.168 s ±  0.024 s    [User: 2.192 s, System: 0.028 s]
  Range (min … max):    2.128 s …  2.205 s    10 runs
```

#### Test 03 - V (average production compilation speed + executable runtime)

First we generate an optimized executable.

```
$ hyperfine -w 4 "v -prod fib.v"
Benchmark #1: v -prod fib.v
  Time (mean ± σ):      3.045 s ±  0.039 s    [User: 2.976 s, System: 0.125 s]
  Range (min … max):    2.984 s …  3.092 s    10 runs
```

Then we run the executable.

```
$ hyperfine -w 4 "./fib"
Benchmark #1: ./fib
  Time (mean ± σ):     502.4 ms ±  17.6 ms    [User: 501.2 ms, System: 0.9 ms]
  Range (min … max):   483.8 ms … 527.3 ms    10 runs
```

## Conclusion

V was faster than Python by a significant margin in all the scenarios. Python took 49.9 seconds (on average) to run the program.

Even when V used the default TCC compiler, the V version ran in approximately 2.2 seconds, around **22 times** faster than Python. Remember that this version uses TCC that comes bundled with V.

When we use the `-prod` flag with V most of the time is spent in the available C compiler (GCC in my case, can be Clang otherwise) compiling the program and applying optimisations. This step is a bit more time consuming than the regular `v run` at approximately 3 seconds. The actual generated executable runs so fast that hyperfine occasionally suspects anomalous data. On average, the executable run for 502 milliseconds, which is nearly **95-100 times** faster than Python!

Obviously, the runtime for executable only makes sense if you precompile the program and deploy it. In that case, it will run as fast as possible, while your Python deployment will have longer runtime. Therefore, for quick prototyping, it is recommended to just use `v run program.v` and use `v -prod program.v -o path/to/binary/program` for compilation.

Additionally, there was no optimisation performed by us, the developers. This is just a simple demonstration and in case you want to generate Fibonacci numbers, prefer the formulae that are available on the Wikipedia page.

## Troubleshooting

If you get an error, use the `--show-output` flag to see more details. If the message is something like `sh: 1: python: not found`, then try setting up a virtual environment in that location:

```bash
virtualenv venv
. venv/bin/activate
```
