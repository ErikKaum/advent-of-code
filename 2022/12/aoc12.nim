import matrix
import sequtils
import tables
import std/sets
import std/deques

var m = new(Matrix[char])

m.init(0, 0, '.')

let f = open("./input.txt")
for line in f.lines():
    m.height = line.len()
    for item in line:
        m.data.add(item)
    inc(m.width)

let lower = @"abcdefghijklmnopqrstuvwxyz"
let height = toSeq(1..26)
let elevation = zip(lower, height).toTable()

proc bfs(start: (int, int)): int =

    var visited = toHashSet([start])
    var q = [(start[0], start[1], 0)].toDeque()

    while q.len() > 0:
        # echo "queue: ", q
        var (i, j, d) = q.popFirst()

        if m[i, j] == 'E':
            # echo "result: ",d
            result = d

        # echo "current ", m[i,j], " index: ", i, " ",j

        for (ni, nj) in [(i+1, j), (i-1, j), (i, j-1), (i, j+1)]:
            if ((0 <= ni and ni < m.width)) and (0 <= nj and nj < m.height):
                var current = m[ni, nj]
                # echo "sub_current ", current, " index: ", ni, " ",nj
                # echo "visited: ", visited
                var temp = m[i,j]
                
                # echo "BOOL:"
                # echo elevation[current] - elevation[temp] <= 1 


                if (m[ni,nj] == 'E') and ((elevation['z'] - elevation[temp]) <= 1):
                    # echo "added in first: ",(ni,nj, d+1)
                    q.addLast((ni, nj, d+1))

                elif ((m[ni,nj] != 'E') and (not visited.contains((ni,nj))) and (elevation[current] - elevation[temp] <= 1)):
                    # echo "added in second: ",(ni,nj, d+1)
                    visited.incl((ni, nj))
                    q.addLast((ni, nj, d+1))

        # discard readLine(stdin)

# part 1
# for i in 0..m.width-1:
#     for j in 0..m.height-1:
#         if m[i,j] == 'S':
#             m.change(i, j, 'a')
#             echo bfs((i,j))            


# part 2
var temp: seq[int]

for i in 0..m.width-1:
    for j in 0..m.height-1:
        if m[i,j] == 'S':
            m.change(i, j, 'a')

for i in 0..m.width-1:
    for j in 0..m.height-1:
        if m[i,j] == 'a':
            var res = bfs((i, j))
            temp.add(res)

echo temp

var min = 500
for item in temp:
    if item < min and item != 0:
        min = item

echo min

