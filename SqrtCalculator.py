def root(y ,x , precision=10):
    
    if x < 0:
        return('Complex number')
    
    sqrtX = 0

    highDigit = 1
    while 1:
        if x % highDigit != x:
           highDigit *= 10
        else:
           highDigit *= 0.1
           break

    lowDigit = 0.1 ** precision

    currentDigit = highDigit
    while currentDigit >= lowDigit:
        for i in range(0,10):

            lower = (sqrtX + (i * currentDigit)) ** y
            upper = (sqrtX + ((i + 1) * currentDigit)) ** y

            if (lower <= x < upper):
                sqrtX += i * currentDigit
                currentDigit *= 0.1
                break
            elif i == 9:
                return('error')

    return(sqrtX)

while 1:
    print(root(float(input('degree: ')),float(input('x: '))))