def fib(n):
    if n <= 0:
        return 1
    return fib(n - 1) + fib(n - 2)


res = 0
for c in range(40):
    res = fib(c)
print(res)
