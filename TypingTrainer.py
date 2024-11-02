#Modules
import random, msvcrt, time

#Config
TIME_DELAY = 0
DISPLAY_TIMER = True
TERMINATION_CHAR = '`'
CORRECT_CHAR = '✅'
WRONG_CHAR = '❌'
DISPLAY_FINAL_STATS = True
SECONDS_WINDOW_STAYS_OPEN = 60
TYPE_CONSOLE = 'powershell' #powershell, vscode
NUM_LETTERS_DISPLAYED = 10

#Constants
CHARS = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']
END_MESSAGES = ['You can do better.', 'Subpar performance.', 'Get 50+ correct and a score of 1340+.']

#Functions
def getInput(letter):
    print(f'{letter}  ' * NUM_LETTERS_DISPLAYED)
    print(': ', end='', flush=True)
    startTime = time.time()
    userInput = msvcrt.getch().decode("utf-8")
    endTime = time.time()
    deltaTime = endTime - startTime
    print(userInput)
    time.sleep(TIME_DELAY)
    return userInput, deltaTime

def displayFinalStats():
    print('Final Stats')
    print('-' * 11)

    averageTime = totalTime / numCorrect
    print(f'Average time: {averageTime} seconds')

    print(f'Number correct: {numCorrect}')
    print(f'Number incorrect: {numWrong}')

    percentageCorrect = (numCorrect / (numCorrect + numWrong)) * 100
    print(f'Percentage correct: {percentageCorrect}%')

    print()

    score = (1 / averageTime) * (percentageCorrect) * 10
    print(f'Score: {score}')

    rank = f'{random.choice(END_MESSAGES)} Try again.'
    if (score > 1340) and (numCorrect >= 50):
        rank = 'Goated'
    print(rank)

    print()
    print(f'This window will close in {SECONDS_WINDOW_STAYS_OPEN} seconds')
    time.sleep(SECONDS_WINDOW_STAYS_OPEN)

def countdown(duration):
    for i in range(duration):
        print(duration - i)
        time.sleep(1)

#Main
totalTime = 0
numCorrect = 0
numWrong = 0

print('Ready?')
countdown(3)
print()

while 1:
    letter = random.choice(CHARS)
    sumTime = 0
    while 1:
        entry, deltaTime = getInput(letter)
        if entry == TERMINATION_CHAR:
            print()
            if DISPLAY_FINAL_STATS:
                displayFinalStats()
            quit()
        sumTime += deltaTime
        
        if letter.lower() == entry.lower():
            printedTime = str(sumTime)[:(str(sumTime).find('.') + 3)]

            if TYPE_CONSOLE == 'vscode':
                print(f'{CORRECT_CHAR} ', end='')
                if DISPLAY_TIMER:
                    print(f'{printedTime} sec', end='')
                print('\n')
            if TYPE_CONSOLE == 'powershell':
                print('  /')
                print('\\/')
                if DISPLAY_TIMER:
                    print(f'{printedTime} sec')
                    print()

            totalTime += sumTime
            numCorrect += 1
            break
        
        numWrong += 1
        if TYPE_CONSOLE == 'vscode':
            print(f'{WRONG_CHAR}\n')
        if TYPE_CONSOLE == 'powershell':
            print('\\/')
            print('/\\')
            print()