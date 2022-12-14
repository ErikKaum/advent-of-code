import strutils
import json
import std/options
import algorithm

proc getInt(n: JsonNode, default = none(int)): Option[int] =
  if n.isNil or n.kind != JInt: return default
  else: return some(int(n.num))

proc validate(left, right: JsonNode): Option[bool] =

    let shorter = if left.len() < right.len(): left else: right
    for i in 0..shorter.len()-1:

        # echo "left[i]: ", left[i], " right[i]: ", right[i]
        # discard readLine(stdin)

        # both are seq
        if left[i].getInt() == none(int) and right[i].getInt() == none(int):
            var res = validate(left[i], right[i])
            if res != none(bool):
                return res

        #both are ints
        elif left[i].getInt() != none(int) and right[i].getInt() != none(int):
            
            if left[i].getInt().get() < right[i].getInt().get():
                return some(true)
            elif left[i].getInt().get() > right[i].getInt().get():
                return some(false)
            else:
                discard
        
        # left is int and right is seq
        elif left[i].getInt() != none(int) and right[i].getInt() == none(int):
            var fakeNode = %*[left[i].getInt().get()]
            var res = validate(fakeNode, right[i])
            if res != none(bool):
                return res
        
        # right is int and left is seq
        elif left[i].getInt() == none(int) and right[i].getInt() != none(int):
            var fakeNode = %*[right[i].getInt().get()]
            var res = validate(left[i], fakeNode)
            if res != none(bool):
                return res

    if left.len() > right.len():
        return some(false)
    elif left.len() < right.len():
        return some(true)
    else:
        return none(bool)


proc comparator(left, right: JsonNode): int =
    if validate(left, right) == some(true):
        return 1
    elif validate(left, right) == some(false):
        return -1
    else:
        return 0

var f = readFile("./input.txt")
var grouped = f.split("\n\n")
var correct_indecies: seq[int]
var all_packages: seq[JsonNode]

grouped.add("[[2]]\n[[6]]\n\n" )


for index, group in grouped:
    let packages = group.split("\n")

    let package1 = parseJson(packages[0])
    let package2 = parseJson(packages[1])

    all_packages.add(package1)
    all_packages.add(package2)
    
    let correctOrder = validate(package1, package2)

    # Part 1
    if correctOrder == some(true):
        correct_indecies.add(index+1)
        
# echo correct_indecies

var sum = 0
for answer in correct_indecies:
    sum += answer

# echo sum

# part 2
sort(all_packages, cmp=comparator, order = SortOrder.Descending)

var lol: seq[int]
for index, i in all_packages:
    if i == %*[[2]] or i == %*[[6]]:
        lol.add(index+1)

echo lol


