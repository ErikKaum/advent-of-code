import sequtils
import strutils


type
    Coordinate = ref object
        x,y : int
    
    Rock = ref object
        data: seq[Coordinate]

    Grid = ref object
        data: seq[seq[char]]

proc `$`(g: Grid): string =
    for i in g.data:
        for j in i:
            result.add(j)
        result.add("\n")

proc `$`(c: Coordinate): string =
    result = "x: " & $c.x & " y: " & $c.y

proc `$`(r: Rock): string =
    for i in r.data:
        result.add($i & "\t")

proc getInput(): seq[Rock] = 
    var listOfRocks: seq[Rock]
    let f = open("./input.txt")
    for line in f.lines():
        let splitted = line.split("->")
        var tempRock = new(Rock)

        for coord in splitted:
            let
                cleanItem = coord.replace(" ", "")
                cleanCoords = cleanItem.split(",")

            var tempCoord = Coordinate(
                x: parseInt(cleanCoords[0]),
                y: parseInt(cleanCoords[1])
            )

            tempRock.data.add(tempCoord)
        
        listOfRocks.add(tempRock)
    
    result = listOfRocks
    f.close()

proc convertScale(c: Coordinate, minX, minY: int): void =
    c.x = c.x - minX
    c.y = c.y - minY

proc drawRock(g: Grid, r: Rock): void =
    for i in 0..r.data.len():
        
        if i+1 == r.data.len():
            break

        let point1 = r.data[i]
        let point2 = r.data[i+1]

        # echo point1
        # echo point2

        if point1.x == point2.x:
            let bigger = if point1.y > point2.y: point1.y else: point2.y
            let smaller = if point1.y > point2.y: point2.y else: point1.y
            
            let diffRange = toSeq(smaller..bigger)
            # echo diffRange
            for item in diffRange:
                # echo item, point1.x
                g.data[item][point1.x] = '#'

        if point1.y == point2.y:
            let bigger = if point1.x > point2.x: point1.x else: point2.x
            let smaller = if point1.x > point2.x: point2.x else: point1.x

            let diffRange = toSeq(smaller..bigger)
            # echo diffRange
            for item in diffRange:
                # echo item, point1.y
                g.data[point1.y][item] = '#'

        # echo g
        # discard readLine(stdin)

proc sand(g: Grid, start: (int, int), round: int): void =

    var
        hasLanded = false
        currentX = start[0]
        currentY = start[1]

    g.data[currentX][currentY] = '+'

    while not hasLanded:
        
        try:
            discard g.data[currentX+1][currentY]
        except:
                echo "round: ", round
                echo "out of bounds"
                system.quit() 
        
        try:
            discard g.data[currentX+1][currentY-1]
        except:
                echo "round: ", round
                echo "out of bounds"
                system.quit()
        
        try:
            discard g.data[currentX+1][currentY+1]
        except:
                echo "round: ", round
                echo "out of bounds"
                system.quit() 


        # down
        if g.data[currentX+1][currentY] == '.':
            g.data[currentX+1][currentY] = '+'  
            g.data[currentX][currentY] = '.'
            inc(currentX)

        # left
        elif g.data[currentX+1][currentY-1] == '.':
            g.data[currentX+1][currentY-1] = '+'  
            g.data[currentX][currentY] = '.'
            inc(currentX)
            dec(currentY)
        # right
        elif g.data[currentX+1][currentY+1] == '.':
            g.data[currentX+1][currentY+1] = '+'  
            g.data[currentX][currentY] = '.'
            inc(currentX)
            inc(currentY)
        else:
            g.data[currentX][currentY] = 'o'
            hasLanded = true

        if currentX == start[0] and currentY == start[1]:
            echo "done: ", round+1
            system.quit()
        # echo g
        # discard readLine(stdin)

proc main(): void =
    var listOfRocks = getInput()
    var grid = new(Grid)

    var
        allX: seq[int]
        allY: seq[int]

    for rock in listOfRocks:
        for coord in rock.data:
            allX.add(coord.x)
            allY.add(coord.y)

    var
        scaleLeft = 1000
        minX = allX[minIndex(allX)] - scaleLeft
        minY = allY[minIndex(allY)]
        maxX = allX[maxIndex(allX)]
        maxY = allY[maxIndex(allY)]
        correctedStart = 500-minX

    minY = 0
    let scaleRight = 1000
    var floor = Rock(
        data: 
        @[Coordinate(
            x: minX,
            y: maxY+2
        ),
        Coordinate(
            x: maxX + scaleRight,
            y: maxY+2
        )] 
    )
    listOfRocks.add(floor)


    
    for rock in listOfRocks:
        for coord in rock.data:
            convertScale(coord, minX, minY)
    
    
    for _ in 0..maxY-minY+2:
        var tempRow: seq[char]
        for _ in 0..maxX-minX+scaleRight:
            tempRow.add('.')
        grid.data.add(tempRow)

    for rock in listOfRocks:
        grid.drawRock(rock)

    var i = 0
    while true:
        grid.sand((0, correctedStart), i)
        inc(i)
        # echo grid
        # discard readLine(stdin)

when isMainModule:
    main()