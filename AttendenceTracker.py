#STILL WORK IN PROGRESS

#Requires two CSV files:
#File with all member names
#File with all names of people who attended

#Libraries - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

import csv

#Utilities - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def duplicateChecker(anyList):
    # anyList: list to be tested for duplicates

    checkedList = []
    duplicateList = []
    for value in anyList:
        if value in checkedList:
            duplicateList.append(value)
        else:
            checkedList.append(value)

    if len(duplicateList) == 0:
        return [False, []]
    else:
        return [True, duplicateList]
    # returns list: [boolean for if list contains duplicates , list of duplicates ([] if none)]

def printList(anyList, index='all'):
    # anyList: list that contains values to be printed
    # index: indicie of value to be printed if there are lists inside of anyList

    if index == 'all':
        for value in anyList:
            print(value)
    else:
        for value in anyList:
            print(value[index])
    # returns void: prints all values within a list with each value on a new line

def formattedString(numCharactersWide, startText, endText):
    # numCharactersWide: 
    # startText: 
    # endText: 

    numDashes = numCharactersWide - len(startText) - len(endText)
    return startText + '-' * numDashes + endText
    # returns string: 

def splitName(nameList):
    # nameList: 

    splitNameList = []
    for name in nameList:
        splitNamePair = name.split(' ')
        splitNameList.append(splitNamePair)

    return splitNameList
    # returns list: 

#Data Manipulation - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def createMemberList(fileName):
    # fileName: 

    memberList = []
    with open(fileName, encoding = 'utf-8') as memberFile:
        memberObject = csv.reader(memberFile)

        next(memberObject)
        for row in memberObject:
            fullName = row[0]
            memberList.append(fullName)

    return memberList
    # returns list: ['First Last',...]

def createAttendenceList(fileName):
    # fileName: 

    attendenceList = []
    with open(fileName, encoding = 'utf-8') as attendenceFile:
        attendenceObject = csv.reader(attendenceFile)

        next(attendenceObject)
        for row in attendenceObject:
            rawFullName = row[1]
            formattedFullName = rawFullName.strip().upper()
            attendenceList.append(formattedFullName)

    return attendenceList
    # returns list: ['First Last',...]

def presentOrNot(memberList, attendenceList):
    # memberList: 
    # attedenceList: 

    presentOrAbsentList = []
    for person in memberList:
        if person in attendenceList:
            presentOrAbsentList.append([person, 'Present'])
        else:
            presentOrAbsentList.append([person, 'Absent'])

    return presentOrAbsentList
    # returns list: [['First Last', 'Present' or 'Absent'],...]

def splitPresentOrNot(presentOrAbsentList):
    # presentOrAbsentList: 

    presentList = []
    absentList = []

    for person in presentOrAbsentList:
        if person[1] == 'Present':
            presentList.append(person[0])
        else:
            absentList.append(person[0])

    return [presentList, absentList]
    # returns list: [ []]

def isPresentListValid(presentList, attendenceList):
    # presentList: 
    # attendenceList: 

    if len(presentList) == len(attendenceList):
        return True
    else:
        return False
    # returns boolean: 

#Outputs - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def detailedOutput(presentList, absentList, memberList, attendenceList, presentOrAbsentList):
    # presentList: 
    # absentList: 
    # memberList: 
    # attendenceList: 
    # presentOrAbsentList: 

    print()
    standardOutputOrdered = []
    for person in presentOrAbsentList:
        standardOutputOrdered.append(f'{person[0]} ({person[1]})')
    print('Standard output is printed in this order:')
    printList(standardOutputOrdered)

    print()
    formattedPresentList = []
    for person in presentList:
        formattedPresentList.append(formattedString(50, person, 'Present'))
    printList(formattedPresentList)
    
    print()
    formattedAbsentList = []
    for person in absentList:
        formattedAbsentList.append(formattedString(50, person, 'Absent'))
    printList(formattedAbsentList)

    print()
    memberListDuplicateChecker = duplicateChecker(memberList)
    if memberListDuplicateChecker[0] == True:
        print('Duplicates in member list:')
        printList(memberListDuplicateChecker[1])

    else:
        print('No duplicates in member list')

    print()
    attendenceListDuplicateChecker = duplicateChecker(attendenceList)
    if attendenceListDuplicateChecker[0] == True:
        print('Duplicates in attendence list:')
        printList(attendenceListDuplicateChecker[1])

    else:
        print('No duplicates in attendence list')

    print()
    numPresent = len(presentList)
    numAbsent = len(absentList)
    numMembers = numPresent + numAbsent
    print(f'{numPresent} / {numMembers} members were present at this meeting')
    print(f'{int((numPresent/numMembers) * 100)}% attendence rate')
    #returns void: prints detailed report on various data

def standardOutput(presentOrAbsentList):
    # presentOrAbsentList: 
    printList(presentOrAbsentList, 1)
    # returns void: 

#Misc - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def test(mode):
    # mode: 

    memberList = createMemberList('member_list.csv')
    attendenceList = createAttendenceList('10_14_attendence_list.csv')

    presentOrAbsentList = presentOrNot(memberList, attendenceList)
    splitPresentOrAbsentList = splitPresentOrNot(presentOrAbsentList)

    presentList = splitPresentOrAbsentList[0]
    absentList = splitPresentOrAbsentList[1]

    if mode == 0:
        standardOutput(presentOrAbsentList)

    if mode == 1:
        detailedOutput(presentList, absentList, memberList, attendenceList, presentOrAbsentList)
    #returns void: 

#Run - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test(0)