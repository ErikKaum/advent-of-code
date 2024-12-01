import algorithm
import strutils

type
    Matrix[T] = ref object
        data: seq[T]
        width: int
        height: int

proc `[]`(m: Matrix, x, y: int): m.T =
    assert x < m.width
    assert y < m.height
    m.data[x * m.height + y]

proc change(m: Matrix, x, y: int, new_value: m.T): void =
    assert x < m.width
    assert y < m.height
    m.data[x * m.height + y] = new_value

proc `$`(m: Matrix): string = 
    for index, item in m.data:
        result.add(" " & $item & " ")
        if (index+1)%%m.width == 0:
            result.add("\n") 

proc row(m: Matrix, i: int): seq[m.T] =
    let start = i * m.width
    let ending = start + m.width-1
    m.data[start..ending]

proc column(m: Matrix, i: int): seq[m.T] =
    for x in 0..m.height-1:
        result.add(m[x, i])


var m = new(Matrix[int])
var width = 0
var height = 0

let f = open("./input.txt")
for line in f.lines():
    width = line.len() 
    for number in line:
        let num = parseInt($number)
        m.data.add(num)
    inc(height)

m.width = width
m.height = height

f.close()

proc score_direction(item: int, direction: seq[int]): int =
  var score = 0
  for tree in direction:
    inc(score)
    if tree >= item:
      break

  result = score
  
proc check_one(item: int, direction: seq[int]): bool =
    result = true 
    for i in direction:
        if i >= item:
            result = false
            break

proc calc_score(m: Matrix[int], score_matrix: Matrix[int], x, y: int): void =
    let item = m[x, y]
    let current_row = m.row(x)
    let current_colmn = m.column(y)

    let right = current_row[y+1..m.width-1]
    
    var left = current_row[0..y-1]
    left.reverse()

    let down = current_colmn[x+1..m.height-1]
    
    var up = current_colmn[0..x-1]
    up.reverse()

    let right_score = score_direction(item, right)
    let left_score = score_direction(item, left)
    let down_score = score_direction(item, down)
    let up_score = score_direction(item, up)

    echo up_score
    echo left_score
    echo right_score
    echo down_score

    let total_score = right_score * left_score * down_score * up_score
    score_matrix.change(x, y, total_score)


proc check_visibility(m: Matrix[int], visibility: Matrix[bool], x, y: int): void =
    let item = m[x, y]
    let current_row = m.row(x)
    let current_colmn = m.column(y)

    let right = current_row[y+1..m.width-1]
    let left = current_row[0..y-1]
    let down = current_colmn[x+1..m.height-1]
    let up = current_colmn[0..x-1]

    let right_visible = check_one(item, right)
    let left_visible = check_one(item, left)
    let down_visible = check_one(item, down)
    let up_visible = check_one(item, up)

    if (right_visible == false) and (left_visible == false) and (up_visible == false) and (down_visible == false):
        discard 
    else:
        visibility.change(x, y, true)


var visibility_matrix = new(Matrix[bool])
visibility_matrix.width = width
visibility_matrix.height = height

let total = width*height
for i in 0..total-1:
    visibility_matrix.data.add(false)

# echo visibility_matrix

# part 1
# for x in 0..m.width-1:
#     for y in 0..m.height-1:
#         if (x == 0) or (y == 0) or (x == m.width-1) or (y == m.height-1):
#             visibility_matrix.change(x, y, true)
#         else:
#             check_visibility(m, visibility_matrix, x, y)

# var sum = 0
# for tree in visibility_matrix.data:
#     if tree == true:
#         inc(sum)
# echo sum

# part 2
var score_matrix = new(Matrix[int])
score_matrix.width = width
score_matrix.height = height

for i in 0..total-1:
    score_matrix.data.add(0)


# calc_score(m, score_matrix, 2, 1)
# echo score_matrix

for x in 0..m.width-1:
    for y in 0..m.height-1:
        calc_score(m, score_matrix, x, y)

echo score_matrix

var highest_score = 0
for score in score_matrix.data:
    if score > highest_score:
        highest_score = score

echo highest_score

