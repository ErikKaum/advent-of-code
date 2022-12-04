import sequtils
import strutils

# var f = [
#     "2-4,6-8",
#     "2-3,4-5",
#     "5-7,7-9",
#     "2-8,3-7",
#     "6-6,4-6",
#     "2-6,4-8",
# ]

var main_score = 0

let f = open("./input.txt")
for line in f.lines():

    let tasks = line.split(",")
    let first_elf = tasks[0].split("-")
    let second_elf = tasks[1].split("-")


    let first_range = toSeq(parseInt(first_elf[0])..parseInt(first_elf[1]))
    let second_range = toSeq(parseInt(second_elf[0])..parseInt(second_elf[1]))

    # part 1
    var shorter: seq[int]
    var longer: seq[int]
    
    if first_range.len() < second_range.len():
        shorter = first_range
        longer = second_range
    else:
        shorter = second_range
        longer = first_range

    if (shorter[shorter.low] >= longer[longer.low]) and (shorter[shorter.high] <= longer[longer.high]):
        main_score += 1

    # part 2
    # for i in first_range:
    #     if i in second_range:
    #         main_score += 1
    #         break     

echo main_score


f.close()