#Uses Reed-Soloman error correction
#Doesn't work with decimals

KEYS = [1, 2]

def calculatePolynomial(x, coefficents, unknowns=False):
    localCoefficents = []
    localCoefficents += coefficents

    if unknowns:
        localCoefficents.append(0)
        localCoefficents.append(0)

    result = 0
    currentDegree = len(localCoefficents) - 1

    for coefficent in localCoefficents:
        result += coefficent * (x ** currentDegree)
        currentDegree -= 1

    return result

def systemSolver(coefficents, keys):
    rightSidePolynomial = calculatePolynomial(keys[0], coefficents, 1)
    leftSidePolynomial = calculatePolynomial(keys[1], coefficents, 1)

    a = (rightSidePolynomial - leftSidePolynomial) / (keys[1] - keys[0])
    b = -1 * (rightSidePolynomial + a * (keys[0]))
    
    return [a, b]

def verifyMessage(coefficents, keys):
    firstSolution = calculatePolynomial(keys[0], coefficents)
    secondSolution = calculatePolynomial(keys[1], coefficents)

    if (firstSolution == 0) and (secondSolution == 0):
        return True
    
    return False

def fixMessage(coefficents, keys):

    currentDegree = len(coefficents) - 1

    for coefficent in coefficents:
        k1 = (-1 * (calculatePolynomial(keys[0], coefficents) - coefficent * (keys[0] ** currentDegree))) / (keys[0] ** currentDegree)
        k2 = (-1 * (calculatePolynomial(keys[1], coefficents) - coefficent * (keys[1] ** currentDegree))) / (keys[1] ** currentDegree)

        if k1 == k2:
            tempCoefficents = []
            tempCoefficents += coefficents
            tempCoefficents[len(coefficents) - (currentDegree + 1)] = k1
            return tempCoefficents
        
        currentDegree -= 1

def doTheThing1():
    message = input('Originial message seperated by commas: ')

    coefficents = message.split(',')
    for index, value in enumerate(coefficents):
        strippedValue = value.strip()
        floatStrippedValue = float(strippedValue)
        coefficents[index] = floatStrippedValue

    errorCorrectionCoefficents = systemSolver(coefficents, KEYS)
    processedCoefficents = coefficents + [errorCorrectionCoefficents[0]] + [errorCorrectionCoefficents[1]]
    print(f'Sent this message: {processedCoefficents}')

def doTheThing2():
    message = input('Recieved message seperated by commas: ')

    coefficents = message.split(',')
    for index, value in enumerate(coefficents):
        strippedValue = value.strip()
        floatStrippedValue = float(strippedValue)
        coefficents[index] = floatStrippedValue

    if verifyMessage(coefficents, KEYS) == True:
        print('Original message recieved. No errors detected.')
    else:
        print('Errors detected. Fixing.')
        print(f'Original message: {fixMessage(coefficents, KEYS)[:-2]}')

mode = int(input('Mode: '))
if mode == 0:
    doTheThing1()
if mode == 1:
    doTheThing2()