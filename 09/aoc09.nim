import matrix
import strutils
import tables
import math

type
    Move = enum
        up, down, left, right

    Instruction = ref object 
        move: Move
        amount: int

    State = ref object
        current: (int, int)
        previous: (int, int)

proc `$`(s: State): string = 
  result = "current: " & $s.current & "\t" & "previous: " & $s.previous

proc read_instructions(): seq[Instruction] =
  let f = open("./input.txt")
  for line in f.lines():
    var temp = new(Instruction)
    let splitted = line.split()
    temp.amount = parseInt($splitted[1])

    if splitted[0] == "U":
      temp.move = Move.up
    if splitted[0] == "D":
      temp.move = Move.down
    if splitted[0] == "L":
      temp.move = Move.left
    if splitted[0] == "R":
      temp.move = Move.right

    result.add(temp)

  f.close()

proc move_head(m: Matrix, direction: Move, current_x, current_y: int): (int, int) =
    m.change(current_x, current_y, ".")
    var new_x = current_x
    var new_y = current_y

    case direction:
        of up:
            new_x -= 1
        of down:
            new_x += 1
        of left:
            new_y -= 1
        of right:
            new_y += 1
 
    m.change(new_x, new_y, "H")
    result = (new_x, new_y)


proc move_tail(m: Matrix, x_head, y_head, x_tail, y_tail, x_prev, y_prev: int, key: string): (int, int) =
    m.change(x_tail, y_tail, ".")
    var new_x = x_tail
    var new_y = y_tail
    var should_move = false

    var x_abs = abs(x_head-x_tail)
    var y_abs = abs(y_head-y_tail)

    if (abs(x_head-x_tail) > 1) or (abs(y_head-y_tail) > 1):
        should_move = true

    if should_move == true:
        var add_x = if (x_head-x_tail) == 0: 0 else: int(floor((x_head-x_tail)/x_abs))
        var add_y = if (y_head-y_tail) == 0: 0 else: int(floor((y_head-y_tail)/y_abs)) 

        new_x = x_tail + add_x
        new_y = y_tail + add_y

        # new_x = x_prev
        # new_y = y_prev


    # echo should_move
    m.change(new_x, new_y, key)
    result = (new_x, new_y) 

proc update_score(m: Matrix, x, y: int): void =
    let item = m[x, y]
    m.change(x, y, item+1) 

proc update_mapping(mapping: OrderedTable[string, State], new_x, new_y: int, key: string): void =
  mapping[key].previous[0] = mapping[key].current[0]
  mapping[key].previous[1] = mapping[key].current[1]
  mapping[key].current[0] = new_x
  mapping[key].current[1] = new_y


proc main(): void =

    let inst = read_instructions()
    var grid = new(Matrix[string])
    var score = new(Matrix[int])
    let width = 1000
    let height = 1000
    
    grid.init(width, height, ".")
    score.init(width, height, 0)

    echo grid

    var current_x_h = 400
    var current_y_h = 400
    var current_x_t = 400
    var current_y_t = 400
    var start = 400

    grid.change(current_x_h, current_y_h, "H")
    grid.change(current_x_t, current_y_t, "T")

    let mapping = {
        "H" : State(current: (start, start), previous: (start, start)),
        "1" : State(current: (start, start), previous: (start, start)),
        "2" : State(current: (start, start), previous: (start, start)),
        "3" : State(current: (start, start), previous: (start, start)),
        "4" : State(current: (start, start), previous: (start, start)),
        "5" : State(current: (start, start), previous: (start, start)),
        "6" : State(current: (start, start), previous: (start, start)),
        "7" : State(current: (start, start), previous: (start, start)),
        "8" : State(current: (start, start), previous: (start, start)),
        "9" : State(current: (start, start), previous: (start, start)),
    }.toOrderedTable()

    var x_prev: int
    var y_prev: int

    for ins in inst:
        for amount in 1..ins.amount:
            
            current_x_h = mapping["H"].current[0]
            current_y_h = mapping["H"].current[1] 
 
            (current_x_h, current_y_h) = grid.move_head(ins.move, current_x_h, current_y_h)
            mapping.update_mapping(current_x_h, current_y_h, "H")
            # echo "H" , " ", mapping["H"] 
            
            x_prev = mapping["H"].previous[0]
            y_prev = mapping["H"].previous[1]

            for item, position in mapping:
                if item != "H":
                    current_x_t = mapping[item].current[0]
                    current_y_t = mapping[item].current[1]
                    (current_x_t, current_y_t) = grid.move_tail(current_x_h, current_y_h, current_x_t, current_y_t, x_prev, y_prev, item)
                    mapping.update_mapping(current_x_t, current_y_t, item)

                    x_prev = mapping[item].previous[0]
                    y_prev = mapping[item].previous[1]

                    current_x_h = mapping[item].current[0]
                    current_y_h = mapping[item].current[1]

                    # echo item , " ", mapping[item]
                    if item == "9":
                        score.update_score(current_x_t, current_y_t) 


            # echo grid
            # echo score
            # discard readLine(stdin)
    
    var sum = 0
    for i in score.data:
        if i > 0:
            inc(sum)

    echo sum

when isMainModule:
    main()





