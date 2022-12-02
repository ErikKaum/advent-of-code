import tables
import strutils

let mapping = {
    "A" : "rock",
    "B" : "paper",
    "C" : "scissors",
    "X" : "rock",
    "Y" : "paper",
    "Z" : "scissors"
}.toTable()

let second_mapping = {
    "A" : "rock",
    "B" : "paper",
    "C" : "scissors",
    "X" : "lose",
    "Y" : "draw",
    "Z" : "win"
}.toTable()


proc check_winner(my_move, opponent_move: string): int =

    let base = if my_move == "rock": 1 elif my_move == "paper": 2 else: 3

    var score = 0
    if my_move == opponent_move:
        score = 3
    # I loose case
    elif (opponent_move=="rock" and my_move=="scissors") or (opponent_move=="paper" and my_move=="rock") or (opponent_move=="scissors" and my_move=="paper"):
        score = 0
    else:
        score = 6

    result = score + base

proc reverse(outcome, opponent_move: string): int =

    var my_move: string
    
    if outcome == "draw":
        my_move = opponent_move
    # lose case
    elif outcome == "lose":
        if opponent_move=="rock":
            my_move = "scissors"
        if opponent_move=="paper":
            my_move = "rock"
        if opponent_move=="scissors":
            my_move = "paper"
    # win case
    else:
        if opponent_move=="rock":
            my_move = "paper"
        if opponent_move=="paper":
            my_move = "scissors"
        if opponent_move=="scissors":
            my_move = "rock"
    
    var score = check_winner(my_move, opponent_move)

    result = score


proc main(): void =

    var main_score = 0

    let f = open("./input.txt")
    for line in f.lines():
        let game = line.split()

        let me = game[1]
        let opponent = game[0]
        
        let outcome = second_mapping[game[1]]
        let my_move = mapping[me]
        let opponent_move = mapping[opponent]

        main_score += reverse(outcome, opponent_move)
        
    echo main_score

when isMainModule:
    main()