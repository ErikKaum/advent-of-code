import system/io
import strutils
import sequtils
import algorithm

let f = open("./input.txt")
var sums: seq[int] = newSeq[int]()
var temp = 0 

for i in f.lines():
    if i.len() != 0: 
        var num = parseInt(i)
        temp += num 
    else:
        sums.add(temp)
        temp = 0

sums.sort(order = Descending)
echo sums[0] + sums[1] + sums[2]

f.close()

