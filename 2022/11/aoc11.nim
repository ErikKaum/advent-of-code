import monkey
import algorithm
import bigints

let monkeys = parse_monkeys()
let rounds = 10_000


for round in 1..rounds:
    echo round
    for m in monkeys:
        for item in m.current_items:
            inc(m.count)
            
            m.calc_worry_level_item(item, monkeys)
            let to_monkey = m.calc_item_to_whom(item, monkeys)
            to_monkey.current_items.add(item)

        m.current_items = @[]


var res: seq[int64]
for m in monkeys:
    echo "---"
    echo m.count
    res.add(m.count)


res.sort()
echo res[^1] * res[^2]
echo res


