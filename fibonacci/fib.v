fn fib(n int) int {
	if n <= 0 {
		return 1
	}
	return fib(n - 1) + fib(n - 2)
}

fn main() {
	mut res := 0
	for n in 0 .. 40 {
		res = fib(n)
	}
	println(res)
}
