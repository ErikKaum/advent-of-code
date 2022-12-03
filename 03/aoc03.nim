import sequtils
import strutils
import tables
import std / enumerate

# let f = [
#     "vJrwpWtwJgWrhcsFMMfFFhFp",
#     "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL",
#     "PmmdzqPrVvPwwTWBwg",
#     "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn",
#     "ttgJtRGJQctTZtZT",
#     "CrZsJsPPZsGzwwsLwLmpwMDw",
# ]

let points = toSeq(1..52)
let chars = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

let combined = zip(chars, points)
let table = combined.toTable()

var main_score = 0

var temp_string: string

let f = open("./input.txt")
for index, line in enumerate(f.lines()):

    # part 1
    # let len = line.len()
    # assert len%%2==0
    # let half = int(len/2)

    # let comp_one = line[0..half-1]    
    # let comp_two = line[half..len-1]

    # var found: char
    # for letter in comp_one:
    #     if letter in comp_two:
    #         found = letter

    # main_score += table[found]

       
    # part 2
    temp_string = temp_string&line&" "
    if (index+1) %% 3 == 0:

        let items = temp_string.split()

        var temp_seq: seq[char] = @[]
        var found: char
        for letter in items[0]:
            if letter in items[1]:
                temp_seq.add(letter)

        for thing in temp_seq:
            if thing in items[2]:
                found = thing

        main_score += table[found]
        temp_string = ""


    
    

echo main_score

f.close()

