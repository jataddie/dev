#Can perform many of the tedious, repetitive tasks associated with theoretical reactions in chemistry
#Many functionalities I would like to implement like balancing equations and stoichiometry

#Credit to python math module for .gcd() function
import math

#Dictionaries containing various data points on elements, polyatomic ions, and BrINClHOF elements
ELEMENT = {
    #Ion charge, atomic mass, full name
    #All possible charges in tuples
    #If charge N/A, then 0.0

    'h':(1,1.01,'hydrogen'),
    'he':(0,4.00,'helium'),
    'li':(3,6.94,'lithium'),
    'be':(2,9.01,'beryllium'),
    'b':(3,10.81,'boron'),
    'c':(4,12.01,'carbon'),
    'n':(-3,14.01,'nitrogen'),
    'o':(-2,16.00,'oxygen'),
    'f':(-1,19.00,'fluorine'),
    'ne':(0,20.18,'neon'),
    'na':(1,23.00,'sodium'),
    'mg':(2,24.31,'magnesium'),
    'al':(3,26.98,'aluminum'),
    'si':(4,28.09,'silicon'),
    'p':(-3,30.97,'phosphorus'),
    's':(-2,32.06,'sulfur'),
    'cl':(-1,35.45,'chlorine'),
    'ar':(0,39.95,'argon'),
    'k':(1,39.10,'potassium'),
    'ca':(2,40.08,'calcium'),
    'sc':(3,44.96,'scandium'),
    'ti':((2,3),47.87,'titanium'),
    'v':((2,3,4,5),50.94,'vanadium'),
    'cr':((2,3,6),52.00,'chromium'),
    'mn':((2,3,4,7),54.94,'manganese'),
    'fe':((2,3),55.85,'iron'),
    'co':((2,3),58.93,'cobalt'),
    'ni':((2,3),58.69,'nickel'),
    'cu':((1,2),63.55,'copper'),
    'zn':(2,56.38,'zinc'),
    'ga':(3,69.72,'gallium'),
    'ge':(4,72.63,'germanium'),
    'as':(-3,74.92,'arsenic'),
    'se':(-2,78.96,'selenium'),
    'br':(-1,79.90,'bromine'),
    'kr':(0,83.80,'krypton'),
    'rb':(1,85.47,'rubidium'),
    'sr':(2,87.62,'strontium'),
    'y':(0.0,88.91,'yttrium'),
    'zr':(1,91.22,'zirconium'),
    'nb':(0.0,92.91,'niobium'),
    'mo':(0.0,95.96,'molybdenum'),
    'tc':(0.0,97.91,'technetium'),
    'ru':(0.0,101.07,'ruthenium'),
    'rh':(0.0,102.91,'rhodium'),
    'pd':((2,4),106.42,'palladium'),
    'ag':(1,107.87,'silver'),
    'cd':(2,112.41,'cadmium'),
    'in':((1,2,3),114.82,'indium'),
    'sn':((2,4),118.71,'tin'),
    'sb':(-3,121.76,'antimony'),
    'te':(-2,127.60,'tellurium'),
    'i':(-1,126.90,'iodine'),
    'xe':(0,131.29,'xenon'),
    'cs':(1,132.91,'cesium'),
    'ba':(2,137.33,'barium'),
    'la':(0.0,138.91,'lanthanum'),
    'ce':(0.0,140.12,'cerium'),
    'pr':(0.0,140.91,'praseodymium'),
    'nd':(0.0,144.24,'neodymium'),
    'pm':(0.0,144.91,'promethium'),
    'sm':(0.0,150.36,'samarium'),
    'eu':(0.0,151.96,'europium'),
    'gd':(0.0,157.25,'gadolinium'),
    'tb':(0.0,158.93,'terbium'),
    'dy':(0.0,162.50,'dysprosium'),
    'ho':(0.0,164.93,'holmium'),
    'er':(0.0,167.26,'erbium'),
    'tm':(0.0,168.93,'thulium'),
    'yb':(0.0,173.05,'ytterbium'),
    'lu':(0.0,174.97,'lutetium'),
    'hf':(0.0,178.49,'hafnium'),
    'ta':(0.0,180.95,'tantalum'),
    'w':(0.0,183.84,'tungsten'),
    're':(0.0,186.21,'rhenium'),
    'os':(0.0,190.23,'osmium'),
    'ir':(0.0,192.22,'iridium'),
    'pt':((2,4),195.08,'platinum'),
    'au':((1,3),196.97,'gold'),
    'hg':((1,2),200.59,'mercury'),
    'tl':((1,3),204.38,'thallium'),
    'pb':((2,4),207.2,'lead'),
    'bi':(-3,208.98,'bismuth'),
    'po':(-2,208.98,'polonium'),
    'at':(-1,209.99,'astatine'),
    'rn':(0,222.02,'radon'),
    'fr':(1,223.02,'francium'),
    'ra':(2,226.03,'radium'),
    'ac':(0.0,227.03,'actinium'),
    'th':(0.0,232.04,'thorium'),
    'pa':(0.0,231.04,'protactinium'),
    'u':(0.0,238.03,'uranium'),
    'np':(0.0,237.05,'neptunium'),
    'pu':(0.0,244.06,'plutonium'),
    'am':(0.0,243.06,'americium'),
    'cm':(0.0,247.07,'curium'),
    'bk':(0.0,247.07,'berkelium'),
    'cf':(0.0,251.08,'californium'),
    'es':(0.0,252.08,'einsteinium'),
    'fm':(0.0,257.10,'fermium'),
    'md':(0.0,258.10,'mendelevium'),
    'no':(0.0,259.10,'nobelium'),
    'lr':(0.0,262.11,'lawrencium'),
    'rf':(0.0,265.12,'rutherfordium'),
    'db':(0.0,268.13,'dubnium'),
    'sg':(0.0,271.13,'seaborgium'),
    'bh':(0.0,270.00,'bohrium'),
    'hs':(0.0,277.15,'hassium'),
    'mt':(0.0,276.15,'meitnerium'),
    'ds':(0.0,281.16,'darmstadtium'),
    'rg':(0.0,280.16,'roentgenium'),
    'cn':(0.0,285.17,'copernicium'),
    'nh':(0.0,284.18,'nihonium'),
    'fl':(0.0,289.19,'flerovium'),
    'mc':(0.0,288.19,'moscovium'),
    'lv':(0.0,293.00,'livermorium'),
    'ts':(0.0,294.00,'tennessine'),
    'og':(0.0,294.00,'oganesson'),
        }
POLYION = {
    #Charge, name
    
    'NH4':(1,'ammonium'),
    'H3O':(1,'hydronium'),
    'HCO3':(-1,'hydrogen carbonate'),
    'HSO4':(-1,'hydrogen sulfate'),
    'C2H3O2':(-1,'acetate'),
    'CH3COO':(-1,'ethanoate'),
    'ClO':(-1,'hypochlorite'),
    'ClO2':(-1,'chlorite'),
    'ClO3':(-1,'chlorate'),
    'ClO4':(-1,'perchlorate'),
    'NO2':(-1,'nitrite'),
    'NO3':(-1,'nitrate'),
    'CN':(-1,'cyanide'),
    'OH':(-1,'hydroxide'),
    'HCO3':(-1,'bicarbonate'),
    'HC2O4':(-1,'binoxalate'),
    'HSO4':(-1,'bisulfate'),
    'HS':(-1,'bisulfide'),
    'HSO3':(-1,'bisulfite'),
    'H2PO4':(-1,'dihydrogen phosphate'),
    'MnO4':(-1,'manganate'),
    'SCN':(-1,'thiocyanate'),
    'CO3':(-2,'carbonate'),
    'SO4':(-2,'sulfate'),
    'SO3':(-2,'sulfite'),
    'S2O3':(-2,'thiosulfate'),
    'C2O4':(-2,'oxalate'),
    'HPO4':(-2,'hydrogen phosphate'),
    'CrO4':(-2,'chromate'),
    'Cr2O7':(-2,'dichromate'),
    'PO3':(-3,'phosphite'),
    'PO4':(-3,'phosphate'),
}
bHOF = ['Br','I','N','Cl','H','O','F']

def getInfo(nameOrSymbol):
    #INPUT: nameOrSymbol-> string of element chemical symbol or name or part of name
    
    #Takes lowercase str (name, symbol, or part of name) and prints data about element
    
    #Makes the symbol lowercase so it can be keyed in ELEMENT
    nameOrSymbol = nameOrSymbol.lower()
    
    if len(nameOrSymbol) <= 2:
        #1-2 letter symbol
        
        symbol = nameOrSymbol
        properName = list(ELEMENT[symbol][2])
        properName[0] = properName[0].upper()
        properName = ('').join(properName)
        #Changes first letter of name to capital letter
        
        print(properName)
        print('Atomic number: ' + str(findAtomicNumber(symbol)))
        print('Atomic mass: ' + str(ELEMENT[symbol][1]))
        print('Possbile charges: ' + possibleCharges(symbol))
    
    else:
        #3+ letter name or part of name
        for key in ELEMENT:
            #Iterates through each element in ELEMENT
            if nameOrSymbol in ELEMENT[key][2]:
                #Recalls function with correct symbol
                getInfo(key)
    
def findAtomicNumber(x):
    #INPUT: x -> Element symbol
    
    #Takes an element symbol, finds its index in ELEMENT, and returns the atomic number (index + 1)
    
    keysList = list(ELEMENT.keys())
    return keysList.index(x) + 1
    
def possibleCharges(x):
    #INPUT: x-> ELement symbol or polyatomic ion
    
    #Takes int or tuple of charges from ELEMENT[symbol],
    #then returns them converted to a str with ion symbol (+ or -)
    
    #If x is a polyatomic ion, returns the charge of the polyatmoic ion
    try:
        #Positive charge
        if POLYION[x][0] > 0:
            return str(POLYION[x][0] + '+')
        #Negative charge
        else:
            return str(abs(POLYION[x][0]) + '-')
    
    #If x doesn't exist in the POLYION dictionary (KeyError), then x is not a polyatomic ion
    #Then procedes to interpret x as a key of the ELEMENT dictionary
    except KeyError:
        if type(ELEMENT[x][0]) == int:
            #One possible charge
            
            if ELEMENT[x][0] > 0:
                #Positive charge
                return str(ELEMENT[x][0]) + '+'
                
            if ELEMENT[x][0] == 0:
                #Neutral charge
                return '0'
                
            if ELEMENT[x][0] < 0:
                #Negative charge
                return str(abs(ELEMENT[x][0])) + '-'
            
        if type(ELEMENT[x][0]) == tuple:
            #If multiple possible charges inside tuple
            
            tuple_str = ''
            #Initialize tuple_str
            
            for value in ELEMENT[x][0]:
                #Iterates through tuple of charges
                
                if value > 0:
                    #Positive charge
                    tuple_str += str(value) + '+ '
                
                if value == 0:
                    #Neutral charge
                    tuple_str += '0 '
                    
                if value < 0:
                    #Negative charge
                    tuple_str += str(abs(value)) + '- '
                    
            return tuple_str
            
        if type(ELEMENT[x][0]) == float:
            #If charge N/A (0.0)
            
            return 'N/A'
    
    #If none work, return error
    return 'possibleCharges Failure'
 
#WIP 
def findCoefficent(equation):
    #INPUT: equation-> string version of one reactant
    
    #Takes one term of equation and returns coefficent as integer
    
    raw = list(equation)
    #Initialize list version of input eqaution (each character on its own)
    
    coefficent = []
    #Initialize list for storing digits of coefficent as they are found
    
    for value in raw:
        #Iterates through characters (value) of equation list (raw)
        
        try:
            #If the value is a number, adds it to coefficent
            coefficent.append(str(int(value)))
            continue
        
        except ValueError:
            #If no longer in coefficent, combines coefficent digits into integer
            coefficent = int(('').join(coefficent))
            break
        
    #Return coefficent as integer
    return coefficent
    
def isolateElements(inputRaw):
    #INPUT: inputRaw-> One string reactant or product (can have multiple elements/polyions within)
    
    #Removes coefficent from equation (x), and isolates each element with it's subscript
    #as individual parts of isolatedList. This allows easier handling of the individual elements
    #and polyatomic ions within the reactant/product
    
    #If inputRaw is a blank string, sets input to a blank string
    if inputRaw == '':
        input = inputRaw
        
    #Removes coefficent from front of inputRaw, and then assigns input to no-coefficent value of inputRaw
    for index,x in enumerate(inputRaw):
        if x.isalpha():
            input = inputRaw[index:]
            break
    
    #Initialize list form of input, iterationList for storing currently appended to element, and
    #isolatedList for storing final isoalted elements/polyatomic compounds
    inputList = list(input)
    iterationList = []
    isolatedList = []
    
    #Detects if there is a polyion in input, and assigns that polyion to targetPolyion
    containsPolyion = False
    for x in POLYION.keys():
        if x in input:
            containsPolyion = True
            targetPolyion = x
            break
        
    #If there is a polyion in input, splits isoaltedList betweenthe polyion and remaining part of input
    if containsPolyion:
        #If polyion is at front of input
        if input.find(targetPolyion) == 0:
            isolatedList.append(input[:len(targetPolyion)])
            isolatedList.append(input[len(targetPolyion):])
        #If polyion is at back of input
        else:
            isolatedList.append(input[:len(input) - len(targetPolyion)])
            isolatedList.append(input[len(input) - len(targetPolyion):])

    #If no polyion
    else:
        
        #Initializes boolean to tell if first letter has been added to iterationList
        #Without this, the code attempts to add a blank iterationList to isolatedList
        firstValueIn = False
        
        for x in inputList:
            #If this is the first value in iteration
            if firstValueIn == False:
                iterationList.append(x)
                firstValueIn = True
            #If not first value
            else:
                #If letter is uppercase, adds old iterationList to isolatedList, and starts new iterationList
                if x.isupper():
                    isolatedList.append(('').join(iterationList))
                    iterationList = [x]
                #If lowercase or number, builds onto current iterationList
                else:
                    iterationList.append(x)
                    
        #Adds final iterationList to isolatedList, because it was never added in for loop
        isolatedList.append(('').join(iterationList))
    
    #If there is a blank spot in isolatedList, removes it
    if '' in isolatedList:
        isolatedList.remove('')
    
    #Final list with isolated elements/polyatomic ions; no coefficents        
    return isolatedList
    
def fixOrder(input):
    #INPUT: input-> List of one reactant, with each element/polyion isolated in seperate parts of list
    
    #Takes a single isolated reactant (two elements/polyions), and makes the positive ion is first
    
    #List that holds tuple of integer charge of each element, and the element itself: (charge, element)
    chargesWithSubject = []
    
    #If input is blank, or there is only one reactant, returns input because there is no order to be changed
    try:
        #Tests to see if there is a second part of input
        #Errors (IndexError) if there is not
        input[1]
        
    #If there are not two parts to input, returns input
    except IndexError:
        return input
    
    for x in input:
        #If element is a polyion, adds polyion charge and polyatomic ion in tuple
        if x in POLYION.keys():
            chargesWithSubject.append((POLYION[x][0], x))
            
        #If element is not a polyion, removes subscripts to find charge using ELEMENT
        #Then adds this charge and element in tuple
        else:
            #String for holding element without its subscripts
            newX = ''
            for character in x.lower():
                if character.isalpha():
                    newX += character
            chargesWithSubject.append((ELEMENT[newX][0], x))
        
    #If first element in list has a positive charge, input was already ordered correctly, and returns input
    if chargesWithSubject[0][0] >= 0:
        return input
    #If first element is negative, then they are ordered wrong and swaps their positions in isolated list
    else:
        return [input[1], input[0]]
    
def reactionType(x, input1, input2):
    #INPUT: x-> One list of all reactants, isolated to individual elements/polyatomic ions
    #       input1 -> String of first reactant
    #       input2 -> String of second reactant
    
    #Takes a list of isolated reactants (x), reactant one (input1), and reactant two(input2)
    #Returns type of reaction based on number of reactants and their composition
    
    #If there is only one reactant, but still two possbile elements/polyions, product is decompostion
    if (input1 == '' or input2 == '') and len(x) == 2:
        return 'decomposition'
        
    #If O2 is isolated as one of the reactants, product is combustion
    elif (input1 == 'O2' or input2 == 'O2'):
        return 'combustion'
        
    #If two reactants, each with one element/polyion, product is synthesis
    elif len(x) == 2:
        return 'synthesis'
        
    #If 2 reactants, one with two elements/polyions, and one with one element/polyion, product is single displacement
    elif len(x) == 3:
        return 'single'
        
    #If 2 reactants, both with two elements/polyions, product is double displacement
    elif len(x) == 4:
        return 'double'
    
    #If none work, return error
    return 'reactionType Failure'

def predictProducts(x, type):
    #INPUT x-> List of isolated parts of reactants; first 2 parts are reactant 1, second 2 parts are reactant 2
    #       type-> Type of reaction as determined by reactionType()
    
    #Predicts the products of various reactions depending on their reactants and type of reaction
    
    #Splits single (two list parts because isolated into individual elements) reactant into two products
    #with plus sign in middle
    if type == 'decomposition':
        return [x[0], '+', x[1]] #['ex', '+', 'ex']
    
    #Returns original x, because x is already isolated into two individual elements
    #New list is to be interpreted as one product, and will be combined without plus sign inbetween
    if type == 'synthesis':
        return x #['ex', 'ex']
    
    #The products of combustion are carbon dioxide and water, so returns those seperated by plus sign
    if type == 'combustion':
        return ['CO2', '+', 'H2O'] #['CO2', '+', 'H2O']
    
    #The sole reactant replaces one of the element parts of the bigger reactant
    #If the sole reactant is postiive, replaces the first part of bigger reactant
    #If sole reactant is negative, replaces the second part of bigger reactant
    if type == 'single':
        
        #If the second reactant that is replacing one of the elements in the first is a polyion,
        #then its charge is checked to see if it should be first element in product or second
        try:
            
            #If postive charge, replaces first element
            if POLYION[x[2]][0] >= 0:
                return [x[2], x[1], '+', x[0]] #['ex','ex', '+', 'ex']
            #If negative charge, replaces second element
            elif POLYION[x[2]][0] < 0:
                return [x[0], x[2], '+', x[1]] #['ex','ex', '+', 'ex']
            #If none work, return error
            else:
                return 'predictProducts Failed (single)(try block)'
                
        #If the second reactant isn't a key in POLYION (KeyError), then it is not a polyion, 
        #and therefore is used as an element instead
        except KeyError:
            
            #String for holding element without its subscripts
            newX = ''
            #Removes numbers from x[2] element, leaving just the element symbol for checking charges in ELEMENT
            for i in x[2]:
                if i.isalpha():
                    newX += i
            newX = newX.lower()
            
            #If postive charge, replaces first element
            if ELEMENT[newX][0] >= 0:
                return [x[2], x[1], '+', x[0]] #['ex','ex', '+', 'ex']
            #If negative charge, replaces second element
            elif ELEMENT[newX][0] < 0:
                return [x[0], x[2], '+', x[1]] #['ex','ex', '+', 'ex']
            #If none work, return error
            else:
                return 'predictProducts Failed (single)(except block)'
    
    #Combines reactant 1, part 1 (positive) with reactant 2, part 2 (negative)
    #Combines reactant 2, part 1 (positive) with reactant 1, part 2 (negative)
    if type == 'double':
        return [x[0], x[3], '+', x[2], x[1] ]#['ex','ex', '+', 'ex', 'ex']

def userPredictProducts():
    reactant1 = input('Reactant: ')
    print('+')
    reactant2 = input('Reactant: ')
    print('---------------------------------------------------------------------------------------------')
    reactantsList = fixOrder(isolateElements(reactant1)) + fixOrder(isolateElements(reactant2))
    finalList = predictProducts(reactantsList, reactionType(reactantsList, reactant1, reactant2))
    print('->' + ('').join(finalList))
    reactionType1 = reactionType(reactantsList, reactant1, reactant2)
    if reactionType1 == 'synthesis':
        print('Synthesis')
    if reactionType1 == 'decomposition':
        print('Decomposition')
    if reactionType1 == 'single':
        print('Single Replacement')
    if reactionType1 == 'double':
        print('Double Replacement')
    if reactionType1 == 'combustion':
        print('Combustion')
    
#WIP
def balanceEquation(reactant1, reactant2, products):
    #INPUT reactant1-> Isolated list of first reactant
    #       reactant2-> Isolated list of second reactant
    #       products-> Isolated list of products as returned by predictProducts(); has '+' in middle
    
    
    
        
    
    #Tests to see if there are two elements in product1
    try:
        product1[1]
        
    #If IndexError, then there is not a second element, so the product is only one element
    #Then tests the element to see if it is a BrINClHOF element
    #If it is, then applies a subscript of 2
    except IndexError:
        if product1[0] in bHOF:
            product1[0] += '2'
            
    #Same thing but on product2
    try:
        product2[1]
    except IndexError:
        if product2[0] in bHOF:
            product2[0] += '2'
    
def balanceSubscripts(products):
    #INPUT: products-> Isolated list of products as returned by predictProducts(); has '+' in middle
    
    product1 = []
    product2 = []
    for index,x in enumerate(products):
        #If a plus is detected, splits list with first product in product1 and second product in product2
        if x == '+':
            product1 = products[:index]
            product2 = products[index + 1:]
    
    #If no plus sign was detected and product1 is still empty, sets it to products
    #This is because there is only one product (because no plus sign)
    if product1 == []:
        product1 = products
    
    
    stringWithoutSubscript = ''
    for x in product1:
        #If x is a polyatomic ion, the subscripts do not need to be changed
        if x in POLYION.keys():
            break
        for y in x:
            if y.isalpha():
                stringWithoutSubscript += y
        x = stringWithoutSubscript
        stringWithoutSubscript = ''
        
    for x in product2:
        #If x is a polyatomic ion, the subscripts do not need to be changed
        if x in POLYION.keys():
            break
        for y in x:
            if y.isalpha():
                stringWithoutSubscript += y
        x = stringWithoutSubscript
        stringWithoutSubscript = ''
        
    
    if len(product1) == 2:
        
        if product1[0] in POLYION.keys():
            charge1 = POLYION[product1[0]][0]
        else:
            charge1 = ELEMENT[product1[0].lower()][0]
        if product1[1] in POLYION.keys():
            charge2 = POLYION[product1[1]][0]
        else:
            charge2 = ELEMENT[product1[1].lower()][0]
            
        gcdBetweenCharges = math.gcd(charge1, charge2)
        
        product1[0] += '(' + str(int(abs(charge2)/gcdBetweenCharges)) + ')'
        product1[1] += '(' + str(int(abs(charge1)/gcdBetweenCharges)) + ')'
        
    elif product1[0] in bHOF:
            product1[0] += '(2)'
    """        
    else:
        containsNumber = False
        for x in product1[0]:
            if x.isdigit():
                containsNumber = True
        if containsNumber == False:
            product1[0] += '1'
    """
    #If there is anything actually in product2, this runs
    if product2 != []:
        if len(product2) == 2:
        
            if product2[0] in POLYION.keys():
                charge1 = POLYION[product2[0]][0]
            else:
                charge1 = ELEMENT[product2[0].lower()][0]
            if product2[1] in POLYION.keys():
                charge2 = POLYION[product2[1]][0]
            else:
                charge2 = ELEMENT[product2[1].lower()][0]
                
            gcdBetweenCharges = math.gcd(charge1, charge2)
            
            product2[0] += '(' + str(int(abs(charge2)/gcdBetweenCharges)) + ')'
            product2[1] += '(' + str(int(abs(charge1)/gcdBetweenCharges)) + ')'
        
        elif product2[0] in bHOF:
                product2[0] += '(2)'
        """  
        else:
            containsNumber = False
            for x in product2[0]:
                if x.isdigit():
                    containsNumber = True
            if containsNumber == False:
                product2[0] += '1'
        """
    #Returns list containing the first balanced subscript product reactants and the second product reactants
    return product1 + product2
            
#WIP
def findAmount(elements, coefficent):
    #INPUT: elements-> string of one reactant
    #       coefficent-> coefficent in front of reactant
    
    subscriptProgress = False
    
    for x in elements:
        for index, y in enumerate(x):
            if y == '(':
                pass
            elif y.isalpha() == False and subsciptProgress == False:
                pass

print('---------------------------------------------------------------------------------------------')
print('Subscript balancing between two elments or polyatomic ions: 1')
print('Product prediction (no coefficents or subscripts) with reaction type: 2')
print('Element & Polyatomic Ion Database: 3')
print('Example of isolation: 4')
print('---------------------------------------------------------------------------------------------')
while 1:
    try:
        selection = int(input('Number: '))
        print('---------------------------------------------------------------------------------------------')
        break
    except ValueError:
        print('Invalid input. Please try again.')
        print('---------------------------------------------------------------------------------------------')
        
if selection == 1:
    element1 = input('Element/Polyion 1: ')
    element2 = input('Element/Polyion 2: ')
    print('---------------------------------------------------------------------------------------------')
    combined = fixOrder([element1, element2])
    print('-> ' + str(balanceSubscripts(combined)))
    
if selection == 2:
    userPredictProducts()
    
if selection == 3:
    selection3Input = input('Element/Polyatomic Ion symbol: ')
    print('---------------------------------------------------------------------------------------------')
    getInfo(selection3Input)
if selection == 4:
    print('NH4OH with its individual polyatomic ions isolated looks like: ')
    print(isolateElements('NH4OH'))
