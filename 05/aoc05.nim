import sequtils
import strutils
import std/algorithm


proc print_cont(cont: seq[seq[char]]): void =
    for i in cont:
        echo i

proc parse_container(path: string): seq[seq[char]] =

    var container: seq[seq[char]]
    
    var steps: seq[int]
    var len = 35
    # len = 9
    for i in countup(1, len, 4):
        steps.add(i)

    let f = open(path)
    for line in f.lines():

        if line.len() == 0:
            break
        else:
            let parsed_line = line.toSeq()
            var temp: seq[char]
            
            for j in steps:
                temp.add(parsed_line[j])
            
            container.add(temp)

    f.close()
    container.del(container.high)
    container.print_cont()

    result = container

proc parse_instructions(path: string): seq[seq[int]] =
    
    var instructions: seq[seq[int]]

    let f = open(path)
    var before = true 
    for line in f.lines():
        
        if line.len() == 0:
            before = false

        if before == false:
            var splitted = line.split()
            var temp: seq[int]
            for i in splitted:
                try:
                    let num = parseInt(i)
                    temp.add(num)
                except:
                    discard
            instructions.add(temp)


    f.close()
    result = instructions
 
proc move_one(container: var seq[seq[char]], from_col, to_col: int): void =

    # take out
    var temp: char 
    for row , i in container:
        if i[from_col] != ' ':
            temp = i[from_col]
            container[row][from_col] = ' '
            break
    
    # put in
    var create_new_row = false
    var insert_row = 0

    for row, i in container:
        if (i[to_col] == ' '):
            insert_row = row
        if (i[to_col] != ' ') and (row == 0):
            create_new_row = true
    if create_new_row == false:
        container[insert_row][to_col] = temp
    
    # create new row if needed
    else:
        var new_row: seq[char]
        for i in 1..container[0].high+1:
            new_row.add(' ')
        new_row[to_col] = temp
        container.insert(new_row, 0)

proc move_many(container: var seq[seq[char]], from_col, to_col, amount: int): void =

    # take out
    var temp_seq: seq[char] 
    for row , i in container:
        if i[from_col] != ' ':
            temp_seq.add(i[from_col])
            container[row][from_col] = ' '
            if temp_seq.len() == amount:
                break
    
    temp_seq.reverse()
    # echo "temp ", temp_seq
    # print_container(container)

    for temp in temp_seq:
        # put in
        var create_new_row = false
        var insert_row = 0

        for row, i in container:
            if (i[to_col] == ' '):
                insert_row = row
            if (i[to_col] != ' ') and (row == 0):
                create_new_row = true
        if create_new_row == false:
            container[insert_row][to_col] = temp
        
        # create new row if needed
        else:
            var new_row: seq[char]
            for i in 1..container[0].high+1:
                new_row.add(' ')
            new_row[to_col] = temp
            container.insert(new_row, 0)

proc get_result(container: seq[seq[char]]): string =

    let n_rows = container.len()
    let n_cols = container[0].len()
    var res: string

    for i in 0..n_cols-1:
        for j in 0..n_rows-1:
            if container[j][i] != ' ':
                res.add(container[j][i]) 
                break
    result = res

proc main(): void =
    let path = "./input.txt"
    var container = parse_container(path)
    let instructions = parse_instructions(path)

    for i in instructions:
        if i.len() == 0:
            discard
        else:
            let amount = i[0]
            let from_col = i[1]-1
            let to_col = i[2]-1

            # echo "amount: ", amount
            # echo "from_col: ", from_col
            # echo "to_col: ", to_col 

            if amount == 1:
                move_one(container, from_col, to_col)
            else:
                move_many(container, from_col, to_col, amount)
                # echo "--------"
    
    echo "---------"
    print_cont(container)
    let res = get_result(container)
    echo res 

when isMainModule:
    main()