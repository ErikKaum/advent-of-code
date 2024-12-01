import strutils

type 
    InstructionType = enum
        noop, addx
    
    Instructions = ref object
        mnemonic: InstructionType
        operand: int

    Cpu = ref object
        cycles: int
        register: int

    Crt = ref object
        data: array[40*6, string]


proc init(c: Crt): void = 
    for i in 0..c.data.len()-1:
        c.data[i] = "."

proc `$`(c: Crt): string =
    for index, item in c.data:
        if index%%40==0:
            result.add("\n")
        result.add(item)


proc `$`(c: Cpu): string =
    let signal = c.cycles * c.register
    result = "cycles: " & $c.cycles & "\t" & "register: " & $c.register & "\t" & "signal: " & $signal

proc read_instructions(): seq[Instructions] =
    let f = open("./input.txt")
    for line in f.lines():
        let splitted = line.split()
        let mnemonic = splitted[0]
        let operand = if splitted.len() > 1: parseInt(splitted[1]) else: 0

        var temp = Instructions(
        operand: operand
        )
        if mnemonic == "noop":
            temp.mnemonic = InstructionType.noop
        else:
            temp.mnemonic = InstructionType.addx

        result.add(temp)


proc main(): void =
    var c = Cpu(
        cycles: 0,
        register: 1
    )
    var crt = new(Crt)
    crt.init

    var sum = 0
    let instructions = read_instructions()
    for ins in instructions:

        case ins.mnemonic:
            of InstructionType.noop:
                
                if int(abs(c.register - c.cycles %% 40)) <= 1:
                    crt.data[c.cycles] = "#"
                # echo crt
                inc(c.cycles)
                # echo c

            of InstructionType.addx:
                for i in 0..1:
                    
                    if int(abs(c.register - c.cycles %% 40)) <= 1:
                        crt.data[c.cycles] = "#"
                    # echo crt                    
                    inc(c.cycles)
                    # echo c
                    
                    if i == 1:
                        c.register += ins.operand


        # discard readLine(stdin)

    echo crt

when isMainModule:
    main()