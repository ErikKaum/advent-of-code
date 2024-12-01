type
    Matrix*[T] = ref object
        data*: seq[T]
        width: int
        height: int

proc `[]`*(m: Matrix, x, y: int): m.T =
    assert x < m.width
    assert y < m.height
    m.data[x * m.height + y]

proc change*(m: Matrix, x, y: int, new_value: m.T): void =
    assert x < m.width
    assert y < m.height
    m.data[x * m.height + y] = new_value

proc `$`*(m: Matrix): string = 
    for index, item in m.data:
        result.add(" " & $item & " ")
        if (index+1)%%m.width == 0:
            result.add("\n") 

proc init*(m: Matrix, width, height: int, default: m.T): void =
    m.width = width
    m.height = height
    let total = width * height
    for i in 0..total-1:
        m.data.add(default)


proc row(m: Matrix, i: int): seq[m.T] =
    let start = i * m.width
    let ending = start + m.width-1
    m.data[start..ending]

proc column(m: Matrix, i: int): seq[m.T] =
    for x in 0..m.height-1:
        result.add(m[x, i])
