import strutils
import bigints
import math

type
    Item* = ref object
        wl*: int64
    
    Monkey* = ref object
        name*: string
        starting_items: seq[int64]
        op1: string
        op2: string
        divisor: string
        true_monkey_index: int64
        false_monkey_index: int64
        throw_to*: seq[Monkey]
        current_items*: seq[Item]
        count*: int64

proc `$`*(i: Item): string =
    result = "item with wl: " & $i.wl & "\n"

proc `$`*(m: Monkey): string =
    result.add(m.name & "\n")
    for i in m.current_items:
        result.add($i)

proc operation(op1, op2: string, item: int64): int64 =
    var op2_clean: int64
    try:
      op2_clean = parseInt(op2)
    except:
      op2_clean = item

    if op1 == "+":
    #   echo item, "+", op2_clean
      result = item + op2_clean
    else:
    #   echo item, "*" ,op2_clean
      result = item * op2_clean

proc calc_worry_level_item*(m: Monkey, item: Item, monkeys: seq[Monkey]): void =
    let res1 = operation(m.op1, m.op2, item.wl)
    
    # part 1
    # let res2 = int(res2/3)
    # item.wl = res2

    # part 2 
    var divisors: seq[int64]
    for m in monkeys:
        let divi = parseInt(m.divisor)
        divisors.add(divi)
    
    let least = lcm(divisors)
    let wl = res1 mod least
    item.wl = wl

proc calc_to_whom(m: Monkey, all_monkeys: seq[Monkey]): void =
    let divisor_clean = parseInt(m.divisor)

    for index, item in m.current_items:
        if item.wl %% divisor_clean == 0:
            m.throw_to.add(all_monkeys[m.true_monkey_index])
        else:
            m.throw_to.add(all_monkeys[m.false_monkey_index])

proc calc_item_to_whom*(m: Monkey, item: Item ,all_monkeys: seq[Monkey]): Monkey =
    let divisor_clean = parseInt(m.divisor)

    if item.wl %% divisor_clean == 0:
        result = all_monkeys[m.true_monkey_index]
    else:
        result = all_monkeys[m.false_monkey_index]

proc parse_monkeys*(): seq[Monkey] =
    var list_of_monkeys: seq[Monkey]
    var current_monkey: Monkey

    let f = open("./input.txt")
    for line in f.lines():

        if line.contains("Monkey"):
            let splitted = line.split()
            var temp = new(Monkey)
            temp.name = splitted[1]
            temp.name = "Monkey " & temp.name[0]
            list_of_monkeys.add(temp)
            current_monkey = temp

        if line.contains("Starting"):
            let splitted = line.split()
            for i in 4..splitted.len()-1:
                var num = splitted[i]
                num = num.replace(",","")
                var number= parseInt(num)
                current_monkey.starting_items.add(number)

        if line.contains("Operation"):
            let splitted = line.split()    
            let op1 = splitted[6]
            let op2 = splitted[7]
            
            current_monkey.op1 = op1
            current_monkey.op2 = op2

        if line.contains("Test"):
            let splitted = line.split()
            let divisor = splitted[5]
            current_monkey.divisor = divisor

        if line.contains("If true"):
            let splitted = line.split()
            current_monkey.true_monkey_index = parseInt(splitted[9]) 
        
        if line.contains("If false"):
            let splitted = line.split()
            current_monkey.false_monkey_index = parseInt(splitted[9])



    for m in list_of_monkeys:
        for index, item in m.starting_items:
            var temp = Item(
                wl: item
            )
            m.current_items.add(temp)
    
    for m in list_of_monkeys:
        m.calc_to_whom(list_of_monkeys)


    result = list_of_monkeys