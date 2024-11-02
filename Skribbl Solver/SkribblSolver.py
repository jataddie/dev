import csv

NUMBERS = ['0','1','2','3','4','5','6','7','8','9']

rawData = [0,0,0]

with open ('skribbl-words1.csv', 'r') as csv_file:
	csv_reader = csv.reader(csv_file)
	
	tempList = []
	currentI = 3
	currentIchar = '3'

	for line in csv_reader:
		if line[1] != currentIchar:
			rawData.append(tempList)
			tempList = []
			currentI += 1
			currentIchar = str(currentI)
		tempList.append(line[0])
	rawData.append(tempList)

while 1:
	try:
		lenInput = input("Length (3-19): ")
		if lenInput == 'end':
			break
		lenInput = int(lenInput)
		if (lenInput < 3) or (lenInput > 19):
			print('length has to be between 3 and 19')
			continue

	except:
		print('not integer')
		continue
	
	data = sorted(rawData[lenInput])

	while 1:
		userInput = input(str(lenInput) + ": ")
		if userInput == 'end':
			break
		if userInput == 'ns':
			noSpaceTemp = []
			for value in data:
				if ' ' not in value:
					noSpaceTemp.append(value)
			data = noSpaceTemp
			noSpaceTemp = []
			if len(data) == 0:
				print('No possible words. Type "end" and try again.')
			for value in data:
				print(value)
			continue
		if userInput == 'os':
			onlySpaceTemp = []
			for value in data:
				if ' ' in value:
					onlySpaceTemp.append(value)
			data = onlySpaceTemp
			onlySpaceTemp = []
			if len(data) == 0:
				print('No possible words. Type "end" and try again.')
			for value in data:
				print(value)
			continue
		if userInput == 'nc':
			noCapitalTemp = []
			for value in data:
				if value == value.lower():
					noCapitalTemp.append(value)
			data = noCapitalTemp
			noCapitalTemp = []
			if len(data) == 0:
				print('No possible words. Type "end" and try again.')
			for value in data:
				print(value)
			continue
		if userInput == 'oc':
			onlyCapitalTemp = []
			for value in data:
				if value != value.lower():
					onlyCapitalTemp.append(value)
			data = onlyCapitalTemp
			onlyCapitalTemp = []
			if len(data) == 0:
				print('No possible words. Type "end" and try again.')
			for value in data:
				print(value)
			continue
		if userInput == 'now':
			for value in data:
				print(value)
			continue

		location = []
		searchData = []

		try:
			for value in userInput:
				if value in NUMBERS:
					location.append(value)
				else:
					hintLocation = int(''.join(location))
					if (hintLocation > lenInput) or (hintLocation == 0):
						int('')
					hintLocation -= 1
					location = []
					searchData.append([hintLocation, value])
		except:
			print('invalid input')
			continue

		tempData = []

		for hint in searchData:
			for value in data:
				if value[hint[0]] == hint[1]:
					tempData.append(value)
			data = tempData
			tempData = []

		if len(data) == 0:
			print('No possible words. Type "end" and try again.')
		for value in data:
			print(value)
