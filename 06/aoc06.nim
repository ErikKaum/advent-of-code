import std/enumerate

# let f = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"
let f = open("./input.txt")
let line = f.readLine()

proc checkDuplicate(s: string): bool =
    result = false
    for i in 0..s.high:
        let item = s[i]
        for j in (i+1)..s.high:
            if s[j] == item:
                result = true

for index, i in line:
    let upper = index + 13
    if upper < line.high:
        let substring = line[index..upper]
        let res = checkDuplicate(substring)
        if res == false:
            echo index+14
            break
        echo substring
        echo res
        echo "-------"


f.close()
