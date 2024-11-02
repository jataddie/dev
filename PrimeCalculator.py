num = 3
primeList = [1, 2]

def primeSubFunction(mode):
    global num, primeList

    numberIsTestingForPrime = True

    for primeFactor in primeList:
        if primeFactor == 1:
            continue

        if numberIsTestingForPrime:
            otherFactor = num / primeFactor
            if otherFactor == int(otherFactor):
                numberIsTestingForPrime = False

    if numberIsTestingForPrime:
        primeList.append(num)
        if mode == 1:
            print(num)

    num += 2

def primeFunction(mode, whichPrime = 0):
    global num, primeList

    if mode == 0:
        while len(primeList) < whichPrime:
            primeSubFunction(0)

        print(f'--> {primeList[whichPrime - 1]}')

    if mode == 1:
        while 1:
            primeSubFunction(1)

while 1:
    try:
        mode = int(input('\n0 to find a specific prime\n1 to list primes continuously (Ctrl + C to quit)\nEnter: '))
    except:
        print('Error. Try Again.')
        continue

    if mode == 0:
        whichPrime = int(input('Which prime do you want: '))
        primeFunction(0, whichPrime)

    if mode == 1:
        try:
            primeFunction(1)
        except KeyboardInterrupt:
            print('-' * 20)
            print(f'{len(primeList)} primes calculated')
            print('-' * 20)